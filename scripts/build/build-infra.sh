
#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
INFRA_DIR="${PROJECT_ROOT}/infra"

DISTR_DIR="${PROJECT_ROOT}/.dist"
INFRA_DISTR_DIR="${DISTR_DIR}/infra"
SCRIPTS_DISTR_DIR="${DISTR_DIR}/scripts"


mkdir -p \
    "${INFRA_DISTR_DIR}" \
    "${SCRIPTS_DISTR_DIR}"

cp -R "${INFRA_DIR}/." "${INFRA_DISTR_DIR}/"

# Remove development-only Compose files from distribution
find "${INFRA_DISTR_DIR}" \
    -type f \
    -name "compose.dev.yaml" \
    -delete

cp "${SCRIPT_DIR}/../runtime/up-infra.sh" "${SCRIPTS_DISTR_DIR}/"
cp "${SCRIPT_DIR}/../runtime/up-infra-qdrant.sh" "${SCRIPTS_DISTR_DIR}/"
cp "${SCRIPT_DIR}/../runtime/init-networks.sh" "${SCRIPTS_DISTR_DIR}/"


echo "Built Infra"