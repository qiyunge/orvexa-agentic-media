FROM ghcr.io/astral-sh/uv:0.12.13 AS uv
FROM python:3.12-slim-bookworm AS builder

COPY --from=uv /uv /uvx /bin/

WORKDIR /app

COPY pyproject.toml uv.lock README.md ./

RUN uv sync \
   --frozen \
   --no-dev \
   --no-cache \
   --no-install-project 
   

COPY src ./src

RUN uv sync \
    --frozen \
    --no-dev \
    --no-editable \
    --no-cache 
    
FROM python:3.12-slim-bookworm AS runtime

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv
RUN mkdir -p /models && chown -R 10001:10001 /models

USER 10001

EXPOSE 8000

CMD ["/app/.venv/bin/uvicorn", "rag_index_service.main:app", "--host", "0.0.0.0", "--port", "8000"]