from dataclasses import dataclass, field
from typing import Any

@dataclass(frozen=True, slots=True)
class Document:
    id: str
    content: str
    metadata: dict[str, Any] = field(default_factory=dict)

    def __post_init__(self) -> None:
        if not self.id:
            raise ValueError("Document ID is required")
        
        if not self.content.strip():
            raise ValueError("Document content is required")
        
