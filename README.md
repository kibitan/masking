# MasKING🤴

[![CircleCI](https://circleci.com/gh/kibitan/masking/tree/main.svg?style=svg)](https://circleci.com/gh/kibitan/masking/tree/main)
[![Acceptance Test MySQL Status](https://github.com/kibitan/masking/workflows/Acceptance%20Test%20MySQL/badge.svg?branch=main)](https://github.com/kibitan/masking/actions?query=workflow%3A%22Acceptance+Test+MySQL%22+branch%3Amain)
[![Acceptance Test MariaDB Status](https://github.com/kibitan/masking/workflows/Acceptance%20Test%20MariaDB/badge.svg?branch=main)](https://github.com/kibitan/masking/actions?query=workflow%3A%22Acceptance+Test+MariaDB%22+branch%3Amain)
[![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=kibitan_masking)](https://sonarcloud.io/summary/new_code?id=kibitan_masking)

[![codecov](https://codecov.io/gh/kibitan/masking/branch/main/graph/badge.svg)](https://codecov.io/gh/kibitan/masking)
[![Maintainability](https://api.codeclimate.com/v1/badges/290b3005ecc193a3d138/maintainability)](https://codeclimate.com/github/kibitan/masking/maintainability)
[![CodeScene Code Health](https://codescene.io/projects/38627/status-badges/code-health)](https://codescene.io/projects/38627)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=kibitan_masking&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=kibitan_masking)

[![Gem Version](https://badge.fury.io/rb/masking.svg)](https://badge.fury.io/rb/masking)
<!--
[![CodeScene System Mastery](https://codescene.io/projects/38627/status-badges/system-mastery)](https://codescene.io/projects/38627)
[![CodeScene Missed Goals](https://codescene.io/projects/38627/status-badges/missed-goals)](https://codescene.io/projects/38627)
-->

The command line tool for anonymizing database records by parsing a SQL dump file and build a new SQL dump file with masking sensitive/credential data.

## Installation

```bash
gem install masking
```

## Requirement

* Ruby 2.6/2.7/3.0/3.1/3.2

## Supporting RDBMS

* MySQL: 5.5<sup>[1](#footnote1)</sup>, 5.6, 5.7, 8.0
* MariaDB: 5.5, 10.0<sup>[2](#footnote2)</sup>, 10.1, 10.2, 10.3, 10.4, 10.5, 10.6, 10.7, 10.8, 10.9, 10.10, 10.11

## Usage

1. Setup configuration for anonymizing target tables/columns to `masking.yml`

    *NOTE: the columns which doesn't mention here will be NOT anonymized, it stays as it is.*

    ```yaml
    # table_name:
    #   column_name: masked_value

    users:
      string: anonymized string
      email: anonymized+%{n}@example.com # %{n} will be replaced with sequential number
      integer: 12345
      float: 123.45
      boolean: true
      null_column: null
      date: 2018-08-24
      time: 2018-08-24 15:54:06
      binary_or_blob: !binary | # Binary Data Language-Independent Type for YAML™ Version 1.1: http://yaml.org/type/binary.html
        R0lGODlhDAAMAIQAAP//9/X17unp5WZmZgAAAOfn515eXvPz7Y6OjuDg4J+fn5
        OTk6enp56enmlpaWNjY6Ojo4SEhP/++f/++f/++f/++f/++f/++f/++f/++f/+
        +f/++f/++f/++f/++f/++SH+Dk1hZGUgd2l0aCBHSU1QACwAAAAADAAMAAAFLC
        AgjoEwnuNAFOhpEMTRiggcz4BNJHrv/zCFcLiwMWYNG84BwwEeECcgggoBADs=
      # When a column name is suffixed with `?`, the original NULL value will not be anonymized.
      # This option can be beneficial for simulating SQL execution that closely resembles the original data.
      nullable_string?: anonymized nullable %{n} string
    ```

    A value will be implicitly converted to a compatible type. If you prefer to explicitly convert, you could use a tag as defined in [YAML Version 1.1](http://yaml.org/spec/current.html#id2503753)

    ```yaml
    not-date: !!str 2002-04-28
    ```

    String should be matched with [MySQL String Type]( https://dev.mysql.com/doc/refman/8.0/en/string-type-overview.html). Integer/Float should be matched with [MySQL Numeric Type](https://dev.mysql.com/doc/refman/8.0/en/numeric-type-overview.html). Date/Time should be matched with [MySQL Date and Time Type](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-type-overview.html).

    *NOTE: MasKING doesn't check actual schema's type from the dump. If you put incompatible value it will cause an error during restoring to the database.*

1. Dump database with anonymizing

    MasKING works with `mysqldump --complete-insert`

    ```bash
      mysqldump --complete-insert -u USERNAME DATABASE_NAME | masking > anonymized_dump.sql
    ```

1. Restore from the anonymized dump file

    ```bash
      mysql -u USERNAME ANONYMIZED_DATABASE_NAME < anonymized_dump.sql
    ```

    Tip: If you don't need to have an anonymized dump file, you can directly insert it from the stream. It can be faster because it has less IO interaction.

      ```bash
        mysqldump --complete-insert -u USERNAME DATABASE_NAME | masking | mysql -u USERNAME ANONYMIZED_DATABASE_NAME
      ```

### options

```bash
$ masking -h
Usage: masking [options]
    -c, --config=FILE_PATH           specify config file. default: masking.yml
    -v, --version                    version
```

## Use case of anonymized (production) database

* Analyzing production databases for BI, Machine Learning, troubleshooting with respecting GDPR
* Stress test / Integration test
* Performance optimization for slow query

  The analyzing slow query often needs a similar amount of records/cardinality with production, the anonymized database help to analyze and tune the slow query.

* Simulating database migration

  Some schema migration locks table and it causes trouble during the execution. With a smaller amount of database, the migration will finish in a short time and easy to overlook the problem. With the anonymized production database, it is easy to simulate the migration as the real release and makes it easy to find the problem.

* Better feature development flow

  Using similar data with the production database makes better development experience. It makes easy to find out the things which should be changed/fixed. Also, some bugs are related to unexpected data in production, it makes easy to find them too.

* And… your idea here!

## Development

```bash
git clone git@github.com:kibitan/masking.git
bin/setup
```

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### boot

```bash
  bundle exec exe/masking
```

### Run test & rubocop & notes

```bash
  bundle exec rake
```

#### acceptance test

```bash
./acceptance/run_test.sh
```

available option via environment variable:

* `MYSQL_HOST`: database host(default: `localhost`)
* `MYSQL_USER`: mysql user name(default: `mysqluser`}
* `MYSQL_PASSWORD`: password for user(default: `password`)
* `MYSQL_DBNAME`: database name(default: `mydb`)

##### with docker-compose

```bash
docker-compose -f docker-compose.yml -f docker-compose/mysql80.yml run -e MYSQL_HOST=mysql80 app acceptance/run_test.sh
```

or

```bash
docker-compose/acceptance_test.sh mysql80
```

The docker-compose file names for other database versions, specify that file.

* MySQL 8.0: [`docker-compose/mysql80.yml`](./docker-compose/mysql80.yml)
* MySQL 5.7: [`docker-compose/mysql57.yml`](./docker-compose/mysql57.yml)
* MySQL 5.6: [`docker-compose/mysql56.yml`](./docker-compose/mysql56.yml)
* MySQL 5.5<sup>[1](#footnote1)</sup>: [`docker-compose/mysql55.yml`](./docker-compose/mysql55.yml)
* MariaDB 10.11: [`docker-compose/mariadb1011.yml`](./docker-compose/mariadb1011.yml)
* MariaDB 10.10: [`docker-compose/mariadb1010.yml`](./docker-compose/mariadb1010.yml)
* MariaDB 10.9: [`docker-compose/mariadb109.yml`](./docker-compose/mariadb109.yml)
* MariaDB 10.8: [`docker-compose/mariadb108.yml`](./docker-compose/mariadb108.yml)
* MariaDB 10.7: [`docker-compose/mariadb107.yml`](./docker-compose/mariadb107.yml)
* MariaDB 10.6: [`docker-compose/mariadb106.yml`](./docker-compose/mariadb106.yml)
* MariaDB 10.5: [`docker-compose/mariadb105.yml`](./docker-compose/mariadb105.yml)
* MariaDB 10.4: [`docker-compose/mariadb104.yml`](./docker-compose/mariadb104.yml)
* MariaDB 10.3: [`docker-compose/mariadb103.yml`](./docker-compose/mariadb103.yml)
* MariaDB 10.2: [`docker-compose/mariadb102.yml`](./docker-compose/mariadb102.yml)
* MariaDB 10.1: [`docker-compose/mariadb101.yml`](./docker-compose/mariadb101.yml)
* MariaDB 10.0<sup>[2](#footnote2)</sup>: [`docker-compose/mariadb100.yml`](./docker-compose/mariadb100.yml)
* MariaDB 5.5: [`docker-compose/mariadb55.yml`](./docker-compose/mariadb55.yml)

#### [Markdown lint](https://github.com/markdownlint/markdownlint)

```bash
bundle exec mdl *.md
```

## Development with Docker

```bash
docker build . -t masking
echo "sample stdout" | docker run -i masking
docker run masking -v
docker run --entrypoint sh -it masking # inside of docker container
```

## Profiling

use `bin/masking_profile`

```bash
 $ cat your_sample.sql | bin/masking_profile
flat result is saved at /your/repo/profile/flat.txt
graph result is saved at /your/repo/profile/graph.txt
graph html is saved at /your/repo/profile/graph.html

 $ open profile/flat.txt
```

see also: [ruby-prof/ruby-prof: ruby-prof: a code profiler for MRI rubies](https://github.com/ruby-prof/ruby-prof)

### Benchmark

use `benchmark/run.rb`

```bash
$ benchmark/run.rb
       user     system      total        real
   1.103012   0.009460   1.112472 (  1.123093)
```

## Design Concept

### KISS ~ keep it simple, stupid ~

No connection to the database, No handling files, Only dealing with stdin/stdout. ~ Do One Thing and Do It Well ~

### No External Dependency

Depend on only pure language standard libraries, no external libraries

## Future Todo

* Pluggable/customizable for a mask way  e.g. integrate with [Faker](https://github.com/stympy/faker)
* Compatible with other RDBMS  e.g. PostgreSQL, Oracle, SQL Server
* Parse the schema type information and validate target columns value
* Performance optimization
  * Write in the streaming process
  * rewrite by another language?
* Well-documentation

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/kibitan/masking](https://github.com/kibitan/masking).
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Masking project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kibitan/masking/blob/main/CODE_OF_CONDUCT.md).

<a name="footnote1">1</a>: <small> MySQL 5.5 is already not supported by [official](https://www.mysql.com/support/supportedplatforms/database.html)</small>

<a name="footnote2">2</a>: <small> MariaDB 10.0 is already not supported by [official](https://mariadb.org/about/maintenance-policy/)</small>
