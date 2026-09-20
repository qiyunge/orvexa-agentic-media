from fastembed import TextEmbedding
from pathlib import Path

class FastEmbedAdapter:
    def __init__(self, 
                 model_name: str ,
                 cache_dir: str ) -> None:
        cache_path = Path(cache_dir)
        cache_path.mkdir(parents=True, exist_ok=True)

        self._model = TextEmbedding(model_name, cache_dir=str(cache_path))

    def embed(self, text: list[str]) -> list[list[float]]:
        embeddings = self._model.embed(text, normalize=True)
        return [embedding.tolist() for embedding in embeddings]
