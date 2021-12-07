#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

: "${DOCKER_USERNAME:=""}"
: "${DOCKER_PASSWORD:=""}"
: "${DOCKER_IMAGE:="bheisig/idoit"}"

function execute {
    local job="$1"

    case "$job" in
        "build")
            buildImages
            ;;
        "clean")
            cleanUp
            ;;
        "fix")
            fix
            ;;
        "help")
            printUsage
            ;;
        "login")
            loginToDockerHub
            ;;
        "logout")
            logoutFromDockerHub
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
        "scan")
            scanImages
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

function logoutFromDockerHub {
    docker logout || \
    abort "Unable to logout from Docker Hub"
}

function buildImages {
    log "Build Docker images…"

    buildImage 1.16 pro php7.4 apache
    buildImage 1.16 pro php7.4 fpm

    buildImage 1.16 open php7.4 apache
    buildImage 1.16 open php7.4 fpm

    buildImage 1.16.1 pro php7.4 apache
    buildImage 1.16.1 pro php7.4 fpm

    buildImage 1.16.1 open php7.4 apache
    buildImage 1.16.1 open php7.4 fpm

    buildImage 1.16.2 pro php7.4 apache
    buildImage 1.16.2 pro php7.4 fpm

    buildImage 1.16.2 open php7.4 apache
    buildImage 1.16.2 open php7.4 fpm

    buildImage 1.16.3 pro php7.4 apache
    buildImage 1.16.3 pro php7.4 fpm

    buildImage 1.16.3 open php7.4 apache
    buildImage 1.16.3 open php7.4 fpm

    buildImage 1.17 pro php7.4 apache
    buildImage 1.17 pro php7.4 fpm

    buildImage 1.17 open php7.4 apache
    buildImage 1.17 open php7.4 fpm

    buildImage 1.17.1 pro php7.4 apache
    buildImage 1.17.1 pro php7.4 fpm

    buildImage 1.17.1 open php7.4 apache
    buildImage 1.17.1 open php7.4 fpm

    buildImage 1.17.2 pro php7.4 apache
    buildImage 1.17.2 pro php7.4 fpm

    buildImage 1.17.2 open php7.4 apache
    buildImage 1.17.2 open php7.4 fpm
}

function pullImages {
    log "Pull Docker images from registry…"

    pullImage php:7.4-fpm-bullseye
    pullImage php:7.4-apache-bullseye
}

function pullImage {
    local image="$1"

    log "Pull $image from Docker registry"

    docker pull "$image" || \
        abort "No pull"
}

function buildImage {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"
    local path="${version}/${edition}/${php}/${service}/"
    local tag="${DOCKER_IMAGE}:${version}-${edition}-${php}-${service}"

    log "Build $tag from $path"

    docker build \
        -t "$tag" \
        "$path" || \
        abort "No build"
}

function scanImages {
    log "Scan Docker images for vulnerabilities…"

    scanImage 1.16 pro php7.4 apache
    scanImage 1.16 pro php7.4 fpm

    scanImage 1.16 open php7.4 apache
    scanImage 1.16 open php7.4 fpm

    scanImage 1.16.1 pro php7.4 apache
    scanImage 1.16.1 pro php7.4 fpm

    scanImage 1.16.1 open php7.4 apache
    scanImage 1.16.1 open php7.4 fpm

    scanImage 1.16.2 pro php7.4 apache
    scanImage 1.16.2 pro php7.4 fpm

    scanImage 1.16.2 open php7.4 apache
    scanImage 1.16.2 open php7.4 fpm

    scanImage 1.16.3 pro php7.4 apache
    scanImage 1.16.3 pro php7.4 fpm

    scanImage 1.16.3 open php7.4 apache
    scanImage 1.16.3 open php7.4 fpm

    scanImage 1.17 pro php7.4 apache
    scanImage 1.17 pro php7.4 fpm

    scanImage 1.17 open php7.4 apache
    scanImage 1.17 open php7.4 fpm

    scanImage 1.17.1 pro php7.4 apache
    scanImage 1.17.1 pro php7.4 fpm

    scanImage 1.17.1 open php7.4 apache
    scanImage 1.17.1 open php7.4 fpm

    scanImage 1.17.2 pro php7.4 apache
    scanImage 1.17.2 pro php7.4 fpm

    scanImage 1.17.2 open php7.4 apache
    scanImage 1.17.2 open php7.4 fpm
}

function scanImage {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"
    local tag="${DOCKER_IMAGE}:${version}-${edition}-${php}-${service}"

    log "Scan image $tag"
    trivy --quiet image --severity HIGH,CRITICAL "$tag"
}

function fix {
    fixFilePermissions
}

function fixFilePermissions {
    find . -type f -iname "*.sh" -exec chmod +x {} \; || \
        abort "Not good"
}

