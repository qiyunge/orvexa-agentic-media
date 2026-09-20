from typing import Protocol

from rag_index_service.core.domain import Chunk

class VectorStorePort(Protocol):
    def upsert(self, chunks: list[Chunk], vectors: list[list[float]]) -> None: ...