from pathlib import Path

import pytest

from rag_index_service.adapters.outbound.embedding.fastembed import FastEmbedAdapter
from rag_index_service.bootstrap.config import VectorStoreConfig

class TestFastEmbedAdapter:

    @pytest.fixture
    def embedder(self, tmp_path: Path) -> FastEmbedAdapter:
        return FastEmbedAdapter(model_name="sentence-transformers/all-MiniLM-L6-v2", cache_dir=tmp_path)
    
    def test_embed_single_text(self, embedder: FastEmbedAdapter) -> None:
        text = "Hello, world!"
        vectors = embedder.embed([text])
        assert len(vectors) == 1
        assert len(vectors[0]) > 0
       
    
    def test_embed_multiple_texts(self, embedder: FastEmbedAdapter) -> None:
        texts = ["Hello, world!", "Hello, universe!"]
        vectors = embedder.embed(texts)
        assert len(vectors) == 2

    def test_vector_length_is_consistent(self, embedder: FastEmbedAdapter) -> None:
        texts = ["Hello, world!", "This is a much longer sentence!"]
        vectors = embedder.embed(texts)
        assert len(vectors[0]) == len(vectors[1])
        assert len(vectors[0]) > 0

    def test_returns_plain_python_lists(self, embedder: FastEmbedAdapter) -> None:
        texts = ["Hello, world!", "This is a much longer sentence!"]
        vectors = embedder.embed(texts)
        assert isinstance(vectors, list)
        assert isinstance(vectors[1], list)
        assert all(isinstance(x, float) for x in vectors[0])
        assert all(isinstance(x, float) for x in vectors[1])

   