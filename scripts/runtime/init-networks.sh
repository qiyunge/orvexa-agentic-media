#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_DIR="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
SHARED_ENV_FILE="${RELEASE_DIR}/config/shared.env"

set -a
source "${SHARED_ENV_FILE}"
set +a

create_network() {
    local network_name="$1"

    if docker network inspect "${network_name}" >/dev/null 2>&1; then
        echo "Network already exists: ${network_name}"
    else
        docker network create "${network_name}"
        echo "Created network: ${network_name}"
    fi
}

create_network "${ORVEXA_DC_NETWORK_NAME}"
create_network "${ORVEXA_RAG_NETWORK_NAME}"

echo "Networks initialized"