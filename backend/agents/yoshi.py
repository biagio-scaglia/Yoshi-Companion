import requests
import json
from backend.agents.base import Agent
from backend.persona import get_yoshi_prompt

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL_NAME = "llama3.2"


class YoshiAgent(Agent):
    """
    The main conversational agent. Uses Ollama (Llama 3.2) to generate
    comforting responses in Yoshi's persona.
    """

    def __init__(self):
        super().__init__(name="Yoshi")

    def process(self, input_text: str, context: dict = None) -> str:
        # 1. Retrieve context if provided (usually from Orchestrator passing RAG data)
        rag_content = context.get("rag_content", "") if context else ""

        # 2. Build Prompt
        prompt = get_yoshi_prompt(input_text, rag_content)

        # 3. Generate Response (Non-streaming for internal logic, but we usually stream in main)
        # Note: In the streaming architecture of main.py, this process method might return a generator
        # or we might keep the logic in main. For this agent abstraction, let's return the prompt
        # so the main thread can stream it, OR we implement a geneator here.

        return prompt

    def stream_process(self, input_text: str, context: dict = None):
        rag_content = context.get("rag_content", "") if context else ""
        prompt = get_yoshi_prompt(input_text, rag_content)

        payload = {
            "model": MODEL_NAME,
            "prompt": prompt,
            "stream": True,
            "options": {"temperature": 0.7, "stop": ["<|user|>", "User:"]},
        }

        try:
            with requests.post(OLLAMA_URL, json=payload, stream=True) as response:
                if response.status_code == 200:
                    for line in response.iter_lines():
                        if line:
                            data = json.loads(line)
                            token = data.get("response", "")
                            yield token
                            if data.get("done", False):
                                break
                else:
                    yield f"Yoshi is confused... (Ollama Error: {response.status_code}) 😵"
        except Exception as e:
            yield f"Yoshi can't reach his brain! (Connection Error) 🦕\n{e}"
