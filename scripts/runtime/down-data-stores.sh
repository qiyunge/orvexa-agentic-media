#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
STACK_DIR="${RELEASE_ROOT}/infra/data-stores"
ENV_FILE="${1:-/etc/orvexa/.env}"

docker compose \
    --project-name orvexa-data-stores \
    --project-directory "${STACK_DIR}" \
    --env-file "${ENV_FILE}" \
    -f "${STACK_DIR}/compose.yaml" \
    down


remove_network() {
    local network_name="$1"

    if ! docker network inspect "${network_name}" >/dev/null 2>&1; then
        return
    fi

    local container_count
    container_count="$(
        docker network inspect \
            --format '{{len .Containers}}' \
            "${network_name}"
    )"

    if [[ "${container_count}" -eq 0 ]]; then
        docker network rm "${network_name}"
    else
        echo "Network ${network_name} is still in use; keeping it." >&2
    fi
}

trap 'remove_network "orvexa-data-network"' EXIT