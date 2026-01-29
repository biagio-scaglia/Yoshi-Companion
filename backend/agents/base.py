from abc import ABC, abstractmethod
from loguru import logger


class Agent(ABC):
    def __init__(self, name: str):
        self.name = name
        self.logger = logger.bind(agent=name)

    @abstractmethod
    def process(self, input_text: str, context: dict = None) -> str:
        """Process the input and return a response."""
        pass
