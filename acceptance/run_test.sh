#!/bin/sh

set -Ceu -o pipefail
set -vx

FILEDIR="$( cd "$( dirname "$0" )" && pwd )"

## clear tmp file
rm $FILEDIR/tmp/*

## import database
mysql -h mysqldb -u mysqluser -ppassword mydb < $FILEDIR/import_dumpfile.sql

## masking
mysqldump -h mysqldb -u mysqluser -ppassword mydb --complete-insert | exe/masking -c $FILEDIR/masking.yml > $FILEDIR/tmp/masking_dumpfile.sql
mysql -h mysqldb -u mysqluser -ppassword mydb < $FILEDIR/tmp/masking_dumpfile.sql

## compare
mysql -h mysqldb -u mysqluser -ppassword mydb -e 'SELECT * FROM users ORDER BY id;' --vertical > $FILEDIR/tmp/query_result.txt
diff $FILEDIR/tmp/query_result.txt $FILEDIR/expected_query_result.txt
