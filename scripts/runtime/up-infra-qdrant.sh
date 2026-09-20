#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
INFRA_DIR="${RELEASE_ROOT}/infra"
STACK_DIR="${INFRA_DIR}/data-stores"

ENV_FILE_QDRANT="${STACK_DIR}/config.env"

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
    --profile qdrant \
    up -d --wait --pull missing 


