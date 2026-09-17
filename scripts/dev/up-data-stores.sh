#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/../../" && pwd)"
STACK_DIR="${ROOT_DIR}/infra/data-stores"

if [[ ! -f "${STACK_DIR}/.env" ]]; then
    echo "Error: .env file not found in ${STACK_DIR}" >&2
    echo "Please create it from .env.example and try again." >&2
    exit 1
fi

docker network inspect orvexa-data-network >/dev/null 2>&1 || docker network create orvexa-data-network

docker compose \
    --project-name orvexa-data-stores \
    --project-directory "${STACK_DIR}" \
    --env-file "${STACK_DIR}/.env" \
    -f "${STACK_DIR}/compose.yaml" \
    -f "${STACK_DIR}/compose.dev.yaml" \
    up -d