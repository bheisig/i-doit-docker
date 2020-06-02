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

function logoutFromDockerHub {
    docker logout || \
    abort "Unable to logout from Docker Hub"
}

function buildImages {
    buildImage 1.14 pro php7.1 apache
    buildImage 1.14 pro php7.1 fpm
    buildImage 1.14 pro php7.2 apache
    buildImage 1.14 pro php7.2 fpm
    buildImage 1.14 pro php7.3 apache
    buildImage 1.14 pro php7.3 fpm
    buildImage 1.14 pro php7.4 apache
    buildImage 1.14 pro php7.4 fpm
    buildImage 1.14 open php7.1 apache
    buildImage 1.14 open php7.1 fpm
    buildImage 1.14 open php7.2 apache
    buildImage 1.14 open php7.2 fpm
    buildImage 1.14 open php7.3 apache
    buildImage 1.14 open php7.3 fpm
    buildImage 1.14 open php7.4 apache
    buildImage 1.14 open php7.4 fpm
    buildImage 1.14.1 pro php7.1 apache
    buildImage 1.14.1 pro php7.1 fpm
    buildImage 1.14.1 pro php7.2 apache
    buildImage 1.14.1 pro php7.2 fpm
    buildImage 1.14.1 pro php7.3 apache
    buildImage 1.14.1 pro php7.3 fpm
    buildImage 1.14.1 pro php7.4 apache
    buildImage 1.14.1 pro php7.4 fpm
    buildImage 1.14.1 open php7.1 apache
    buildImage 1.14.1 open php7.1 fpm
    buildImage 1.14.1 open php7.2 apache
    buildImage 1.14.1 open php7.2 fpm
    buildImage 1.14.1 open php7.3 apache
    buildImage 1.14.1 open php7.3 fpm
    buildImage 1.14.1 open php7.4 apache
    buildImage 1.14.1 open php7.4 fpm
    buildImage 1.14.2 pro php7.1 apache
    buildImage 1.14.2 pro php7.1 fpm
    buildImage 1.14.2 pro php7.2 apache
    buildImage 1.14.2 pro php7.2 fpm
    buildImage 1.14.2 pro php7.3 apache
    buildImage 1.14.2 pro php7.3 fpm
    buildImage 1.14.2 pro php7.4 apache
    buildImage 1.14.2 pro php7.4 fpm
}

function pullImages {
    pullImage php:7.4-fpm-buster
    pullImage php:7.4-apache-buster
    pullImage php:7.3-fpm-buster
    pullImage php:7.3-apache-buster
    pullImage php:7.2-fpm-buster
    pullImage php:7.2-apache-buster
    pullImage php:7.1-fpm-buster
    pullImage php:7.1-apache-buster
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
    log "Scan images for vulnerabilities"
    scanImage 1.14 pro php7.1 apache
    scanImage 1.14 pro php7.1 fpm
    scanImage 1.14 pro php7.2 apache
    scanImage 1.14 pro php7.2 fpm
    scanImage 1.14 pro php7.3 apache
    scanImage 1.14 pro php7.3 fpm
    scanImage 1.14 pro php7.4 apache
    scanImage 1.14 pro php7.4 fpm
    scanImage 1.14 open php7.1 apache
    scanImage 1.14 open php7.1 fpm
    scanImage 1.14 open php7.2 apache
    scanImage 1.14 open php7.2 fpm
    scanImage 1.14 open php7.3 apache
    scanImage 1.14 open php7.3 fpm
    scanImage 1.14 open php7.4 apache
    scanImage 1.14 open php7.4 fpm
    scanImage 1.14.1 pro php7.1 apache
    scanImage 1.14.1 pro php7.1 fpm
    scanImage 1.14.1 pro php7.2 apache
    scanImage 1.14.1 pro php7.2 fpm
    scanImage 1.14.1 pro php7.3 apache
    scanImage 1.14.1 pro php7.3 fpm
    scanImage 1.14.1 pro php7.4 apache
    scanImage 1.14.1 pro php7.4 fpm
    scanImage 1.14.1 open php7.1 apache
    scanImage 1.14.1 open php7.1 fpm
    scanImage 1.14.1 open php7.2 apache
    scanImage 1.14.1 open php7.2 fpm
    scanImage 1.14.1 open php7.3 apache
    scanImage 1.14.1 open php7.3 fpm
    scanImage 1.14.1 open php7.4 apache
    scanImage 1.14.1 open php7.4 fpm
    scanImage 1.14.2 pro php7.1 apache
    scanImage 1.14.2 pro php7.1 fpm
    scanImage 1.14.2 pro php7.2 apache
    scanImage 1.14.2 pro php7.2 fpm
    scanImage 1.14.2 pro php7.3 apache
    scanImage 1.14.2 pro php7.3 fpm
    scanImage 1.14.2 pro php7.4 apache
    scanImage 1.14.2 pro php7.4 fpm
}

