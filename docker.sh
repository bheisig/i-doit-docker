#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

: "${DOCKER_USERNAME:=""}"
: "${DOCKER_PASSWORD:=""}"

BASEDIR="."

function execute {
    local job="$1"

    case "$job" in
        "build")
            buildImages
            ;;
        "help")
            printUsage
            ;;
        "login")
            loginToDockerHub
            ;;
        "print")
            printReadme
            ;;
        "pull")
            pullImages
            ;;
        "push")
            pushImages
            ;;
        "test")
            runTests
            ;;
        *)
            printUsage
            ;;
    esac
}

function loginToDockerHub {
    test -n "$DOCKER_USERNAME" || \
        abort "Unknown Docker ID"

    test -n "$DOCKER_PASSWORD" || \
        abort "Empty password for Docker ID $DOCKER_USERNAME"

    echo "$DOCKER_PASSWORD" | \
        docker login -u "$DOCKER_USERNAME" --password-stdin || \
        abort "Unable to sign in to Docker Hub with Docker ID $DOCKER_USERNAME"
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
    buildImage 1.13 pro php7.4 apache
    buildImage 1.13 pro php7.4 fpm
    buildImage 1.13 open php7.0 apache
    buildImage 1.13 open php7.0 fpm
    buildImage 1.13 open php7.1 apache
    buildImage 1.13 open php7.1 fpm
    buildImage 1.13 open php7.2 apache
    buildImage 1.13 open php7.2 fpm
    buildImage 1.13 open php7.3 apache
    buildImage 1.13 open php7.3 fpm
    buildImage 1.13 open php7.4 apache
    buildImage 1.13 open php7.4 fpm
    buildImage 1.13.1 pro php7.0 apache
    buildImage 1.13.1 pro php7.0 fpm
    buildImage 1.13.1 pro php7.1 apache
    buildImage 1.13.1 pro php7.1 fpm
    buildImage 1.13.1 pro php7.2 apache
    buildImage 1.13.1 pro php7.2 fpm
    buildImage 1.13.1 pro php7.3 apache
    buildImage 1.13.1 pro php7.3 fpm
    buildImage 1.13.1 pro php7.4 apache
    buildImage 1.13.1 pro php7.4 fpm
    buildImage 1.13.1 open php7.0 apache
    buildImage 1.13.1 open php7.0 fpm
    buildImage 1.13.1 open php7.1 apache
    buildImage 1.13.1 open php7.1 fpm
    buildImage 1.13.1 open php7.2 apache
    buildImage 1.13.1 open php7.2 fpm
    buildImage 1.13.1 open php7.3 apache
    buildImage 1.13.1 open php7.3 fpm
    buildImage 1.13.1 open php7.4 apache
    buildImage 1.13.1 open php7.4 fpm
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
        --quiet \
        --force-rm \
        --compress \
        "$path" || \
        abort "No build"
}

function runTests {
    npm audit || abort "No good"
    lintMarkdownFiles
    lintYAMLFiles
    lintDockerfiles
    lintShellScripts
}

function lintMarkdownFiles {
    while IFS= read -r -d '' filePath; do
        lintMarkdownFile "$filePath"
    done < <(
        find "$(git rev-parse --show-toplevel)" \
            -type f -name "*.md" -not \
            -exec git check-ignore -q {} \; -print0
    )
}

function lintMarkdownFile {
    local filePath="$1"

    log "Lint markdown file $filePath"

    "${BASEDIR}/node_modules/.bin/remark" \
        --frail --quiet "$filePath" > /dev/null || \
        abort "No good"
}

function lintYAMLFiles {
    while IFS= read -r -d '' filePath; do
        lintYAMLFile "$filePath"
    done < <(
        find "$(git rev-parse --show-toplevel)" \
            -type f -name "*.y*ml" -not \
            -exec git check-ignore -q {} \; -print0
    )
}

function lintYAMLFile {
    local filePath="$1"

    log "Lint YAML file $filePath"

    "${BASEDIR}/node_modules/.bin/yamllint" "$filePath" || \
        abort "No good"
}

function lintDockerfiles {
    while IFS= read -r -d '' filePath; do
        lintDockerfile "$filePath"
    done < <(
        find "$(git rev-parse --show-toplevel)" \
            -type f -name "Dockerfile" -not \
            -exec git check-ignore -q {} \; -print0
    )
}

