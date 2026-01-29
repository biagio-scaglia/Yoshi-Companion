from backend.agents.base import Agent
from backend.brain import search


class LibrarianAgent(Agent):
    """
    Agent responsible for searching the Knowledge Base (DuckDB)
    and retrieving facts about Yoshi or content from uploaded PDFs.
    """

    def __init__(self):
        super().__init__(
            name="Librarian Kamek"
        )  # Kamek is smart (but we make him good here, or maybe 'Professor E. Gadd'?) Let's stick to a smart Yoshi. "Dr. Yoshi"
        self.name = "Librarian Yoshi (Glasses)"

    def process(self, input_text: str, context: dict = None) -> str:
        self.logger.info(f"Searching knowledge for: {input_text}")

        # Search in DuckDB
        results = search(input_text, limit=3)

        if not results:
            return "Yoshi looked in all the books but found nothing... *sad mlem*"

        return f"Here is what Yoshi found in the library! 📚:\n\n{results}"
