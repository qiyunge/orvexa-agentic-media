
#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"

${SCRIPT_DIR}/pre-dist.sh
${SCRIPT_DIR}/build-infra.sh
${SCRIPT_DIR}/build-rag.sh

echo "Built All"