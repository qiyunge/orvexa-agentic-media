#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
STACK_DIR="${RELEASE_ROOT}/infra/observability"
LOGGING_STACK_DIR="${STACK_DIR}/logging"

# Logging stack 
ENV_FILE_LOGGING="${1:-${LOGGING_STACK_DIR}/.env}"


if [[ ! -f "${ENV_FILE_LOGGING}" ]]; then
    echo "Missing environment file: ${ENV_FILE_LOGGING}" >&2
    exit 1
fi


NETWORK_NAME="orvexa-observability-network"

${SCRIPT_DIR}/remove-network.sh "${NETWORK_NAME}"

docker compose \
    --project-name orvexa-observability-logging \
    --project-directory "${LOGGING_STACK_DIR}" \
    --env-file "${ENV_FILE_LOGGING}" \
    -f "${LOGGING_STACK_DIR}/compose.yaml" \
    -f "${LOGGING_STACK_DIR}/compose.dev.yaml" \
    down

