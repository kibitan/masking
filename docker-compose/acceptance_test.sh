#!/usr/bin/env bash

set -Ceu -o pipefail
#set -vx # for debug

MYSQL_VERSION=${1:-mysql80}
DOCKER_COMPOSE_FILE=${2:-docker-compose.yml}
docker-compose -f "$DOCKER_COMPOSE_FILE" -f "docker-compose/$MYSQL_VERSION.yml" run -e "MYSQL_HOST=$MYSQL_VERSION" app acceptance/run_test.sh
