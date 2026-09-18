#!/usr/bin/env bash

set -Eeuo pipefail

create_network() {
    local network_name="$1"

    if docker network inspect "${network_name}" >/dev/null 2>&1; then
        echo "Network already exists: ${network_name}"
    else
        docker network create "${network_name}"
        echo "Created network: ${network_name}"
    fi
}

create_network "orvexa-dc1-network"
create_network "orvexa-data-network"
create_network "orvexa-observability-network"