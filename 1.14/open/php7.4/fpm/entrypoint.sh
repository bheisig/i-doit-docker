#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

: "${IDOIT_DEFAULT_TENANT:=""}"

function execute {
    if [[ -n "$IDOIT_DEFAULT_TENANT" ]]; then
        is-installed.sh || setup.sh
    fi

    chown www-data:www-data -R /var/www/html/
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    execute
    exec "$@"
fi
