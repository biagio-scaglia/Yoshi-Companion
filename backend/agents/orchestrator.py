from backend.agents.base import Agent
from backend.agents.yoshi import YoshiAgent
from backend.agents.librarian import LibrarianAgent


class Orchestrator(Agent):
    """
    Decides which agent should handle the request.
    - Emotional/Chat -> YoshiAgent
    - Factual/Knowledge -> LibrarianAgent -> YoshiAgent (Synthesized)
    """

    def __init__(self):
        super().__init__(name="Orchestrator")
        self.yoshi = YoshiAgent()
        self.librarian = LibrarianAgent()

    def process(self, input_text: str, context: dict = None) -> str:
        """
        Synchronous wrapper around process_stream for ABC compliance.
        """
        return "".join(list(self.process_stream(input_text)))

    def process_stream(self, input_text: str):
        """
        Determines intent and yields a stream of response tokens.
        """
        # Simple Keyword-based Intent Classification for now (Fast & Robust)
        # Later we can use a small LLM call for this.

        input_lower = input_text.lower()

        is_knowledge_query = any(
            word in input_lower
            for word in [
                "read",
                "file",
                "document",
                "pdf",
                "what does it say",
                "summarize",
                "info",
                "fact",
                "search",
                "lookup",
                "who is",
                "where is",
            ]
        )

        rag_context = ""

        if is_knowledge_query:
            self.logger.info("Intent: KNOWLEDGE REQUEST/RAG")
            # 1. Get info from Librarian (Synchronous)
            rag_context = self.librarian.process(input_text)
            self.logger.info(f"Librarian found: {rag_context[:50]}...")

            # 2. Pass info to Yoshi to explain it
            # Yoshi synthesizes the dry facts into a cute response
            yield from self.yoshi.stream_process(
                input_text, context={"rag_content": rag_context}
            )

        else:
            self.logger.info("Intent: CHAT/COMFORT")
            # Direct chat with Yoshi
            yield from self.yoshi.stream_process(input_text)
