#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
STACK_DIR="${RELEASE_ROOT}/src/ai-platform"

ENV_FILE="${1:-${STACK_DIR}/.env}"
NETWORK_NAME="orvexa-dc1-network"

if [[ ! -f "${ENV_FILE}" ]]; then
    echo "Missing environment file: ${ENV_FILE}" >&2
    exit 1
fi

docker network inspect "${NETWORK_NAME}" >/dev/null 2>&1 ||
    docker network create "${NETWORK_NAME}"

docker compose \
    --project-name orvexa-ai-platform \
    --project-directory "${STACK_DIR}" \
    --env-file "${ENV_FILE}" \
    -f "${STACK_DIR}/compose.yaml" \
    -f "${STACK_DIR}/compose.dev.yaml" \
    up -d --wait --build 
