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

## Usage

1. setup configuration of target columns to `target_columns.yml`

  ```yaml
  # table_name:
  #   column_name: mask_mathod

  users:
    name: name
    email: email
    password_digest: string
  ```

2. dump with mask

  MasKING works with `mysqldump --complete-insert`

  ```
    $ mysqldump --complete-insert -u USERNAME DATABASE_NAME | masking > masked_dump.sql
  ```

3. restore

  ```
   $ mysql -u USERNAME MASKED_DATABASE_NAME < masked_dump.sql
  ```

## Run test

```
 $ bundle exec rspec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## TODO

 - [x] commandline-tool `Thor`
 - [x] load config `target_columns.yml`
   - [x] define `TargetColumns` class
   - [ ] generator
   - [ ] validate `target_columns.yml` ( format / exists )
 - [x] input SQLDump from stdin
 - [x] parse SQL
   - [ ] streaming process
 - [x] mask data ( only fixed string )
   - [ ] various Type
   - [ ] dynamic dummy value
   - [ ] Faker
 - [x] output SQL to stdout
   - [ ] work with binary data
 - [ ] write integration test
 - [ ] publish to gem
 - [ ] publish to HomeBrew?

 - [ ] setup CI
   - [x] TravisCI
   - [x] CodeClimate
   - [x] Coverage
   - [ ] SideCI(rubocop, reek)
   - [ ] PR ready
   - [ ] rake notes

## Future Todo

 - pluguable/customizable for masking way
 - Compatible with other RDBMS e.g. PostgreSQL, Oracle etc
 - perfomance optimization: rewrite by another language?

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kibitan/masking. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Masking project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kibitan/masking/blob/master/CODE_OF_CONDUCT.md).