function pushImages {
    log "Push Docker images to registry…"

    pushImage 1.16 pro php7.4 apache
    pushImage 1.16 pro php7.4 fpm

    pushImage 1.16 open php7.4 apache
    pushImage 1.16 open php7.4 fpm

    pushImage 1.16.1 pro php7.4 apache
    pushImage 1.16.1 pro php7.4 fpm

    pushImage 1.16.1 open php7.4 apache
    pushImage 1.16.1 open php7.4 fpm

    pushImage 1.16.2 pro php7.4 apache
    pushImage 1.16.2 pro php7.4 fpm

    pushImage 1.16.2 open php7.4 apache
    pushImage 1.16.2 open php7.4 fpm

    pushImage 1.16.3 pro php7.4 apache
    pushImage 1.16.3 pro php7.4 fpm

    pushImage 1.16.3 open php7.4 apache
    pushImage 1.16.3 open php7.4 fpm

    pushImage 1.17 pro php7.4 apache
    pushImage 1.17 pro php7.4 fpm

    pushImage 1.17 open php7.4 apache
    pushImage 1.17 open php7.4 fpm

    pushImage 1.17.1 pro php7.4 apache
    pushImage 1.17.1 pro php7.4 fpm

    pushImage 1.17.1 open php7.4 apache
    pushImage 1.17.1 open php7.4 fpm

    pushImage 1.17.2 pro php7.4 apache
    pushImage 1.17.2 pro php7.4 fpm

    pushImage 1.17.2 open php7.4 apache
    pushImage 1.17.2 open php7.4 fpm
}

function pushImage {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"
    local tag="${DOCKER_IMAGE}:${version}-${edition}-${php}-${service}"

    log "Push image $tag to Docker registry"

    docker push "$tag" || \
        abort "No push, no forward"
}

function printReadme {
    printSupportedTags 1.17.2 open php7.4 fpm
    printSupportedTags 1.17.2 open php7.4 apache

    printSupportedTags 1.17.2 pro php7.4 fpm
    printSupportedTags 1.17.2 pro php7.4 apache

    printSupportedTags 1.17.1 open php7.4 fpm
    printSupportedTags 1.17.1 open php7.4 apache

    printSupportedTags 1.17.1 pro php7.4 fpm
    printSupportedTags 1.17.1 pro php7.4 apache

    printSupportedTags 1.17 open php7.4 fpm
    printSupportedTags 1.17 open php7.4 apache

    printSupportedTags 1.17 pro php7.4 fpm
    printSupportedTags 1.17 pro php7.4 apache

    printSupportedTags 1.16.3 open php7.4 fpm
    printSupportedTags 1.16.3 open php7.4 apache

    printSupportedTags 1.16.3 pro php7.4 fpm
    printSupportedTags 1.16.3 pro php7.4 apache

    printSupportedTags 1.16.2 open php7.4 fpm
    printSupportedTags 1.16.2 open php7.4 apache

    printSupportedTags 1.16.2 pro php7.4 fpm
    printSupportedTags 1.16.2 pro php7.4 apache

    printSupportedTags 1.16.1 open php7.4 fpm
    printSupportedTags 1.16.1 open php7.4 apache

    printSupportedTags 1.16.1 pro php7.4 fpm
    printSupportedTags 1.16.1 pro php7.4 apache

    printSupportedTags 1.16 open php7.4 fpm
    printSupportedTags 1.16 open php7.4 apache

    printSupportedTags 1.16 pro php7.4 fpm
    printSupportedTags 1.16 pro php7.4 apache
}

function printSupportedTags {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"
    local tag=""
    local path=""

    tag="${version}-${edition}-${php}-${service}"
    path="${version}/${edition}/${php}/${service}"

    log "-   \`${tag}\` ([\`Dockerfile\`](${path}))"
}

function cleanUp {
    local amount="0"

    log "Clean up"

    amount="$(docker images -q "${DOCKER_IMAGE}" | wc -l)"

    case "$amount" in
        "0")
            log "Already cleaned up"
            return 0
            ;;
        "1")
            log "Remove 1 docker image by name ${DOCKER_IMAGE}"
            ;;
        *)  log "Remove $amount docker images by name ${DOCKER_IMAGE}"
            ;;
    esac

    # We need word splitting:
    # shellcheck disable=SC2046
    docker rmi -f $(docker images -q "${DOCKER_IMAGE}") || \
        abort "Unable to remove docker images"
}

function printUsage {
    log "build|clean|fix|help|login|logout|print|pull|push|scan"
}

function setUp {
    test "$(whoami)" != root || \
        log "Please do not run this script as root user"

    command -v docker > /dev/null || \
        abort "Command \"docker\" is missing"
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
    setUp && execute "${1-help}" && finish
fi
