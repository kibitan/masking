<a name="unreleased"></a>
## [Unreleased]


<a name="v0.0.2"></a>
## [v0.0.2] - 2019-01-06
### Fix
- fix bug about NoMethodError


<a name="v0.0.1"></a>
## v0.0.1 - 2019-01-05
### Build
- apply rubocop `rubocop --auto-gen-config`
- addding debug stuffs

### Chore
- make it easy to require spec_helper in bin/console
- sort dependent libraries

### Ci
- remove SimpleCov(it includes in Coverall)
- setup Coveralls
- update TEST REPORTER ID of CodeClimate
- adding CodeClimate test coverage report
- setup Travis CI

### Docs
- remove unneccessary comment
- move TODO list into issue
- put implementation memo
- adding cli option
- update README and relatives about convertion of types
- update README
- update README of future TODO
- update README
- update README
- write code sample as comment for considering class design
- add refactoring comment
- adding NOTE
- add TODO
- add specific comment
- adding TODO
- adding TODO of CI
- update TODO
- update TODO
- **README:** adding TODO
- **README:** update
- **README:** change name!
- **gemspec:** write smallest docs

### Feat
- setup `rake notes` ([#9](y/issues/9))
- adding profiling command by ruby-prof ([#7](y/issues/7))
- adding Ruby 2.5.3 support ([#6](y/issues/6))
- update Ruby version to 2.6.0 ([#4](y/issues/4))
- change input/ouput encoding to binary
- WIP: adding binary type
- change default config file name
- upgrade ruby
- adding error handling of config file is not valid yaml format
- adding error handling of config file is not file
- adding error handling of not exist config file
- implement `masking -c` option for specify config file & get rid of 'thor' library
- implement 'Masking.configure'
- introduce pre-commit/rubocop
- introduce sequential number placeholder #{n}
- adding unhappy path of Unknown type
- introduce Boolean type
- introduce Date type
- integrate method type implementation
- implement method types
- define Method types
- introduce method type
- change `target_columns.yml` file path
- implement DataMaskProcessor
- define TargetColumns::Column#method
- rename argument name
- define TargetColumns#columns
- define TargetColumns#tables
- define SQLInsertStatement.sql
- required parent table in Config::TargetColumns::Column
- fix Config::TargetColumns::Table argument as required
- define Config::TargetColumns::Table.columns
- define Config::TargetColumns::Column
- define Config::TargetColumns::Table
- WIP: implement DataMaskProcessor.process method
- define DataMaskProcessor(WIP)
- make comparable in SQLInsertStatement::Value
- define SQLInsertStatement::Builder
- Masking::Config::TargetColumns
- define SQLInsertStatement#values
- define Masking::SQLDataStatement::Value object
- implement SQLDataStatement values parser
- update Ruby from 2.4 to 2.5
- introduce Simplecov for test coverage report
- integrate to Config::TargetColumns
- implement Masking::Config::TargetColumns.config
- define config/target_columns.yml
- change method name & respond with backquote
- **CLI:** make executable!
- **DataLine:** define/load target_columns
- **SQLDumpLine:** fake implementation

### Fix
- remove .rspec from repository ([#14](y/issues/14))
- [skip ci] fix mistake in setup command
- fix particulor pattern of bug
- fix bug, it fails in some case
- work with Scientific notation value
- fix parse error with binary type
- WIP: available with binary string
- fix potentially bug
- fix bug during multiple insert statement with sequential number replace
- fix mistatake
- fix timeout when insert values includes minus (-) value
- fix error with including NULL and empty string
- error occured when insert values includes comma
- explictly load neccesary library
- change sequential number placeholder
- fix time format
- workaround for binary including line
- fix defining class naming
- fix mistake of memoization method

### Perf
- performance tuning according to ruby-prof

### Refactor
- refactoring and remove unneccesary comment
- rename file name from old name into new name (masking.yml)
- extract error message to yaml file
- adding errors class and put all errors there
- extract logic into functional test helper
- get rid of Singleton
- rename attribute name
- use class instead of class name(String)
- add sql_dump_line_fixture helper
- remove dependency TargetColumns::Column object from TargetColumns::Column, spec for more a
- rename from Builder into SQLBuilder
- rename from SQLInsertStatement into InsertStatement
- use original object
- simplify method name from table_name into table
- remove unnecessary fixture
- stubbing
- change require point into top of file
- move decision logic of target_table from SQLInsertStatement into DataMaskProcessor
- define sql_insert_statement_fixture helper
- define spec/fixtures directory and helper for it
- rewrite with rspec test double
- simplize method
- stubing for remove dependncy of another class
- change name appropriately
- change class name appropriately
- refactoring intialize process of test coverage tool
- better parsing SQLDataStatement columns
- apply Dependency Injection
- change name with current class
- making lazy load and remove dependencies from initialize
- change class name

### Refactoring
- implement configurable Config

### Refatoring
- adding value#has_key? method

### Style
- fix for markdownlint ([#11](y/issues/11))
- apply rubocop autofix, `rubocop -a`
- align break line style
- fix breaks, add some comment
- fix rspec naming mistake

### Test
- fix test failure
- adding pending test cases
- fix rspec exit status become 1 though test has passed
- temporary implementation of commandline functional test
- adding lack spec
- adding more configuration in fixture, set test more accuracy
- refactoring test
- add debug library
- add test of Masking::Main
- adding unhappy path test
- fix test

### Reverts
- ci: adding CodeClimate test coverage report

### Pull Requests
- Merge pull request [#3](y/issues/3) from kibitan/with_binary

### BREAKING CHANGE

default config file name has changed from target_columns.yml to masking.yml


[Unreleased]: y/compare/v0.0.2...HEAD
[v0.0.2]: y/compare/v0.0.1...v0.0.2
