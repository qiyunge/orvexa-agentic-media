#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
STACK_DIR="${RELEASE_ROOT}/infra/observability"
METRICS_STACK_DIR="${STACK_DIR}/metrics"

# metrics stack 
ENV_FILE_METRICS="${1:-${METRICS_STACK_DIR}/.env}"


if [[ ! -f "${ENV_FILE_METRICS}" ]]; then
    echo "Missing environment file: ${ENV_FILE_METRICS}" >&2
    exit 1
fi


NETWORK_NAME="orvexa-observability-network"

${SCRIPT_DIR}/remove-networks.sh "orvexa-observability-network"

docker compose \
    --project-name orvexa-observability-metrics \
    --project-directory "${METRICS_STACK_DIR}" \
    --env-file "${ENV_FILE_METRICS}" \
    -f "${METRICS_STACK_DIR}/compose.yaml" \
    -f "${METRICS_STACK_DIR}/compose.dev.yaml" \
    down

