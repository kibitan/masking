# MasKING🤴
[![Build Status](https://travis-ci.org/kibitan/masking.svg?branch=master)](https://travis-ci.org/kibitan/masking)
[![Maintainability](https://api.codeclimate.com/v1/badges/290b3005ecc193a3d138/maintainability)](https://codeclimate.com/github/kibitan/masking/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/kibitan/masking/badge.svg?branch=master)](https://coveralls.io/github/kibitan/masking?branch=master)

**Caution: this library is WIP now**

Command line tool of input MySQL database dump file, mask sensitive data and output.

## Installation



```bash
 $ git clone git@github.com:kibitan/masking.git
 $ bin/setup
```

or install it yourself as:

    $ gem install masking

(not published to RubyGems yet)

## Requirement

 * Ruby 2.5

## Supported RDBMS

 * MySQL 5.7...(TBC)

## Usage

1. setup configuration of target columns to `target_columns.yml`

  ```yaml
  # table_name:
  #   column_name: masked_value

  users:
    string: anonymized string
    email: anonymized+%{n}@example.com # %{n} will be replaced with sequencial number
    integer: 12345
    float: 123.45
    boolean: true
    null: null
    date: 2018-08-24
    time: 2018-08-24 15:54:06
  ```

A value will be implicitly converted to compatible type. If you prefer to explicitly convert, you could use a tag as defined in [YAML Version 1.1 ](http://yaml.org/spec/current.html#id2503753)

```yaml
not-date: !!str 2002-04-28
```

String should be matched with [MySQL String Type]( https://dev.mysql.com/doc/refman/8.0/en/string-type-overview.html). Integer/Float should be matched with [MySQL Numeric Type](https://dev.mysql.com/doc/refman/8.0/en/numeric-type-overview.html). Date/Time should be matched with [MySQL Date and Time Type](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-type-overview.html).


*NOTE: MasKING doesn't check actual schema's type from dump. If you put uncomaptible value it will cause error during restoring to database.*

2. dump with mask

  MasKING works with `mysqldump --complete-insert`

  ```
    $ mysqldump --complete-insert -u USERNAME DATABASE_NAME | masking > masked_dump.sql
  ```

3. restore

  ```
   $ mysql -u USERNAME MASKED_DATABASE_NAME < masked_dump.sql
  ```

### options

```bash
$ masking -h
Usage: masking [options]
    -c, --config=FILE_PATH           specify config file. default: target_columns.yml
```


## Run test

```
 $ bundle exec rspec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


Recommend to setup [pre-commit](https://github.com/jish/pre-commit)

```
$ pre-commit install
```

## TODO

 - [x] commandline-tool `Thor`
 - [x] load config `target_columns.yml`
   - [x] define `TargetColumns` class
   - [ ] generator
   - [ ] validate `target_columns.yml` ( format / exists )
 - [x] input SQLDump from stdin
 - [x] parse SQL
 - [x] mask data ( only fixed string )
   - [ ] Type
     - [x] verify Date/Time format
   - [x] sequencial value "%{n}"
 - [x] output SQL to stdout
   - [ ] fix bug: work with binary data (non utf-8)
 - write integration test
   - [ ] with types
   - [ ] make unit test decoupled
 - [ ] refactoring
   - [ ] rename Masking::Config::TargetColumns::Column::Method
   - [ ] extract Masking::Config::TargetColumns::TargetColumns.tables ( yaml parser )
   - [ ] singletonize Masking::Config::TargetColumns
   - [ ] rename Masking::Config::TargetColumns
   - [ ] refactoring inside of DataMaskProcessor.process
   - [ ] rename DataMaskProcessor
 - [ ] publish to gem
 - [ ] publish to HomeBrew?

 - setup CI
   - [x] TravisCI
   - [x] CodeClimate
   - [x] Coverage
   - [ ] rubocop
   - [ ] SideCI(rubocop, reek)
   - [ ] PR ready
   - [ ] rake notes

## Future Todo

 - pluguable/customizable for masking way e.g. using Faker
 - Compatible with other RDBMS e.g. PostgreSQL, Oracle etc
 - parse the schema type information and validate target columns value
 - (integration test with real database)
 - perfomance optimization
   - make streaming process
   - rewrite by another language?

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kibitan/masking. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Masking project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kibitan/masking/blob/master/CODE_OF_CONDUCT.md).
