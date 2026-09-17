# rag-index-service

`rag-index-service` is the write side of Orvexa's first RAG subsystem. It owns
the synchronous vertical slice:

```text
document text -> chunks -> embeddings -> Qdrant points
```

It intentionally does **not** use LangChain. The application layer depends on
small Python protocols (`Chunker`, `Embedder`, and `VectorStore`), while the
first concrete adapters use FastEmbed and Qdrant directly. FastEmbed uses an
ONNX runtime, so the CPU image does not pull a multi-gigabyte CUDA/PyTorch stack.

Inside the Orvexa monorepo, keep this directory at
`services/rag-index-service/`. It is part of the overall system but remains an
independently buildable and testable deployable, with its own `pyproject.toml`,
lockfile, Dockerfile, README, source tree, and tests.

## Service boundary

This service accepts text that has already been extracted from its source. PDF,
HTML, object-storage, and crawler ingestion belong in upstream loader workers;
keeping extraction out of this API prevents file-format work from being coupled
to chunking and vector persistence.

The first endpoint is deliberately one-document-at-a-time:

- `POST /v1/documents`: replace one logical document in the vector index.
- `GET /health/live`: confirm the process is alive.
- `GET /health/ready`: confirm Qdrant is reachable.

Each successful write stores the chunk text plus `document_id`, content hash,
chunk index, source URI, and caller-provided metadata in the Qdrant payload.
The adapter creates a keyword payload index on `document_id` because replacement
deletes use that field as a filter. Collection metadata records the embedding
model and schema version; writes fail fast if a service points at a collection
created for a different vector space.

## Architecture

The HTTP route invokes `IndexDocument`, which talks only to the three application
ports. The dependency container binds those ports to the concrete character
chunker, FastEmbed, and Qdrant adapters. The handler moves synchronous embedding
and Qdrant work to a worker thread so it does not block the event loop.

| Path | Responsibility |
| --- | --- |
| `api/` | HTTP schemas, status codes, and routes |
| `application/` | Indexing use case and dependency ports |
| `domain/` | Framework-free document, chunk, result, and error types |
| `infrastructure/` | Character chunker, FastEmbed, and Qdrant adapters |
| `tests/` | Unit, API, and in-memory Qdrant tests |

## Run locally

Start Qdrant and the service:

```bash
docker compose -f compose.dev.yaml up --build
```

The first start downloads the configured embedding model. When the service is
ready, its OpenAPI page is available at `http://localhost:8001/docs`.

Index a document:

```bash
curl -X POST http://localhost:8001/v1/documents \
  -H 'Content-Type: application/json' \
  -d '{
    "document_id": "orvexa-architecture-v1",
    "text": "Orvexa coordinates model inference, tools, evaluation, and retry policies.",
    "source_uri": "docs://architecture/overview.md",
    "metadata": {
      "project": "orvexa",
      "language": "en"
    }
  }'
```

Example response:

```json
{
  "document_id": "orvexa-architecture-v1",
  "collection": "orvexa_documents",
  "content_sha256": "...",
  "chunks_indexed": 1,
  "embedding_model": "BAAI/bge-small-en-v1.5",
  "vector_size": 384
}
```

## Run without Docker

```bash
cp .env.example .env
uv sync
uv run uvicorn rag_index_service.main:app --reload --port 8001
```

Qdrant must be reachable at `RAG_INDEX_QDRANT_URL`.

## Configuration

All variables use the `RAG_INDEX_` prefix.

| Variable | Default | Meaning |
| --- | --- | --- |
| `QDRANT_URL` | `http://localhost:6333` | Shared Qdrant HTTP endpoint |
| `QDRANT_API_KEY` | unset | Optional Qdrant credential |
| `QDRANT_COLLECTION` | `orvexa_documents` | Collection used by index and inference |
| `EMBEDDING_MODEL` | `BAAI/bge-small-en-v1.5` | FastEmbed model ID |
| `EMBEDDING_CACHE_DIR` | library default | Local model cache directory |
| `EMBEDDING_BATCH_SIZE` | `32` | Texts embedded in one model batch |
| `CHUNK_SIZE` | `1000` | Maximum normalized characters per chunk |
| `CHUNK_OVERLAP` | `150` | Approximate character overlap |

The table omits the `RAG_INDEX_` prefix from the first column for readability.

## Tests

The tests have no embedding-model download or database-server dependency; the
Qdrant adapter test uses the client's in-memory mode:

```bash
PYTHONPATH=src python -m unittest discover -s tests -v
```

## Replica and data invariants

- Service containers are stateless. Every replica points to the same Qdrant
  collection.
- `document_id` is a stable logical identity supplied by the caller.
- Re-indexing uses replace semantics: delete all old points for `document_id`,
  then upsert the newly embedded chunks.
- Point UUIDs are deterministic for `(document_id, content hash, chunk index)`.
- The index and inference services must use the same embedding model and vector
  dimension for a collection. Qdrant collection metadata enforces the model ID;
  the collection vector schema enforces its dimension. On the query side, use
  FastEmbed's query embedding path for the same model.
- Route a given `document_id` through one writer at a time. The current
  delete-then-upsert operation is idempotent but is not a cross-replica lock.

For the two-data-center Compose topology, deploy separate service replicas on
`dc1-network` and `dc2-network`; do not attach a service container to both DC
networks. The shared Qdrant infrastructure can be reachable from both networks.

## Deliberate first-version limits

- The request is synchronous; a later index-job queue should absorb large files
  and retries.
- Chunk sizing is character-based, not tokenizer-aware.
- The API accepts extracted text only; source loaders are separate adapters or
  workers.
- Concurrent replacement of the same `document_id` needs queue partitioning or
  a distributed lock before production use.
- Authentication, rate limiting, metrics, tracing, and dead-letter handling
  belong at the gateway/platform layers in the next iteration.
