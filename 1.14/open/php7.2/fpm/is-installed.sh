#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

: "${INSTALL_DIR:="/var/www/html"}"

function execute {
    local configFile="${INSTALL_DIR}/src/config.inc.php"

    if [[ -f "$configFile" ]]; then
        echo "i-doit is already installed" 1>&2
        exit 0
    fi

    echo "i-doit has not been installed yet" 1>&2
    exit 1
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    execute
fi
