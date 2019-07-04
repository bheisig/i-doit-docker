#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

function execute {
    local job="$1"

    case "$job" in
        "build")
            buildImages
            ;;
        "test")
            test
            ;;
        "push")
            abort "Implement me!"
            ;;
        "print-readme")
            printReadme
            ;;
        *)
            abort "build|test|push"
            ;;
    esac
}

function buildImages {
    buildImage 1.12.1 open php7.0 apache
    buildImage 1.12.1 open php7.0 fpm
    buildImage 1.12.1 open php7.1 apache
    buildImage 1.12.1 open php7.1 fpm
    buildImage 1.12.1 open php7.2 apache
    buildImage 1.12.1 open php7.2 fpm
    buildImage 1.12.1 pro php7.0 apache
    buildImage 1.12.1 pro php7.0 fpm
    buildImage 1.12.1 pro php7.1 apache
    buildImage 1.12.1 pro php7.1 fpm
    buildImage 1.12.1 pro php7.2 apache
    buildImage 1.12.1 pro php7.2 fpm
    buildImage 1.12.4 open php7.0 apache
    buildImage 1.12.4 open php7.0 fpm
    buildImage 1.12.4 open php7.1 apache
    buildImage 1.12.4 open php7.1 fpm
    buildImage 1.12.4 open php7.2 apache
    buildImage 1.12.4 open php7.2 fpm
    buildImage 1.12.4 pro php7.0 apache
    buildImage 1.12.4 pro php7.0 fpm
    buildImage 1.12.4 pro php7.1 apache
    buildImage 1.12.4 pro php7.1 fpm
    buildImage 1.12.4 pro php7.2 apache
    buildImage 1.12.4 pro php7.2 fpm
    buildImage 1.13 pro php7.0 apache
    buildImage 1.13 pro php7.0 fpm
    buildImage 1.13 pro php7.1 apache
    buildImage 1.13 pro php7.1 fpm
    buildImage 1.13 pro php7.2 apache
    buildImage 1.13 pro php7.2 fpm
    buildImage 1.13 pro php7.3 apache
    buildImage 1.13 pro php7.3 fpm
}

function buildImage {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"
    local path="${version}/${edition}/${php}/${service}/"
    local tag="bheisig/idoit:${version}-${edition}-${php}-${service}"

    log "Build $tag from $path"

    docker build \
        "$path" \
        -t "$tag"
}

function test {
    npm audit
    npm run-script lint-md
    npm run-script lint-yaml
    lintDockerfiles
    lintShellScripts
}

function lintDockerfiles {
    lintDockerfile 1.12.1 open php7.0 apache
    lintDockerfile 1.12.1 open php7.0 fpm
    lintDockerfile 1.12.1 open php7.1 apache
    lintDockerfile 1.12.1 open php7.1 fpm
    lintDockerfile 1.12.1 open php7.2 apache
    lintDockerfile 1.12.1 open php7.2 fpm
    lintDockerfile 1.12.1 pro php7.0 apache
    lintDockerfile 1.12.1 pro php7.0 fpm
    lintDockerfile 1.12.1 pro php7.1 apache
    lintDockerfile 1.12.1 pro php7.1 fpm
    lintDockerfile 1.12.1 pro php7.2 apache
    lintDockerfile 1.12.1 pro php7.2 fpm
    lintDockerfile 1.12.4 open php7.0 apache
    lintDockerfile 1.12.4 open php7.0 fpm
    lintDockerfile 1.12.4 open php7.1 apache
    lintDockerfile 1.12.4 open php7.1 fpm
    lintDockerfile 1.12.4 open php7.2 apache
    lintDockerfile 1.12.4 open php7.2 fpm
    lintDockerfile 1.12.4 pro php7.0 apache
    lintDockerfile 1.12.4 pro php7.0 fpm
    lintDockerfile 1.12.4 pro php7.1 apache
    lintDockerfile 1.12.4 pro php7.1 fpm
    lintDockerfile 1.12.4 pro php7.2 apache
    lintDockerfile 1.12.4 pro php7.2 fpm
    lintDockerfile 1.13 pro php7.0 apache
    lintDockerfile 1.13 pro php7.0 fpm
    lintDockerfile 1.13 pro php7.1 apache
    lintDockerfile 1.13 pro php7.1 fpm
    lintDockerfile 1.13 pro php7.2 apache
    lintDockerfile 1.13 pro php7.2 fpm
    lintDockerfile 1.13 pro php7.3 apache
    lintDockerfile 1.13 pro php7.3 fpm

    log "Lint apache/Dockerfile"

    docker run --rm -i -v "$PWD:/opt/hadolint/" hadolint/hadolint \
        hadolint --config /opt/hadolint/.hadolint.yaml - < \
        apache/Dockerfile
}

function lintDockerfile {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"
    local dockerfile="${version}/${edition}/${php}/${service}/Dockerfile"

    log "Lint $dockerfile"

    docker run --rm -i -v "$PWD:/opt/hadolint/" hadolint/hadolint \
        hadolint --config /opt/hadolint/.hadolint.yaml - < \
        "$dockerfile"
}

