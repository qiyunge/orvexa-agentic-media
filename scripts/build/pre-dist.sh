#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"

DISTR_DIR="${PROJECT_ROOT}/.dist"

echo "Preparing distribution directory: ${DISTR_DIR}"
echo "Removing existing distribution directory"
rm -rf "${DISTR_DIR}"

mkdir -p \
    "${DISTR_DIR}/config" \
    "${DISTR_DIR}/scripts" \
    "${DISTR_DIR}/services" \
    "${DISTR_DIR}/infra"

cp -R "${PROJECT_ROOT}/config/." "${DISTR_DIR}/config/"

echo "Distribution directory prepared"