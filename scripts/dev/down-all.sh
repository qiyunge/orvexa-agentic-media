#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

"${SCRIPT_DIR}/down-edge.sh"
"${SCRIPT_DIR}/down-ai-platform.sh"
"${SCRIPT_DIR}/down-observability.sh"
"${SCRIPT_DIR}/down-data-stores.sh"
"${SCRIPT_DIR}/remove-networks.sh"

echo "Orvexa development environment stopped."