function lintShellScripts {
    log "Lint shell scripts ./*.sh"
    lintShellScript ./*.sh
    log "Lint shell scripts apache/*.sh"
    lintShellScript apache/*.sh

    lintShellScript 1.12.1/open/php7.0/apache/*.sh
    lintShellScript 1.12.1/open/php7.0/fpm/*.sh
    lintShellScript 1.12.1/open/php7.1/apache/*.sh
    lintShellScript 1.12.1/open/php7.1/fpm/*.sh
    lintShellScript 1.12.1/open/php7.2/apache/*.sh
    lintShellScript 1.12.1/open/php7.2/fpm/*.sh
    lintShellScript 1.12.1/pro/php7.0/apache/*.sh
    lintShellScript 1.12.1/pro/php7.0/fpm/*.sh
    lintShellScript 1.12.1/pro/php7.1/apache/*.sh
    lintShellScript 1.12.1/pro/php7.1/fpm/*.sh
    lintShellScript 1.12.1/pro/php7.2/apache/*.sh
    lintShellScript 1.12.1/pro/php7.2/fpm/*.sh
    lintShellScript 1.12.4/open/php7.0/apache/*.sh
    lintShellScript 1.12.4/open/php7.0/fpm/*.sh
    lintShellScript 1.12.4/open/php7.1/apache/*.sh
    lintShellScript 1.12.4/open/php7.1/fpm/*.sh
    lintShellScript 1.12.4/open/php7.2/apache/*.sh
    lintShellScript 1.12.4/open/php7.2/fpm/*.sh
    lintShellScript 1.12.4/pro/php7.0/apache/*.sh
    lintShellScript 1.12.4/pro/php7.0/fpm/*.sh
    lintShellScript 1.12.4/pro/php7.1/apache/*.sh
    lintShellScript 1.12.4/pro/php7.1/fpm/*.sh
    lintShellScript 1.12.4/pro/php7.2/apache/*.sh
    lintShellScript 1.12.4/pro/php7.2/fpm/*.sh
    lintShellScript 1.13/pro/php7.0/apache/*.sh
    lintShellScript 1.13/pro/php7.0/fpm/*.sh
    lintShellScript 1.13/pro/php7.1/apache/*.sh
    lintShellScript 1.13/pro/php7.1/fpm/*.sh
    lintShellScript 1.13/pro/php7.2/apache/*.sh
    lintShellScript 1.13/pro/php7.2/fpm/*.sh
    lintShellScript 1.13/pro/php7.3/apache/*.sh
    lintShellScript 1.13/pro/php7.3/fpm/*.sh
}

function lintShellScript {
    local filePath="$1"
    log "Lint shell script $filePath"
    docker run -v "$(pwd):/scripts" koalaman/shellcheck "/scripts/$filePath"
}

function printReadme {
    printSupportedTags 1.12.1 open php7.0 apache
    printSupportedTags 1.12.1 open php7.0 fpm
    printSupportedTags 1.12.1 open php7.1 apache
    printSupportedTags 1.12.1 open php7.1 fpm
    printSupportedTags 1.12.1 open php7.2 apache
    printSupportedTags 1.12.1 open php7.2 fpm
    printSupportedTags 1.12.1 pro php7.0 apache
    printSupportedTags 1.12.1 pro php7.0 fpm
    printSupportedTags 1.12.1 pro php7.1 apache
    printSupportedTags 1.12.1 pro php7.1 fpm
    printSupportedTags 1.12.1 pro php7.2 apache
    printSupportedTags 1.12.1 pro php7.2 fpm
    printSupportedTags 1.12.4 open php7.0 apache
    printSupportedTags 1.12.4 open php7.0 fpm
    printSupportedTags 1.12.4 open php7.1 apache
    printSupportedTags 1.12.4 open php7.1 fpm
    printSupportedTags 1.12.4 open php7.2 apache
    printSupportedTags 1.12.4 open php7.2 fpm
    printSupportedTags 1.12.4 pro php7.0 apache
    printSupportedTags 1.12.4 pro php7.0 fpm
    printSupportedTags 1.12.4 pro php7.1 apache
    printSupportedTags 1.12.4 pro php7.1 fpm
    printSupportedTags 1.12.4 pro php7.2 apache
    printSupportedTags 1.12.4 pro php7.2 fpm
    printSupportedTags 1.13 pro php7.0 apache
    printSupportedTags 1.13 pro php7.0 fpm
    printSupportedTags 1.13 pro php7.1 apache
    printSupportedTags 1.13 pro php7.1 fpm
    printSupportedTags 1.13 pro php7.2 apache
    printSupportedTags 1.13 pro php7.2 fpm
    printSupportedTags 1.13 pro php7.3 apache
    printSupportedTags 1.13 pro php7.3 fpm
}

function printSupportedTags {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"

    log "-   \`${version}-${edition}-${php}-${service}\` ([\`Dockerfile\`](${version}/${edition}/${php}/${service}))"
}

function finish {
    log "Done. Have fun :-)"
    exit 0
}

function abort {
    echo -e "$1"  1>&2
    exit 1
}

function log {
    echo -e "$1"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    execute "$1" && finish
fi
