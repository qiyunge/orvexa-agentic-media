from rag_index_service.core.domain import Document, Chunk

class FixedSizeChunkerAdapter:
    def __init__(self,
                 chunk_size: int  = 500,
                 chunk_overlap: int = 50) -> None:
        if chunk_size <= chunk_overlap:
            raise ValueError("Chunk size must be greater than chunk overlap")
        if chunk_size <= 0:
            raise ValueError("Chunk size must be greater than 0")
        if chunk_overlap < 0:
            raise ValueError("Chunk overlap must be greater than 0")
        
        self._chunk_size = chunk_size
        self._chunk_overlap = chunk_overlap

    def split(self, document: Document) -> list[Chunk]:
        chunks = []
        step = self._chunk_size - self._chunk_overlap

        for position ,start in enumerate(range(0, len(document.content), step)):
            end = start + self._chunk_size
            chunk_content = document.content[start:end]

            if not chunk_content.strip():
                continue
            
            chunks.append(Chunk(
                id=f"{document.id}:{position}",
                document_id=document.id,
                position=position,
                content=chunk_content,
                metadata=document.metadata.copy()))
        return chunks