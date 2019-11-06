#!/usr/bin/env bash

set -Ceu -o pipefail
#set -vx # for debug

MYSQL_VERSION=${1:-mysql80}
docker-compose -f docker-compose.yml -f "docker-compose/$MYSQL_VERSION.yml" run -e "MYSQL_HOST=$MYSQL_VERSION" app acceptance/run_test.sh
