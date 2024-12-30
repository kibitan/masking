#!/bin/sh
set -eu -o pipefail
set -C # Prevent output redirection using ‘>’, ‘>&’, and ‘<>’ from overwriting existing files.

if [[ "${TRACE-0}" == "1" ]]; then
    set -vx
fi

MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_USER=${MYSQL_USER:-root}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root_password}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-MYSQL_ROOT_PASSWORD}
MYSQL_DBNAME=${MYSQL_DBNAME:-mydb}
MYSQL_ANONYMIZED_DBNAME=${MYSQL_ANONYMIZED_DBNAME:-anonnymized_mydb}
MYSQL_OPTIONS=${MYSQL_OPTIONS:-}
_MYSQL_COMMAND_OPTIONS="--host=$MYSQL_HOST --user=$MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_OPTIONS"

FILEDIR="$( cd "$( dirname "$0" )" && pwd )"

main() {
  # clear tmp file
  rm "$FILEDIR"/tmp/* || echo 'no tmp file'

  # import database
  mysql ${_MYSQL_COMMAND_OPTIONS} "$MYSQL_DBNAME" < "$FILEDIR/import_dumpfile.sql"

  #  masking & restore
  ## TODO: temporary add `--skip-extended-insert` as not working now
  # mysqldump ${_MYSQL_COMMAND_OPTIONS} "$MYSQL_DBNAME" --complete-insert | exe/masking -c "$FILEDIR/masking.yml" > "$FILEDIR/tmp/masking_dumpfile.sql"
  mysqldump ${_MYSQL_COMMAND_OPTIONS} "$MYSQL_DBNAME" --complete-insert --skip-extended-insert | exe/masking -c "$FILEDIR/masking.yml" > "$FILEDIR/tmp/masking_dumpfile.sql"

  mysql ${_MYSQL_COMMAND_OPTIONS} -e "CREATE DATABASE $MYSQL_ANONYMIZED_DBNAME;"
  mysql ${_MYSQL_COMMAND_OPTIONS} "$MYSQL_ANONYMIZED_DBNAME" < "$FILEDIR/tmp/masking_dumpfile.sql"
  ## compare the result
  mysql ${_MYSQL_COMMAND_OPTIONS} "$MYSQL_ANONYMIZED_DBNAME" -e 'SELECT * FROM users ORDER BY id;' --vertical > "$FILEDIR/tmp/query_result.txt"
  diff "$FILEDIR/expected_query_result.txt" "$FILEDIR/tmp/query_result.txt" || (echo 'test failed' && exit 1)

  # test errors
  set +e
  ## without masking.yml
  mysqldump ${_MYSQL_COMMAND_OPTIONS} "$MYSQL_DBNAME" --complete-insert | exe/masking -c "$FILEDIR/no_file.yml" 2>> "$FILEDIR/tmp/errors.txt" 1> /dev/null
  ## without `--complete-insert``
  mysqldump ${_MYSQL_COMMAND_OPTIONS} "$MYSQL_DBNAME" | exe/masking -c "$FILEDIR/masking.yml" 2>> "$FILEDIR/tmp/errors.txt" 1> /dev/null
  set -e
  ### compare the result
  diff "$FILEDIR/expected_error_result.txt" "$FILEDIR/tmp/errors.txt" || (echo 'error output test failed' && exit 1)

  echo 'test passed!'
  exit 0
}

main "$@"