function scanImage {
    local version="$1"
    local edition="$2"
    local php="$3"
    local service="$4"
    local tag="${DOCKER_IMAGE}:${version}-${edition}-${php}-${service}"

    log "Scan image $tag"
    docker run --rm -v /tmp/trivy:/root/.cache/ aquasec/trivy "$tag"
}

function runTests {
    pullImagesForTesting
    installNodePackages
    auditNodePackages
    lintMarkdownFiles
    lintYAMLFiles
    lintDockerfiles
    lintShellScripts
    testExecutableBits
}

function pullImagesForTesting {
    log "Pull Docker images"
    pullImage hadolint/hadolint:latest
    pullImage koalaman/shellcheck:latest
    pullImage node:lts
    pullImage cytopia/yamllint:latest
    pullImage aquasec/trivy:latest
}

function installNodePackages {
    log "Install Node packages"

    docker run --rm --name idoitdocker-npm \
        -v "$PWD":/usr/src/app -w /usr/src/app node:lts \
        npm install || abort "No good"
}

function auditNodePackages {
    docker run --rm --name idoitdocker-npm \
        -v "$PWD":/usr/src/app -w /usr/src/app node:lts \
        npm audit || abort "No good"
}

function lintMarkdownFiles {
    while read -r filePath; do
        lintMarkdownFile "$filePath"
    done < <(
        find "$(git rev-parse --show-toplevel)" \
            -type f -name "*.md" -not \
            -exec git check-ignore -q {} \; -printf '%P\n'
    )
}

function lintMarkdownFile {
    local filePath="$1"

    log "Lint markdown file $filePath"

    docker run --rm --name idoitdocker-npm \
        -v "$PWD":/usr/src/app -w /usr/src/app node:lts \
        ./node_modules/.bin/remark \
        --frail --quiet < "$filePath" > /dev/null || \
        abort "No good"
}

function lintYAMLFiles {
    while read -r filePath; do
        lintYAMLFile "$filePath"
    done < <(
        find "$(git rev-parse --show-toplevel)" \
            -type f -name "*.y*ml" -not \
            -exec git check-ignore -q {} \; -printf '%P\n'
    )
}

function lintYAMLFile {
    local filePath="$1"

    log "Lint YAML file $filePath"

    docker run --rm --name idoitdocker-yamllint \
        -v "$PWD":/data cytopia/yamllint:latest \
        "$filePath" || \
        abort "No good"
}

function lintDockerfiles {
    while read -r filePath; do
        lintDockerfile "$filePath"
    done < <(
        find "$(git rev-parse --show-toplevel)" \
            -type f -name "Dockerfile" -not \
            -exec git check-ignore -q {} \; -printf '%P\n'
    )
}

function lintDockerfile {
    local dockerfile="$1"

    log "Lint $dockerfile"

    docker run --rm -i -v "$PWD:/opt/hadolint/" hadolint/hadolint:latest \
        hadolint --config /opt/hadolint/.hadolint.yaml - < \
        "$dockerfile" || \
        abort "No good"
}

function lintShellScripts {
    while read -r filePath; do
        lintShellScript "$filePath"
    done < <(
        find . \
            -type f -name "*.sh" -not \
            -exec git check-ignore -q {} \; -printf '%P\n'
    )
}

function lintShellScript {
    local filePath="$1"

    log "Lint shell script $filePath"

    docker run \
        -v "$(pwd):/scripts" \
        koalaman/shellcheck:latest \
        "/scripts/$filePath" || \
        abort "No good"
}

function testExecutableBits {
    while read -r filePath; do
        testExecutableBit "$filePath"
    done < <(
        find . \
            -type f -name "*.sh" -not \
            -exec git check-ignore -q {} \; -printf '%P\n'
    )
}

function testExecutableBit {
    local filePath="$1"

    log "Check executable bit on shell script $filePath"

    test -x "$filePath" || \
        abort "Script is not executable"
}

function fix {
    fixFilePermissions
}

function fixFilePermissions {
    find . -type f -iname "*.sh" -exec chmod +x {} \; || \
        abort "Not good"
}

