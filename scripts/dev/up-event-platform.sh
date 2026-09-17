#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"

STACK_DIR="${PROJECT_ROOT}/infra/event-platform"
ENV_FILE="${1:-${STACK_DIR}/.env}"

# The official Kafka container runs as uid/gid 1000.
docker run --rm \
    --user 0:0 \
    --entrypoint /bin/sh \
    -v "${VOLUME_NAME}:/tmp/kraft-combined-logs" \
    "${KAFKA_IMAGE}" \
    -c 'chown -R 1000:1000 /tmp/kraft-combined-logs'

docker network inspect orvexa-event-network >/dev/null 2>&1 ||
    docker network create orvexa-event-network

docker compose \
    --project-name orvexa-event-platform \
    --project-directory "${STACK_DIR}" \
    --env-file "${ENV_FILE}" \
    -f "${STACK_DIR}/compose.yaml" \
    -f "${STACK_DIR}/compose.dev.yaml" \
    up -d --wait --pull missing