from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from llama_cpp import Llama
import uvicorn
import os
import shutil
from loguru import logger
from backend.persona import get_yoshi_prompt
from backend.brain import init_db, ingest_text, search
import psutil
from pypdf import PdfReader

# Try importing Llama, handle failure gracefully
try:
    from llama_cpp import Llama

    HAS_LLAMA = True
except ImportError:
    logger.warning("llama-cpp-python not installed! Running in Mock/Ollama mode.")
    HAS_LLAMA = False


# Initialize App
app = FastAPI(title="Yoshi Comfort Bot 🦕")

# Model Path (adjust as needed)
MODEL_PATH = "../models/Llama-3.2-3B-Instruct-Q4_K_M.gguf"

# Global Model Variable
llm = None


@app.on_event("startup")
def startup_event():
    global llm
    logger.info("Waking up Yoshi... 🥚")
    init_db()

    if HAS_LLAMA:
        if not os.path.exists(MODEL_PATH):
            logger.error(f"Model not found at {MODEL_PATH}")
            # Don't raise, just log to allow mock mode if user wants
            logger.warning("Continuing without model...")
        else:
            try:
                llm = Llama(model_path=MODEL_PATH, n_ctx=2048, verbose=False)
                logger.success("Yoshi is ready! 🦕")
            except Exception as e:
                logger.error(f"Failed to load Llama: {e}")
    else:
        logger.warning("Yoshi is running in MOCK MODE (No Llama).")


class ChatRequest(BaseModel):
    message: str


@app.post("/chat")
async def chat(request: ChatRequest):
    logger.info(f"User says: {request.message}")

    # 1. Search Brain (RAG)
    context = search(request.message)
    if context:
        logger.info("Yoshi found something in his brain! 🧠")

    # 2. Build Prompt
    prompt = get_yoshi_prompt(request.message, context)

    # 3. Stream Response
    def stream_response():
        if llm:
            stream = llm.create_completion(
                prompt,
                max_tokens=512,
                stop=["<|user|>", "User:"],
                stream=True,
                temperature=0.7,
            )
            for output in stream:
                token = output["choices"][0]["text"]
                yield token
        else:
            # Mock Response
            import time

            mock_text = "Yoshi! I can't find my brain (llama-cpp-python), so I'm pretending! 🦕 Check the logs!"
            for word in mock_text.split():
                yield word + " "
                time.sleep(0.1)

    return StreamingResponse(stream_response(), media_type="text/plain")


@app.post("/ingest")
async def upload_pdf(file: UploadFile = File(...)):
    if not file.filename.endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Yoshi only reads PDFs! 📄")

    temp_path = f"temp_{file.filename}"
    with open(temp_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    try:
        reader = PdfReader(temp_path)
        text = ""
        for page in reader.pages:
            text += page.extract_text() + "\n"

        ingest_text(file.filename, text)
        return {"status": "success", "message": f"Yoshi read {file.filename}! 📚"}
    except Exception as e:
        logger.error(f"Error reading PDF: {e}")
        raise HTTPException(
            status_code=500, detail="Yoshi couldn't read that file... 😢"
        )
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)


@app.get("/health")
def health():
    cpu = psutil.cpu_percent()
    ram = psutil.virtual_memory().percent
    return {"status": "ok", "mood": "Happy 🦕", "cpu": cpu, "ram": ram}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
