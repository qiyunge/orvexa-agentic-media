#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"

STACK_DIR="${PROJECT_ROOT}/infra/event-platform"
ENV_FILE="${1:-${STACK_DIR}/.env}"

docker compose \
    --project-name orvexa-event-platform \
    --project-directory "${STACK_DIR}" \
    --env-file "${ENV_FILE}" \
    -f "${STACK_DIR}/compose.yaml" \
    -f "${STACK_DIR}/compose.dev.yaml" \
    down --remove-orphans