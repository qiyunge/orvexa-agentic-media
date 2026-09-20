from pydantic_settings import BaseSettings

from .config import Config
from rag_index_service.core.application.ports.inbound import IndexDocumentUseCase
from rag_index_service.core.application.services.index_document import IndexDocumentService
from rag_index_service.core.application.ports.outbound import EmbedderPort, ChunkerPort, VectorStorePort
from rag_index_service.adapters.outbound.embedding.fastembed import FastEmbedAdapter
from rag_index_service.adapters.outbound.vector_store.qdrant import QdrantVectorStoreAdapter
from rag_index_service.adapters.outbound.chunker.fixed_size_chunker_adapter import FixedSizeChunkerAdapter

class Container:
    def __init__(self, config: Config) -> None:
        self._config = config
        self._chunker = FixedSizeChunkerAdapter(config.chunker.chunk_size, config.chunker.overlap)
        self._embedder = FastEmbedAdapter(config.embedder.model_name, config.embedder.cache_dir)
        self._vector_store = QdrantVectorStoreAdapter(config.vector_store.url, config.vector_store.collection_name, config.vector_store.api_key)    
        self._index_document_service = IndexDocumentService(self._chunker, self._embedder, self._vector_store)

    @property
    def index_document(self) -> IndexDocumentUseCase:
        return self._index_document_service

