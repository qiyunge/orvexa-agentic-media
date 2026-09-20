from fastapi import APIRouter
from pydantic import BaseModel, Field

from rag_index_service.core.application.ports.inbound import IndexDocumentUseCase, IndexDocumentCommand, IndexDocumentResponse

class IndexDocumentHttpRequest(BaseModel):
    document_id: str 
    document_content: str 
    document_metadata: dict = Field(default_factory=dict)

class IndexDocumentHttpResponse(BaseModel):
    document_id: str
    chunks_count: int

def create_document_index_router(index_document_use_case: IndexDocumentUseCase) -> APIRouter:
    router = APIRouter(prefix="/documents", tags=["documents"])

    @router.post("")
    def index_document_endpoint(request: IndexDocumentHttpRequest) -> IndexDocumentHttpResponse:
        command = IndexDocumentCommand(
            document_id=request.document_id,
            document_content=request.document_content,
            document_metadata=request.document_metadata
        )
        response = index_document_use_case.execute(command)
        return IndexDocumentHttpResponse(
            document_id=response.document_id,
            chunks_count=response.chunks_count
        )

        
    return router