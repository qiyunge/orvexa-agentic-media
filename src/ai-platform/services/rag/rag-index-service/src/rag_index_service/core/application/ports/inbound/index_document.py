from dataclasses import dataclass
from typing import Protocol, Any

@dataclass(frozen=True, slots=True)
class IndexDocumentCommand:
    document_id: str
    document_content: str
    document_metadata: dict[str, Any]

@dataclass(frozen=True, slots=True)
class IndexDocumentResponse:
    document_id: str
    chunks_count: int

class IndexDocumentUseCase(Protocol):
    def execute(self, command: IndexDocumentCommand) -> IndexDocumentResponse: ...