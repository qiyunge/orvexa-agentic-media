
#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"

RAG_DIR="${PROJECT_ROOT}/src/ai-platform/services/rag"
RAG_INDEX_SERVICE_DIR="${RAG_DIR}/rag-index-service"

DISTR_DIR="${PROJECT_ROOT}/.dist"
RAG_DISTR_DIR="${DISTR_DIR}/services/rag"
SCRIPTS_DISTR_DIR="${DISTR_DIR}/scripts"



mkdir -p \
    "${RAG_DISTR_DIR}" \
"${SCRIPTS_DISTR_DIR}"

cp "${RAG_DIR}/compose.yaml" "${RAG_DISTR_DIR}/"
cp "${RAG_DIR}/compose.prod.yaml" "${RAG_DISTR_DIR}/"
cp "${RAG_DIR}/config.env" "${RAG_DISTR_DIR}/"

cp "${SCRIPT_DIR}/../runtime/up-rag.sh" "${SCRIPTS_DISTR_DIR}/"

source "${RAG_DIR}/config.env"
docker build \
    -f "${RAG_INDEX_SERVICE_DIR}/Dockerfile" \
    -t "${RAG_INDEX_IMAGE_NAME}:${IMAGE_TAG}" \
    "${RAG_INDEX_SERVICE_DIR}"



echo "Built RAG services"