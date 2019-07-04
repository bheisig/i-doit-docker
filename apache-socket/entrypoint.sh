#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

function execute {
    moveApacheConfig
}

function moveApacheConfig {
    local htaccessFile="/var/www/html/.htaccess"
    local vHostFile="/etc/apache2/sites-available/i-doit.conf"
    local commentText="## Insert content from .htaccess file here"

    if [[ ! -f "$htaccessFile" ]]; then
        return 0
    fi

    echo "Integrate i-doit's .htaccess file into Apache HTTPD vhost configuration file"

    sed -i \
        -e "/${commentText}/ {" \
        -e "r ${htaccessFile}" \
        -e "d" \
        -e "}" \
        "$vHostFile"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    execute
    exec "$@"
fi
