#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

: "${INSTALL_DIR:="/var/www/html"}"
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
    log "Installation directory: $INSTALL_DIR"
    log "Default tenant: $IDOIT_DEFAULT_TENANT"
    log "MariaDB hostname: $MYSQL_HOSTNAME"
    log "i-doit system database: $IDOIT_SYSTEM_DATABASE"
    log "i-doit tenant database: $IDOIT_TENANT_DATABASE"
    log "MariaDB super-user: $MYSQL_ROOT_USER"
    log "MariaDB i-doit user: $MYSQL_USER"
}

function runChecks {
    test -d "$INSTALL_DIR" || \
        abort "Installation directory '${INSTALL_DIR}' not found"

    test -d "${INSTALL_DIR}/setup" || \
        abort "Directory '${INSTALL_DIR}/setup' not accessible"

    test -x "${INSTALL_DIR}/setup/install.sh" || \
        abort "Install script '${INSTALL_DIR}/setup/install.sh' not found/executable"

    test -x "$MARIADB_BIN" || \
        abort "MariaDB client '${MARIADB_BIN}' not found"
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

function execute {
    log "Install i-doit"

    addDB "$IDOIT_SYSTEM_DATABASE"
    addDB "$IDOIT_TENANT_DATABASE"
    runIdoitSetup
    fixTenantTable
    fixConfigFile
    enableMemcached
    updateApacheConfig
}

function addDB {
    local dbName="$1"

    log "Create database '${dbName}'"
    "$MARIADB_BIN" \
        -h"$MYSQL_HOSTNAME" \
        -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" \
        -e"CREATE DATABASE IF NOT EXISTS $dbName;" || \
        abort "SQL statement failed"

    log "Grant MariaDB user '${MYSQL_USER}' access to database '${dbName}'"
    "$MARIADB_BIN" \
        -h"$MYSQL_HOSTNAME" \
        -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" \
        -e"GRANT ALL PRIVILEGES ON ${dbName}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" || \
        abort "SQL statement failed"
}

function runIdoitSetup {
    cd "${INSTALL_DIR}/setup" || abort "Change directory to '${INSTALL_DIR}/setup' failed"

    log "Run i-doit's setup script"
    ./install.sh -n "$IDOIT_DEFAULT_TENANT" \
        -s "$IDOIT_SYSTEM_DATABASE" -m "$IDOIT_TENANT_DATABASE" -h "$MYSQL_HOSTNAME" \
        -u "$MYSQL_USER" \
        -p "$MYSQL_PASSWORD" \
        -a "$IDOIT_ADMIN_CENTER_PASSWORD" -q || \
            abort "i-doit setup script returned an error"
}

function fixTenantTable {
    log "Fix tenant table"
    "$MARIADB_BIN" \
        -h"$MYSQL_HOSTNAME" \
        -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
        -e"UPDATE ${IDOIT_SYSTEM_DATABASE}.isys_mandator SET isys_mandator__db_user = '${MYSQL_USER}', isys_mandator__db_pass = '${MYSQL_PASSWORD}';" || \
        abort "SQL statement failed"
}

function fixConfigFile {
    local configFile="${INSTALL_DIR}/src/config.inc.php"

    log "Fix configuration file '${configFile}'"

    sed -i -- \
        "s/'user' => '${MYSQL_ROOT_USER}'/'user' => '${MYSQL_USER}'/g" \
        "$configFile" || \
        abort "Unable to replace MariaDB username"

    sed -i -- \
        "s/'pass' => '${MYSQL_ROOT_PASSWORD}'/'pass' => '${MYSQL_PASSWORD}'/g" \
        "$configFile" || \
        abort "Unable to replace MariaDB password"

    chown "$APACHE_USER":"$APACHE_GROUP" "$configFile" || abort "Unable to change ownership"
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
    runChecks
    waitForDBMS
    execute
    finish
fi