function lintDockerfile {
    local dockerfile="$1"

    log "Lint $dockerfile"

    docker run --rm -i -v "$PWD:/opt/hadolint/" hadolint/hadolint \
        hadolint --config /opt/hadolint/.hadolint.yaml - < \
        "$dockerfile" || \
        abort "No good"
}

function lintShellScripts {
    while IFS= read -r -d '' filePath; do
        lintShellScript "$filePath"
    done < <(
        find . \
            -type f -name "*.sh" -not \
            -exec git check-ignore -q {} \; -print0
    )
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
    pushImage 1.13 pro php7.4 apache
    pushImage 1.13 pro php7.4 fpm
    pushImage 1.13 open php7.0 apache
    pushImage 1.13 open php7.0 fpm
    pushImage 1.13 open php7.1 apache
    pushImage 1.13 open php7.1 fpm
    pushImage 1.13 open php7.2 apache
    pushImage 1.13 open php7.2 fpm
    pushImage 1.13 open php7.3 apache
    pushImage 1.13 open php7.3 fpm
    pushImage 1.13 open php7.4 apache
    pushImage 1.13 open php7.4 fpm
    pushImage 1.13.1 pro php7.0 apache
    pushImage 1.13.1 pro php7.0 fpm
    pushImage 1.13.1 pro php7.1 apache
    pushImage 1.13.1 pro php7.1 fpm
    pushImage 1.13.1 pro php7.2 apache
    pushImage 1.13.1 pro php7.2 fpm
    pushImage 1.13.1 pro php7.3 apache
    pushImage 1.13.1 pro php7.3 fpm
    pushImage 1.13.1 pro php7.4 apache
    pushImage 1.13.1 pro php7.4 fpm
    pushImage 1.13.1 open php7.0 apache
    pushImage 1.13.1 open php7.0 fpm
    pushImage 1.13.1 open php7.1 apache
    pushImage 1.13.1 open php7.1 fpm
    pushImage 1.13.1 open php7.2 apache
    pushImage 1.13.1 open php7.2 fpm
    pushImage 1.13.1 open php7.3 apache
    pushImage 1.13.1 open php7.3 fpm
    pushImage 1.13.1 open php7.4 apache
    pushImage 1.13.1 open php7.4 fpm
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
    printSupportedTags 1.13.1 pro php7.4 fpm
    printSupportedTags 1.13.1 pro php7.4 apache
    printSupportedTags 1.13.1 pro php7.3 fpm
    printSupportedTags 1.13.1 pro php7.3 apache
    printSupportedTags 1.13.1 pro php7.2 fpm
    printSupportedTags 1.13.1 pro php7.2 apache
    printSupportedTags 1.13.1 pro php7.1 fpm
    printSupportedTags 1.13.1 pro php7.1 apache
    printSupportedTags 1.13.1 pro php7.0 fpm
    printSupportedTags 1.13.1 pro php7.0 apache
    printSupportedTags 1.13.1 open php7.4 fpm
    printSupportedTags 1.13.1 open php7.4 apache
    printSupportedTags 1.13.1 open php7.3 fpm
    printSupportedTags 1.13.1 open php7.3 apache
    printSupportedTags 1.13.1 open php7.2 fpm
    printSupportedTags 1.13.1 open php7.2 apache
    printSupportedTags 1.13.1 open php7.1 fpm
    printSupportedTags 1.13.1 open php7.1 apache
    printSupportedTags 1.13.1 open php7.0 fpm
    printSupportedTags 1.13.1 open php7.0 apache
    printSupportedTags 1.13 pro php7.4 fpm
    printSupportedTags 1.13 pro php7.4 apache
    printSupportedTags 1.13 pro php7.3 fpm
    printSupportedTags 1.13 pro php7.3 apache
    printSupportedTags 1.13 pro php7.2 fpm
    printSupportedTags 1.13 pro php7.2 apache
    printSupportedTags 1.13 pro php7.1 fpm
    printSupportedTags 1.13 pro php7.1 apache
    printSupportedTags 1.13 pro php7.0 fpm
    printSupportedTags 1.13 pro php7.0 apache
    printSupportedTags 1.13 open php7.4 fpm
    printSupportedTags 1.13 open php7.4 apache
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
    log "test|pull|build|push|print"
}

function finish {
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
    BASEDIR="$(dirname "$0")"

    if [[ -z "${1:-}" ]]; then
        printUsage
    fi

    execute "$1" && finish
fi
