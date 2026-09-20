#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

${SCRIPT_DIR}/init-networks.sh
${SCRIPT_DIR}/up-infra-qdrant.sh
