from qdrant_client import QdrantClient
from qdrant_client.models import PointStruct

from rag_index_service.core.domain import Chunk

class QdrantVectorStoreAdapter:
    def __init__(
        self,
        qdrant_url: str,
        collection_name: str,
        qdrant_api_key: str | None,
    ) -> None:
        self._client = QdrantClient(url=qdrant_url, api_key=qdrant_api_key)
        self._collection_name = collection_name

    def upsert(self, 
    chunks: list[Chunk], 
    vectors: list[list[float]]) -> None:
        if len(chunks) != len(vectors):
            raise ValueError("Number of chunks and vectors must be the same")
        
        points = [
            PointStruct(
                id=chunk.id, 
                vector=vector, 
                payload={
                    "document_id": chunk.document_id,
                    "content": chunk.content,
                    "position": chunk.position,
                    "metadata": chunk.metadata,
                })
                
            for chunk, vector in zip(chunks, vectors)
        ]
        
        self._client.upsert(collection_name=self._collection_name, points=points)