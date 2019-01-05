# MasKING🤴

[![Build Status](https://travis-ci.org/kibitan/masking.svg?branch=master)](https://travis-ci.org/kibitan/masking)
[![Coverage Status](https://coveralls.io/repos/github/kibitan/masking/badge.svg?branch=master)](https://coveralls.io/github/kibitan/masking?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/290b3005ecc193a3d138/maintainability)](https://codeclimate.com/github/kibitan/masking/maintainability)

The command line tool for anonymizing database records by parsing a SQL dump file and build new SQL dump file with masking sensitive/credential data.

## Installation

```bash
git clone git@github.com:kibitan/masking.git
bin/setup
```

or install it yourself as:

```bash
gem install masking
```

(not published to RubyGems yet)

## Requirement

* Ruby 2.5/2.6

## Supported RDBMS

* MySQL 5.7...(TBC)

## Usage

1. setup configuration of target columns to `masking.yml`

  ```yaml
  # table_name:
  #   column_name: masked_value

  users:
    string: anonymized string
    email: anonymized+%{n}@example.com # %{n} will be replaced with sequential number
    integer: 12345
    float: 123.45
    boolean: true
    null: null
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

1. dump with mask

  MasKING works with `mysqldump --complete-insert`

  ```bash
    mysqldump --complete-insert -u USERNAME DATABASE_NAME | masking > masked_dump.sql
  ```

1. restore

  ```bash
    mysql -u USERNAME MASKED_DATABASE_NAME < masked_dump.sql
  ```

### options

```bash
$ masking -h
Usage: masking [options]
    -c, --config=FILE_PATH           specify config file. default: masking.yml
```

## Run test & rubocop & notes

```bash
  bundle exec rake
```

### Protip

It's useful that set `rake` on [Git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).

```bash
touch .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit && cat << EOF > .git/hooks/pre-commit
#!/usr/bin/env bash
bundle exec rake
EOF
```

### [Markdown lint](https://github.com/markdownlint/markdownlint)

```bash
bundle exec mdl *.md
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Profiling

use `bin/masking_profile`

```bash
 $ cat your_sample.sql | bin/masking_profile
flat result is saved at /your/repo/profile/flat.txt
graph result is saved at /your/repo/profile/graph.txt
graph html is saved at /your/repo/profile/graph.html

 $ open profile/flat.txt
```

see also: [ruby-prof/ruby-prof: ruby-prof: a code profiler for MRI rubies](https://github.com/ruby-prof/ruby-prof)

## Design Concept

### KISS ~ keep it simple, stupid ~

No connection to database, No handling file, Only dealing with stdin/stdout. ~ Do One Thing and Do It Well ~

### No External Dependency

Depend on only pure language standard libraries, no external libraries. (except development/test enviorment)

### High Code Quality

100% of code coverage [![Coverage Status](https://coveralls.io/repos/github/kibitan/masking/badge.svg?branch=master)](https://coveralls.io/github/kibitan/masking?branch=master) and low complexity [![Maintainability](https://api.codeclimate.com/v1/badges/290b3005ecc193a3d138/maintainability)](https://codeclimate.com/github/kibitan/masking/maintainability)

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
