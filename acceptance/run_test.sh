#!/bin/sh
set -eu -o pipefail
set -C # Prevent output redirection using ‘>’, ‘>&’, and ‘<>’ from overwriting existing files.

if [[ "${TRACE-0}" == "1" ]]; then
    set -vx
fi
DUMPFILE_DEBUG="${DUMPFILE_DEBUG:-0}"

MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_USER=${MYSQL_USER:-root}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root_password}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-MYSQL_ROOT_PASSWORD}
MYSQL_DBNAME=${MYSQL_DBNAME:-mydb}
MYSQL_ANONYMIZED_DBNAME=${MYSQL_ANONYMIZED_DBNAME:-anonnymized_mydb}

FILEDIR="$( cd "$( dirname "$0" )" && pwd )"

main() {
  # clear tmp file
  rm "$FILEDIR"/tmp/* || echo 'no tmp file'

  # import database
  mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" < "$FILEDIR/import_dumpfile.sql"

  #  masking & restore
  mysqldump -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" --complete-insert > "$FILEDIR/tmp/mysqldump_output.sql"
  if [[ "${DUMPFILE_DEBUG}" == "1" ]]; then
    echo "--- mysqldump output ---"
    cat "$FILEDIR/tmp/mysqldump_output.sql"
    echo "--- mysqldump output end ---"
    echo ""
  fi
  cat "$FILEDIR/tmp/mysqldump_output.sql" | exe/masking -c "$FILEDIR/masking.yml" > "$FILEDIR/tmp/masking_dumpfile.sql"

  mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "CREATE DATABASE $MYSQL_ANONYMIZED_DBNAME;"
  mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_ANONYMIZED_DBNAME" < "$FILEDIR/tmp/masking_dumpfile.sql"
  ## compare the result
  mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_ANONYMIZED_DBNAME" -e 'SELECT * FROM users ORDER BY id;' --vertical > "$FILEDIR/tmp/query_result.txt"
  diff "$FILEDIR/expected_query_result.txt" "$FILEDIR/tmp/query_result.txt" || (echo 'test failed' && exit 1)

  # test errors
  set +e
  ## without masking.yml
  mysqldump -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" --complete-insert | exe/masking -c "$FILEDIR/no_file.yml" 2>> "$FILEDIR/tmp/errors.txt" 1> /dev/null
  ## without `--complete-insert``
  mysqldump -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" | exe/masking -c "$FILEDIR/masking.yml" 2>> "$FILEDIR/tmp/errors.txt" 1> /dev/null
  set -e
  ### compare the result
  diff "$FILEDIR/expected_error_result.txt" "$FILEDIR/tmp/errors.txt" || (echo 'error output test failed' && exit 1)

  echo 'test passed!'
  exit 0
}

main "$@"
