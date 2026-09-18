#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"


NETWORK_NAME="orvexa-observability-network"

docker network inspect "${NETWORK_NAME}" >/dev/null 2>&1 ||
    docker network create "${NETWORK_NAME}"
    
${SCRIPT_DIR}/up-logging.sh
${SCRIPT_DIR}/up-metrics.sh
${SCRIPT_DIR}/up-tracing.sh



