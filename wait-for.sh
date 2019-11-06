#!/bin/sh
# inspited from Control startup and shutdown order in Compose | Docker Documentation: https://docs.docker.com/compose/startup-order/

set -e

MYSQL_USER=${MYSQL_USER:-mysqluser}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}

MYSQL_HOST="$1"
shift
cmd=$*

until mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e 'exit'; do
  >&2 echo "mysql is unavailable - sleeping"
  sleep 1
done

>&2 echo "mysql is up - executing command"
exec $cmd
