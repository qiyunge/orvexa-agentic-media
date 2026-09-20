from fastapi import APIRouter
from rag_index_service.bootstrap.container import Container
from rag_index_service.adapters.inbound.api.document import create_document_index_router

def create_api_routes(container: Container) -> APIRouter:
    router = APIRouter()
    router.include_router(create_document_index_router(container.index_document))
    return router