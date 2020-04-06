#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

: "${IDOIT_DEFAULT_TENANT:=""}"

function execute {
    if [[ -n "$IDOIT_DEFAULT_TENANT" ]]; then
        is-installed.sh || setup.sh
    fi
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    execute
    exec "$@"
fi
