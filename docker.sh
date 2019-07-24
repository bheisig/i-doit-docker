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
            pushImages
            ;;
        "pull")
            pullImages
            ;;
        "print")
            printReadme
            ;;
        *)
            printUsage
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

function pullImages {
    pullImage php:7.4-rc-fpm-buster
    pullImage php:7.4-rc-apache-buster
    pullImage php:7.3-fpm-buster
    pullImage php:7.3-apache-buster
    pullImage php:7.2-fpm-buster
    pullImage php:7.2-apache-buster
    pullImage php:7.1-fpm-buster
    pullImage php:7.1-apache-buster
    pullImage php:7.0-fpm-stretch
    pullImage php:7.0-apache-stretch
}

function pullImage {
    local image="$1"

    log "Pull $image from repository"

    docker pull "$image" || \
        abort "No pull"
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
        -t "$tag" \
        --no-cache \
        "$path" || \
        abort "No build"
}

function test {
    npm audit || abort "No good"
    npm run-script lint-md || abort "No good"
    npm run-script lint-yaml || abort "No good"
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
    lintDockerfile 1.13 open php7.0 apache
    lintDockerfile 1.13 open php7.0 fpm
    lintDockerfile 1.13 open php7.1 apache
    lintDockerfile 1.13 open php7.1 fpm
    lintDockerfile 1.13 open php7.2 apache
    lintDockerfile 1.13 open php7.2 fpm
    lintDockerfile 1.13 open php7.3 apache
    lintDockerfile 1.13 open php7.3 fpm
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
        apache/Dockerfile || \
        abort "No good"
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
        "$dockerfile" || \
        abort "No good"
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
    lintShellScript 1.13/open/php7.0/apache/*.sh
    lintShellScript 1.13/open/php7.0/fpm/*.sh
    lintShellScript 1.13/open/php7.1/apache/*.sh
    lintShellScript 1.13/open/php7.1/fpm/*.sh
    lintShellScript 1.13/open/php7.2/apache/*.sh
    lintShellScript 1.13/open/php7.2/fpm/*.sh
    lintShellScript 1.13/open/php7.3/apache/*.sh
    lintShellScript 1.13/open/php7.3/fpm/*.sh
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
    docker run \
        -v "$(pwd):/scripts" \
        koalaman/shellcheck \
        "/scripts/$filePath" || \
        abort "No good"
}

function pushImages {
    pushImage 1.12.1 open php7.0 apache
    pushImage 1.12.1 open php7.0 fpm
    pushImage 1.12.1 open php7.1 apache
    pushImage 1.12.1 open php7.1 fpm
    pushImage 1.12.1 open php7.2 apache
    pushImage 1.12.1 open php7.2 fpm
    pushImage 1.12.1 pro php7.0 apache
    pushImage 1.12.1 pro php7.0 fpm
    pushImage 1.12.1 pro php7.1 apache
    pushImage 1.12.1 pro php7.1 fpm
    pushImage 1.12.1 pro php7.2 apache
    pushImage 1.12.1 pro php7.2 fpm
    pushImage 1.12.4 open php7.0 apache
    pushImage 1.12.4 open php7.0 fpm
    pushImage 1.12.4 open php7.1 apache
    pushImage 1.12.4 open php7.1 fpm
    pushImage 1.12.4 open php7.2 apache
    pushImage 1.12.4 open php7.2 fpm
    pushImage 1.12.4 pro php7.0 apache
    pushImage 1.12.4 pro php7.0 fpm
    pushImage 1.12.4 pro php7.1 apache
    pushImage 1.12.4 pro php7.1 fpm
    pushImage 1.12.4 pro php7.2 apache
    pushImage 1.12.4 pro php7.2 fpm
    pushImage 1.13 pro php7.0 apache
    pushImage 1.13 pro php7.0 fpm
    pushImage 1.13 pro php7.1 apache
    pushImage 1.13 pro php7.1 fpm
    pushImage 1.13 pro php7.2 apache
    pushImage 1.13 pro php7.2 fpm
    pushImage 1.13 pro php7.3 apache
    pushImage 1.13 pro php7.3 fpm
}

function pushImage {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"
    local tag="bheisig/idoit:${version}-${edition}-${php}-${service}"

    log "Push image $tag to repository"

    docker push "$tag" || \
        abort "No push, no forward"
}

function printReadme {
    printSupportedTags 1.13 pro php7.3 fpm
    printSupportedTags 1.13 pro php7.3 apache
    printSupportedTags 1.13 pro php7.2 fpm
    printSupportedTags 1.13 pro php7.2 apache
    printSupportedTags 1.13 pro php7.1 fpm
    printSupportedTags 1.13 pro php7.1 apache
    printSupportedTags 1.13 pro php7.0 fpm
    printSupportedTags 1.13 pro php7.0 apache
    printSupportedTags 1.13 open php7.3 fpm
    printSupportedTags 1.13 open php7.3 apache
    printSupportedTags 1.13 open php7.2 fpm
    printSupportedTags 1.13 open php7.2 apache
    printSupportedTags 1.13 open php7.1 fpm
    printSupportedTags 1.13 open php7.1 apache
    printSupportedTags 1.13 open php7.0 fpm
    printSupportedTags 1.13 open php7.0 apache
    printSupportedTags 1.12.4 pro php7.2 fpm
    printSupportedTags 1.12.4 pro php7.2 apache
    printSupportedTags 1.12.4 pro php7.1 fpm
    printSupportedTags 1.12.4 pro php7.1 apache
    printSupportedTags 1.12.4 pro php7.0 fpm
    printSupportedTags 1.12.4 pro php7.0 apache
    printSupportedTags 1.12.4 open php7.2 fpm
    printSupportedTags 1.12.4 open php7.2 apache
    printSupportedTags 1.12.4 open php7.1 fpm
    printSupportedTags 1.12.4 open php7.1 apache
    printSupportedTags 1.12.4 open php7.0 fpm
    printSupportedTags 1.12.4 open php7.0 apache
    printSupportedTags 1.12.1 pro php7.2 fpm
    printSupportedTags 1.12.1 pro php7.2 apache
    printSupportedTags 1.12.1 pro php7.1 fpm
    printSupportedTags 1.12.1 pro php7.1 apache
    printSupportedTags 1.12.1 pro php7.0 fpm
    printSupportedTags 1.12.1 pro php7.0 apache
    printSupportedTags 1.12.1 open php7.2 fpm
    printSupportedTags 1.12.1 open php7.2 apache
    printSupportedTags 1.12.1 open php7.1 fpm
    printSupportedTags 1.12.1 open php7.1 apache
    printSupportedTags 1.12.1 open php7.0 fpm
    printSupportedTags 1.12.1 open php7.0 apache
}

function printSupportedTags {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"

    log "-   \`${version}-${edition}-${php}-${service}\` ([\`Dockerfile\`](${version}/${edition}/${php}/${service}))"
}

function printUsage {
    abort "test|pull|build|push|print"
}

function finish {
    log "Done. Have fun :-)"
    exit 0
}

function abort {
    log "$1"
    exit 1
}

function log {
    echo -e "$1"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    if [[ -z "${1:-}" ]]; then
        printUsage
    fi

    execute "$1" && finish
fi
