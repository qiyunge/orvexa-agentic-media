FROM ghcr.io/astral-sh/uv:0.12.13 AS uv
FROM python:3.12-slim-bookworm

COPY --from=uv /uv /uvx /bin/

WORKDIR /app

COPY pyproject.toml uv.lock README.md ./

RUN uv sync --frozen --no-dev  --no-cache --no-install-project \
    && mkdir -p /models/fastembed \
    && chown -R 10001:10001 /app /models

COPY src ./src

RUN uv sync --frozen --no-dev --no-editable --no-cache  \
    && mkdir -p /models/fastembed \
    && chown -R 10001:10001 /app /models
USER 10001

EXPOSE 8000

CMD ["/app/.venv/bin/uvicorn", "rag_index_service.main:app", "--host", "0.0.0.0", "--port", "8000"]