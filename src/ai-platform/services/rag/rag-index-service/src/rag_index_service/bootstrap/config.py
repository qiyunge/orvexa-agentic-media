from pydantic import BaseModel
from pydantic_settings import BaseSettings, SettingsConfigDict

class FastEmbedConfig(BaseModel):
    model_name: str = "sentence-transformers/all-MiniLM-L6-v2"
    cache_dir: str = "/models/fastembed"

class VectorStoreConfig(BaseModel):
    url: str = "http://localhost:6333"
    collection_name: str = "rag_index"
    api_key: str | None = None
    

class ChunkerConfig(BaseModel):
    chunk_size: int = 100
    overlap: int = 10

class Config(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env",
                                        env_file_encoding="utf-8",
                                      env_nested_delimiter="__")
    embedder: FastEmbedConfig = FastEmbedConfig()
    vector_store: VectorStoreConfig = VectorStoreConfig()
    chunker: ChunkerConfig = ChunkerConfig()