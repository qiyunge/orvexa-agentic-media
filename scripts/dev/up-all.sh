#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

"${SCRIPT_DIR}/init-networks.sh"
"${SCRIPT_DIR}/up-data-stores.sh"
"${SCRIPT_DIR}/up-observability.sh"
"${SCRIPT_DIR}/up-ai-platform.sh" 
"${SCRIPT_DIR}/up-edge.sh"

echo "Orvexa development environment started."
  