#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"

STACK_DIR="${RELEASE_ROOT}/infra/data-stores"

ENV_FILE_QDRANT="${STACK_DIR}/config.env}"

if [[ ! -f "${ENV_FILE_QDRANT}" ]]; then
    echo "Missing environment file: ${ENV_FILE_QDRANT}" >&2
    exit 1
fi

${SCRIPT_DIR}/init-networks.sh

docker compose \
    --project-name orvexa-infra-data-stores \
    --project-directory "${STACK_DIR}" \
    --env-file "${ENV_FILE_QDRANT}" \
    -f "${STACK_DIR}/compose.yaml" \
    -f "${STACK_DIR}/compose.dev.yaml" \
    up -d --profile qdrant --wait --pull missing 


