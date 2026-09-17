#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
STACK_DIR="${PROJECT_ROOT}/infra/data-stores"

docker compose \
    --project-name orvexa-data-stores \
    --project-directory "${STACK_DIR}" \
    --env-file "${STACK_DIR}/.env" \
    -f "${STACK_DIR}/compose.yaml" \
    -f "${STACK_DIR}/compose.dev.yaml" \
    down