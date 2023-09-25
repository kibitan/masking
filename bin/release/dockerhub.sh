#!/usr/bin/env bash

set -eu -o pipefail
set -C # Prevent output redirection using ‘>’, ‘>&’, and ‘<>’ from overwriting existing files.

if [[ "${TRACE-0}" == "1" ]]; then
    set -vx
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./dockerhub.sh version [latest]

publish the image to dockerhub with the given version and tag it as latest if latest is true.

'
    exit
fi

cd "$(dirname "$0")"

main() {
    local -r version="${1-}"
    local -r latest="${2-}"

    if [[ -z "${version}" ]]; then
        echo "Version is required"
        exit 1
    fi

    docker build -f ../../Dockerfile.publish -t "masking:${version}" .
    docker tag "masking:${version}" "kibitan/masking:${version}"
    docker push "kibitan/masking:${version}"

    # if LATEST is true, push the image with the latest tag
    if [[ "${latest}" == "1" ]]; then
        docker tag "masking:${version}" "kibitan/masking:latest"
        docker push "kibitan/masking:latest"
    fi
}

main "$@"
