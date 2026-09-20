from dataclasses import dataclass, field
from typing import Any

@dataclass(frozen=True, slots=True)
class Chunk:
    id: str
    document_id: str
    position: int
    content: str
    metadata: dict[str, Any] = field(default_factory=dict)

    def __post_init__(self) -> None:
        if not self.id:
            raise ValueError("Chunk ID is required")
        
        if not self.document_id:
            raise ValueError("Document ID is required")
        
        if self.position < 0:
            raise ValueError("Chunk position must be greater than 0")
        
        if not self.content.strip():
            raise ValueError("Chunk content cannot be empty")
        
     