from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
import uvicorn
import os
import shutil
from loguru import logger
from backend.agents.orchestrator import Orchestrator
from backend.brain import init_db, ingest_text
import psutil
import glob
from pypdf import PdfReader


# Initialize App
app = FastAPI(title="Yoshi Comfort Bot 🦕")

# Model Path (adjust as needed)
MODEL_PATH = "../models/Llama-3.2-3B-Instruct-Q4_K_M.gguf"

# Global Orchestrator
orchestrator = None


@app.on_event("startup")
def startup_event():
    global orchestrator
    logger.info("Yoshi System Booting... 🥚")
    init_db()

    # Ingest Static Knowledge
    knowledge_files = glob.glob("backend/knowledge/*.md")
    for kf in knowledge_files:
        try:
            with open(kf, "r", encoding="utf-8") as f:
                content = f.read()
                ingest_text(kf, content)
                logger.info(f"Ingested knowledge: {kf}")
        except Exception as e:
            logger.error(f"Failed to ingest {kf}: {e}")

    # Initialize Orchestrator
    # Now using Ollama internally
    orchestrator = Orchestrator()
    logger.success("Orchestrator Ready (Connected to Ollama)! 🎶")


class ChatRequest(BaseModel):
    message: str


@app.post("/chat")
async def chat(request: ChatRequest):
    logger.info(f"User says: {request.message}")

    return StreamingResponse(
        orchestrator.process_stream(request.message), media_type="text/plain"
    )


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
