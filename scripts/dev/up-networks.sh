#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_DIR="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
SHARED_ENV_FILE="${RELEASE_DIR}/config/shared.env"
STACK_DIR="${RELEASE_DIR}/infra/networks"



if [[ ! -f "${SHARED_ENV_FILE}" ]]; then
    echo "Missing environment file: ${SHARED_ENV_FILE}" >&2
    exit 1
fi

docker compose \
    --project-name orvexa-infra-networks \
    --project-directory "${STACK_DIR}" \
    --env-file "${SHARED_ENV_FILE}" \
    -f "${STACK_DIR}/compose.yaml" \
    up -d 

echo "Networks started"