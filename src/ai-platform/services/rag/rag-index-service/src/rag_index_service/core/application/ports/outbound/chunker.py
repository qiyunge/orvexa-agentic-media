from typing import Protocol

from rag_index_service.core.domain import Document, Chunk

class ChunkerPort(Protocol):
    def split(self, document: Document) -> list[Chunk]: ...