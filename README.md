# MasKING🤴

[![Build Status](https://travis-ci.org/kibitan/masking.svg?branch=master)](https://travis-ci.org/kibitan/masking)
[![Coverage Status](https://coveralls.io/repos/github/kibitan/masking/badge.svg?branch=master)](https://coveralls.io/github/kibitan/masking?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/290b3005ecc193a3d138/maintainability)](https://codeclimate.com/github/kibitan/masking/maintainability)
[![Gem Version](https://badge.fury.io/rb/masking.svg)](https://badge.fury.io/rb/masking)

The command line tool for anonymizing database records by parsing a SQL dump file and build new SQL dump file with masking sensitive/credential data.

## Installation

```bash
gem install masking
```

## Requirement

* Ruby 2.5/2.6

## Supported RDBMS

* MySQL 5.7...(TBC)

## Usage

1. Setup configuration for anonymizing target tables/columns to `masking.yml`

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
    ```

    A value will be implicitly converted to compatible type. If you prefer to explicitly convert, you could use a tag as defined in [YAML Version 1.1](http://yaml.org/spec/current.html#id2503753)

    ```yaml
      not-date: !!str 2002-04-28
    ```

    String should be matched with [MySQL String Type]( https://dev.mysql.com/doc/refman/8.0/en/string-type-overview.html). Integer/Float should be matched with [MySQL Numeric Type](https://dev.mysql.com/doc/refman/8.0/en/numeric-type-overview.html). Date/Time should be matched with [MySQL Date and Time Type](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-type-overview.html).

    *NOTE: MasKING doesn't check actual schema's type from dump. If you put uncomaptible value it will cause error during restoring to database.*

1. Dump database with anonymizing

    MasKING works with `mysqldump --complete-insert`

    ```bash
      mysqldump --complete-insert -u USERNAME DATABASE_NAME | masking > anonymized_dump.sql
    ```

1. Restore from anonymized dump file

    ```bash
      mysql -u USERNAME ANONYMIZED_DATABASE_NAME < anonymized_dump.sql
    ```

    Tip: If you don't need to have anonymized dump file, you can directly insert from stream. It can be faster because it has less IO interaction.

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

## Use case of annonymized (production) database

* Simulate for database migration and find a problem before release

Some schema changing statement will lock table and it will cause trouble during the migration. But, without having a large number of record such as production, a migration will finish at the moment and easy to overlook.

* Performance optimization of database queries

Some database query can be slow, but some query isn't reproducible until you have similar amount of records/cardinality.

* Finding bug before release on production

Some bugs are related to unexpected data in production (for instance so long text, invalid/not-well formatted data) and it might be noticed after releasing in production.

* Better development/demo of a feature

Using similar data with real one will be good to make a good view of how feature looks like. It makes easy to find out the things to be changed/fixed before release/check the feature in production.

* Analyze metrics on our production data with respecting GDPR

We can use this database for BI and some trouble shooting.

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

#### acceptance test (with docker)

* MySQL 8.0

```bash
 docker-compose -f docker-compose.yml -f docker-compose_mysql80.yml run --entrypoint sh app acceptance/run_test.sh
```

* MySQL 5.7

```bash
 docker-compose -f docker-compose.yml -f docker-compose_mysql57.yml run --entrypoint sh app acceptance/run_test.sh
```

* MySQL 5.6

```bash
 docker-compose -f docker-compose.yml -f docker-compose_mysql56.yml run --entrypoint sh app acceptance/run_test.sh
```

* MySQL 5.5

```bash
 docker-compose -f docker-compose.yml -f docker-compose_mysql55.yml run --entrypoint sh app acceptance/run_test.sh
```

#### [Markdown lint](https://github.com/markdownlint/markdownlint)

```bash
bundle exec mdl *.md
```

## Development with Docker

```bash
docker build . -t masking --target app
echo "sample stdout" | docker run -i masking
docker run masking -v
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

use `bin/benchmark.rb`

```bash
$ bin/benchmark.rb
       user     system      total        real
   1.152776   0.207064   1.359840 (  1.375090)
```

## Design Concept

### KISS ~ keep it simple, stupid ~

No connection to database, No handling file, Only dealing with stdin/stdout. ~ Do One Thing and Do It Well ~

### No External Dependency

Depend on only pure language standard libraries, no external libraries. (except development/test environment)

## Future Todo

* Pluguable/customizable for a mask way  e.g. integrate with [Faker](https://github.com/stympy/faker)
* Compatible with other RDBMS  e.g. PostgreSQL, Oracle, SQL Server
* Parse the schema type information and validate target columns value
* Integration test with real database
* Performance optimization
  * Write in streaming process
  * rewrite by another language?
* Well-documentation

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/kibitan/masking](https://github.com/kibitan/masking).
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Masking project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kibitan/masking/blob/master/CODE_OF_CONDUCT.md).
