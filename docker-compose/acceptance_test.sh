#!/usr/bin/env bash
set -eu -o pipefail
set -C # Prevent output redirection using ‘>’, ‘>&’, and ‘<>’ from overwriting existing files.

if [[ "${TRACE-0}" == "1" ]]; then
    set -vx
fi

cd "$(dirname "$0")"

MYSQL_VERSION=${1:-mysql80}
DOCKER_COMPOSE_FILE=${2:-docker-compose.yml}
TRACE=${TRACE:-0}

main() {
  docker-compose -f "../$DOCKER_COMPOSE_FILE" -f "./$MYSQL_VERSION.yml" run -e "MYSQL_HOST=$MYSQL_VERSION" -e "TRACE=$TRACE" app acceptance/run_test.sh
}

main "$@"
