#!/usr/bin/env bash

set -Eeuo pipefail
remove_network() {
    local network_name="$1"

    if ! docker network inspect "${network_name}" >/dev/null 2>&1; then
        return
    fi

    local container_count
    container_count="$(
        docker network inspect \
            --format '{{len .Containers}}' \
            "${network_name}"
    )"

    if [[ "${container_count}" -eq 0 ]]; then
        docker network rm "${network_name}"
    else
        echo "Network ${network_name} is still in use; keeping it." >&2
    fi
}

remove_network "orvexa-dc1-network"
remove_network "orvexa-data-network"