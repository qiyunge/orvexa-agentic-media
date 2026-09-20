from fastapi import FastAPI
import uvicorn 

from rag_index_service.bootstrap.container import Config
from rag_index_service.adapters.inbound.api.routes import create_api_routes
from rag_index_service.bootstrap.container import Container

settings = Config()
container = Container(settings)
app = FastAPI(
    title="RAG Index Service",
    description="RAG Index Service",
   
)
app.include_router(create_api_routes(container))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000) 