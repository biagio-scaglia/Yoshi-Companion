from backend.agents.base import Agent
from backend.persona import get_yoshi_prompt


try:
    from llama_cpp import Llama

    HAS_LLAMA = True
except ImportError:
    HAS_LLAMA = False


class YoshiAgent(Agent):
    """
    The main conversational agent. Uses the LLM to generate
    comforting responses in Yoshi's persona.
    """

    def __init__(self, llm_instance):
        super().__init__(name="Yoshi")
        self.llm = llm_instance

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

        if self.llm:
            stream = self.llm.create_completion(
                prompt,
                max_tokens=512,
                stop=["<|user|>", "User:"],
                stream=True,
                temperature=0.7,
            )
            for output in stream:
                yield output["choices"][0]["text"]
        else:
            # Mock
            import time

            mock_text = "Yoshi! No brain linked! *mlem* 🦕"
            for word in mock_text.split():
                yield word + " "
                time.sleep(0.1)
