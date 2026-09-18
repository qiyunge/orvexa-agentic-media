#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"


NETWORK_NAME="orvexa-observability-network"

${SCRIPT_DIR}/remove-network.sh "${NETWORK_NAME}"
    
${SCRIPT_DIR}/down-logging.sh

${SCRIPT_DIR}/down-metrics.sh

${SCRIPT_DIR}/down-tracing.sh

