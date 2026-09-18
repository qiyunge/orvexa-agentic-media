#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
STACK_DIR="${RELEASE_ROOT}/infra/observability"
TRACING_STACK_DIR="${STACK_DIR}/tracing"

# tracing stack 
ENV_FILE_TRACING="${1:-${TRACING_STACK_DIR}/.env}"


if [[ ! -f "${ENV_FILE_TRACING}" ]]; then
    echo "Missing environment file: ${ENV_FILE_TRACING}" >&2
    exit 1
fi


NETWORK_NAME="orvexa-observability-network"

${SCRIPT_DIR}/remove-networks.sh "orvexa-observability-network"

docker compose \
    --project-name orvexa-observability-tracing \
    --project-directory "${TRACING_STACK_DIR}" \
    --env-file "${ENV_FILE_TRACING}" \
    -f "${TRACING_STACK_DIR}/compose.yaml" \
    -f "${TRACING_STACK_DIR}/compose.dev.yaml" \
    down

