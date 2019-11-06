#!/bin/sh

set -Ceu -o pipefail
# set -vx # for debug

MYSQL_HOST=${MYSQL_HOST:localhost}
MYSQL_USER=${MYSQL_USER:-mysqluser}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}
MYSQL_DBNAME=${MYSQL_DBNAME:-mydb}

FILEDIR="$( cd "$( dirname "$0" )" && pwd )"

## clear tmp file
rm "$FILEDIR"/tmp/* || echo 'no tmp file'

## import database
mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" < "$FILEDIR/import_dumpfile.sql"

## masking
mysqldump -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" --complete-insert | exe/masking -c "$FILEDIR/masking.yml" > "$FILEDIR/tmp/masking_dumpfile.sql"
mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" < "$FILEDIR/tmp/masking_dumpfile.sql"

## compare
mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" -e 'SELECT * FROM users ORDER BY id;' --vertical > "$FILEDIR/tmp/query_result.txt"
diff "$FILEDIR/tmp/query_result.txt" "$FILEDIR/expected_query_result.txt" && echo 'test passed!'