function pushImages {
    pushImage 1.14 pro php7.1 apache
    pushImage 1.14 pro php7.1 fpm
    pushImage 1.14 pro php7.2 apache
    pushImage 1.14 pro php7.2 fpm
    pushImage 1.14 pro php7.3 apache
    pushImage 1.14 pro php7.3 fpm
    pushImage 1.14 pro php7.4 apache
    pushImage 1.14 pro php7.4 fpm

    pushImage 1.14 open php7.1 apache
    pushImage 1.14 open php7.1 fpm
    pushImage 1.14 open php7.2 apache
    pushImage 1.14 open php7.2 fpm
    pushImage 1.14 open php7.3 apache
    pushImage 1.14 open php7.3 fpm
    pushImage 1.14 open php7.4 apache
    pushImage 1.14 open php7.4 fpm

    pushImage 1.14.1 pro php7.1 apache
    pushImage 1.14.1 pro php7.1 fpm
    pushImage 1.14.1 pro php7.2 apache
    pushImage 1.14.1 pro php7.2 fpm
    pushImage 1.14.1 pro php7.3 apache
    pushImage 1.14.1 pro php7.3 fpm
    pushImage 1.14.1 pro php7.4 apache
    pushImage 1.14.1 pro php7.4 fpm

    pushImage 1.14.1 open php7.1 apache
    pushImage 1.14.1 open php7.1 fpm
    pushImage 1.14.1 open php7.2 apache
    pushImage 1.14.1 open php7.2 fpm
    pushImage 1.14.1 open php7.3 apache
    pushImage 1.14.1 open php7.3 fpm
    pushImage 1.14.1 open php7.4 apache
    pushImage 1.14.1 open php7.4 fpm

    pushImage 1.14.2 pro php7.1 apache
    pushImage 1.14.2 pro php7.1 fpm
    pushImage 1.14.2 pro php7.2 apache
    pushImage 1.14.2 pro php7.2 fpm
    pushImage 1.14.2 pro php7.3 apache
    pushImage 1.14.2 pro php7.3 fpm
    pushImage 1.14.2 pro php7.4 apache
    pushImage 1.14.2 pro php7.4 fpm
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
    printSupportedTags 1.14.2 pro php7.4 fpm
    printSupportedTags 1.14.2 pro php7.4 apache
    printSupportedTags 1.14.2 pro php7.3 fpm
    printSupportedTags 1.14.2 pro php7.3 apache
    printSupportedTags 1.14.2 pro php7.2 fpm
    printSupportedTags 1.14.2 pro php7.2 apache
    printSupportedTags 1.14.2 pro php7.1 fpm
    printSupportedTags 1.14.2 pro php7.1 apache

    printSupportedTags 1.14.1 open php7.4 fpm
    printSupportedTags 1.14.1 open php7.4 apache
    printSupportedTags 1.14.1 open php7.3 fpm
    printSupportedTags 1.14.1 open php7.3 apache
    printSupportedTags 1.14.1 open php7.2 fpm
    printSupportedTags 1.14.1 open php7.2 apache
    printSupportedTags 1.14.1 open php7.1 fpm
    printSupportedTags 1.14.1 open php7.1 apache

    printSupportedTags 1.14.1 pro php7.4 fpm
    printSupportedTags 1.14.1 pro php7.4 apache
    printSupportedTags 1.14.1 pro php7.3 fpm
    printSupportedTags 1.14.1 pro php7.3 apache
    printSupportedTags 1.14.1 pro php7.2 fpm
    printSupportedTags 1.14.1 pro php7.2 apache
    printSupportedTags 1.14.1 pro php7.1 fpm
    printSupportedTags 1.14.1 pro php7.1 apache

    printSupportedTags 1.14 open php7.4 fpm
    printSupportedTags 1.14 open php7.4 apache
    printSupportedTags 1.14 open php7.3 fpm
    printSupportedTags 1.14 open php7.3 apache
    printSupportedTags 1.14 open php7.2 fpm
    printSupportedTags 1.14 open php7.2 apache
    printSupportedTags 1.14 open php7.1 fpm
    printSupportedTags 1.14 open php7.1 apache

    printSupportedTags 1.14 pro php7.4 fpm
    printSupportedTags 1.14 pro php7.4 apache
    printSupportedTags 1.14 pro php7.3 fpm
    printSupportedTags 1.14 pro php7.3 apache
    printSupportedTags 1.14 pro php7.2 fpm
    printSupportedTags 1.14 pro php7.2 apache
    printSupportedTags 1.14 pro php7.1 fpm
    printSupportedTags 1.14 pro php7.1 apache
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
    log "build|clean|fix|help|login|logout|print|pull|push|scan|test"
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
