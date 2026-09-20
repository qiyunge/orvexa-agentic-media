import pytest

from rag_index_service.adapters.outbound.chunker.fixed_size_chunker_adapter import FixedSizeChunkerAdapter
from rag_index_service.core.domain import Document

class TestFixedSizeChunkerAdapter:
    def test_chunk_document(self) -> None:
        chunker = FixedSizeChunkerAdapter(chunk_size=5, chunk_overlap=2)
        document = Document(id="test_document_id", content="abcdefghij", metadata={"source": "test_source"})

        chunks = chunker.split(document)

        assert [chunk.content for chunk in chunks] == ["abcde",
         "defgh", "ghij","j"]
    
    def test_split_preserves_document_information(self) -> None:
        chunker = FixedSizeChunkerAdapter(chunk_size=5, chunk_overlap=2)
        document = Document(id="test_document_id", content="abcdefghij", metadata={"source": "test_source"})

        chunks = chunker.split(document)

        assert chunks[0].id == "test_document_id:0"
        assert chunks[0].document_id == "test_document_id"
        assert chunks[0].position == 0
        assert chunks[0].metadata == {"source": "test_source"}
       

        assert chunks[1].id == "test_document_id:1"
        assert chunks[1].document_id == "test_document_id"
        assert chunks[1].position == 1
        assert chunks[1].metadata == {"source": "test_source"}

    def test_document_smaller_than_chunk_size_produces_one_chunk(self) -> None:
        chunker = FixedSizeChunkerAdapter(chunk_size=100, chunk_overlap=10)
        document = Document(id="test_document_id", content="hello world", metadata={"source": "test_source"})

        chunks = chunker.split(document)

        assert len(chunks) == 1
        assert chunks[0].content == "hello world"

    def test_overlap_cannot_equl_chunk_size(self) -> None:
        with pytest.raises(ValueError):
            FixedSizeChunkerAdapter(chunk_size=100, chunk_overlap=100)
    
    def test_overlap_cannot_be_greater_than_chunk_size(self) -> None:
        with pytest.raises(ValueError):
            FixedSizeChunkerAdapter(chunk_size=100, chunk_overlap=101)
    
    def test_overlap_cannot_be_negative(self) -> None:
        with pytest.raises(ValueError):
            FixedSizeChunkerAdapter(chunk_size=100, chunk_overlap=-1)
    
    def test_chunk_size_cannot_be_negative(self) -> None:
        with pytest.raises(ValueError):
            FixedSizeChunkerAdapter(chunk_size=-1, chunk_overlap=10)