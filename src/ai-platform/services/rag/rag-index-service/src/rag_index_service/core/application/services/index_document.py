from rag_index_service.core.domain import Document

from rag_index_service.core.application.ports.inbound  import IndexDocumentUseCase, IndexDocumentCommand, IndexDocumentResponse
from rag_index_service.core.application.ports.outbound import EmbedderPort, ChunkerPort, VectorStorePort

class IndexDocumentService(IndexDocumentUseCase):
    def __init__(self, chunker: ChunkerPort, embedder: EmbedderPort, vector_store: VectorStorePort) -> None:
        self._embedder = embedder
        self._chunker = chunker
        self._vector_store = vector_store

    def execute(self, command: IndexDocumentCommand) -> IndexDocumentResponse:
        document = Document(
            id=command.document_id, 
            content=command.document_content,
            metadata=command.document_metadata)
        chunks = self._chunker.split(document)
        vectors = self._embedder.embed([chunk.content for chunk in chunks])
        self._vector_store.upsert(chunks, vectors)
        return IndexDocumentResponse(document_id=command.document_id, chunks_count=len(chunks))