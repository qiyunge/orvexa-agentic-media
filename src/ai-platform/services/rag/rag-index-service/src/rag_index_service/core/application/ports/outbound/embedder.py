from typing import Protocol

from rag_index_service.core.domain import Chunk

class EmbedderPort(Protocol):
    def embed(self, text:list[str]) -> list[list[float]]: ...