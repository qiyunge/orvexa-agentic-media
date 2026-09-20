#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
SHARED_ENV_FILE="${RELEASE_DIR}/config/shared.env"
STACK_DIR="${RELEASE_DIR}/services/rag"

if [[ ! -f "${SHARED_ENV_FILE}" ]]; then
    echo "Shared environment file not found: ${SHARED_ENV_FILE}"
    exit 1
fi

source "${SHARED_ENV_FILE}"

if [[ ! -f "${STACK_DIR}/compose.yaml" ]]; then
    echo "Stack directory not found: ${STACK_DIR}"
    exit 1
fi

docker compose \
    --project-name orvexa-rag-stack \
    --project-directory "${STACK_DIR}" \
    --env-file "${SHARED_ENV_FILE}" \
    --env-file "${STACK_DIR}/config.env" \
    --file "${STACK_DIR}/compose.yaml" \
    --file "${STACK_DIR}/compose.prod.yaml" \
    up -d --pull missing