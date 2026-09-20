from rag_index_service.core.domain import Chunk, Document

from  rag_index_service.core.application.ports.outbound import ChunkerPort, EmbedderPort, VectorStorePort
from rag_index_service.core.application.ports.inbound import IndexDocumentUseCase, IndexDocumentCommand, IndexDocumentResponse
from rag_index_service.core.application.services.index_document import IndexDocumentService

class FakeChunker(ChunkerPort):
    def split(self, document:Document) -> list[Chunk]:
        return [Chunk(id=f"chunk_{1}", 
                    document_id=document.id,
                    content=f"hello", 
                    position=0,
                    metadata={}) ,
                Chunk(
                    id=f"chunk_{2}",
                    document_id=document.id,
                    content=f"world",
                    position=1,
                    metadata={})
                ]

class FakeEmbedder(EmbedderPort):
    def embed(self, chunks:list[str]) -> list[list[float]]:
        return [[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]]

class FakeVectorStore(VectorStorePort):
    def __init__(self) -> None:
        self._chunks = None
        self._vectors = None

    def upsert(self, chunks:list[Chunk], vectors:list[list[float]]) -> None:
        self._chunks = chunks
        self._vectors = vectors

  
class TestIndexDocumentService:
    def test_index_document(self) -> None:
        vector_store = FakeVectorStore()
        service = IndexDocumentService(chunker=FakeChunker(), embedder=FakeEmbedder(), vector_store=vector_store)

        command = IndexDocumentCommand(document_id="test_document_id", document_content="hello world", document_metadata={"source": "test_source"})
        response = service.execute(command)
        assert response.document_id == "test_document_id"
        assert response.chunks_count == 2
        assert len(vector_store._chunks) == 2
        assert vector_store._vectors == [[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]]