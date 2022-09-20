#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

: "${MYSQL_HOSTNAME:="localhost"}"
: "${MYSQL_ROOT_USER:="root"}"
: "${MYSQL_ROOT_PASSWORD:="idoit"}"
: "${IDOIT_ADMIN_CENTER_PASSWORD:="admin"}"
: "${MYSQL_USER:="idoit"}"
: "${MYSQL_PASSWORD:="idoit"}"
: "${IDOIT_DEFAULT_TENANT:="CMDB"}"
: "${IDOIT_SYSTEM_DATABASE:="idoit_system"}"
: "${IDOIT_TENANT_DATABASE:="idoit_data"}"
: "${APACHE_USER:="www-data"}"
: "${APACHE_GROUP:="www-data"}"
: "${MARIADB_BIN:="$(command -v mysql)"}"
: "${MEMCACHED_HOST:=""}"
: "${MEMCACHED_PORT:=""}"

: "${APACHE_CONFIG_FILE:="/etc/apache2/sites-available/i-doit.conf"}"
: "${APACHE_HTACCESS_SUBSTITUTION:="## Insert content from .htaccess file here"}"

function report {
    log "Default tenant: $IDOIT_DEFAULT_TENANT"
    log "MariaDB hostname: $MYSQL_HOSTNAME"
    log "i-doit system database: $IDOIT_SYSTEM_DATABASE"
    log "i-doit tenant database: $IDOIT_TENANT_DATABASE"
    log "MariaDB super-user: $MYSQL_ROOT_USER"
    log "MariaDB i-doit user: $MYSQL_USER"
}

function waitForDBMS {
    while ! "$MARIADB_BIN" \
        -h"$MYSQL_HOSTNAME" \
        -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" \
        -e "SHOW DATABASES;" &> /dev/null; do
        log "Wait for MariaDB…"
        sleep 1
    done
}

function runIdoitSetup {
    log "Install i-doit"
    php console.php install \
        -u "$MYSQL_ROOT_USER" \
        -p "$MYSQL_ROOT_PASSWORD" \
        --host="$MYSQL_HOSTNAME" \
        -d "$IDOIT_SYSTEM_DATABASE" \
        -U "$MYSQL_USER" \
        -P "$MYSQL_PASSWORD" \
        --admin-password "$IDOIT_ADMIN_CENTER_PASSWORD" \
        -n  || \
            abort "Installation of i-doit failed"

    log "Create tenant"
    php console.php tenant-create \
        -u "$MYSQL_ROOT_USER" \
        -p "$MYSQL_ROOT_PASSWORD" \
        -U "$MYSQL_USER" \
        -P "$MYSQL_PASSWORD" \
        -d "$MYSQL_PASSWORD" \
        -t "$IDOIT_DEFAULT_TENANT" \
        -n  || \
            abort "Tenant can't be created"
}

function enableMemcached {
    if [[ -n "$MEMCACHED_HOST" ]]; then
        log "Enable memcached: $MEMCACHED_HOST"
        "$MARIADB_BIN" \
            -h"$MYSQL_HOSTNAME" \
            -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
            -e"INSERT INTO ${IDOIT_SYSTEM_DATABASE}.isys_settings (isys_settings__key, isys_settings__value) VALUES ('memcache.host', '${MEMCACHED_HOST}');" || \
            abort "SQL statement failed"
    fi

    if [[ -n "$MEMCACHED_PORT" ]]; then
        log "Configure memcached port: $MEMCACHED_PORT"
        "$MARIADB_BIN" \
            -h"$MYSQL_HOSTNAME" \
            -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
            -e"INSERT INTO ${IDOIT_SYSTEM_DATABASE}.isys_settings (isys_settings__key, isys_settings__value) VALUES ('memcache.port', '${MEMCACHED_PORT}');" || \
            abort "SQL statement failed"
    fi
}

function updateApacheConfig {
    local htaccessFile="${INSTALL_DIR}/.htaccess"

    log "Update Apache's VHost config from i-doit's htaccess file"

    sed -i \
        -e "/${APACHE_HTACCESS_SUBSTITUTION}/ {" \
        -e "r ${htaccessFile}" \
        -e "d" \
        -e "}" \
        "$APACHE_CONFIG_FILE" || \
        abort "Unable to change config file"
}

function finish {
    log "Done. Have fun :-)"
    exit 0
}

function log {
    echo -e "$1" 1>&2
}

function abort {
    echo -e "$1"  1>&2
    echo "Operation failed. Please check what is wrong and try again." 1>&2
    exit 1
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    report
    waitForDBMS
    runIdoitSetup
    enableMemcached
    updateApacheConfig
    finish
fi
