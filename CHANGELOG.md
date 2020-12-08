# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Security

- chore(deps): bump kramdown from 2.1.0 to 2.3.0 [#54](https://github.com/kibitan/masking/pull/54)

## [v1.0.1] - 2019-12-31

### Added

- add Ruby 2.7 support [#53](https://github.com/kibitan/masking/pull/53)

### Changed

- refactoring [#48](https://github.com/kibitan/masking/pull/48) [#49](https://github.com/kibitan/masking/pull/49)  [#50](https://github.com/kibitan/masking/pull/50)

## [v1.0.0] - 2019-11-10

### Added

- `masking --version` option [#31](https://github.com/kibitan/masking/pull/31)
- add friendly parse error message [#26](https://github.com/kibitan/masking/pull/26) [#38](https://github.com/kibitan/masking/pull/38)
- Setup Docker and Acceptance test [#32](https://github.com/kibitan/masking/pull/32) [#36](https://github.com/kibitan/masking/pull/36)
- setup acceptance test for ci [#34](https://github.com/kibitan/masking/pull/34)
- add Ruby2.7(preview) [#35](https://github.com/kibitan/masking/pull/35)
- setup ci for changelog checker [#41](https://github.com/kibitan/masking/pull/41)

## [v0.0.3] - 2019-07-07

### Changed

- Update Document [#25](https://github.com/kibitan/masking/pull/25)
- Performance Tuning [#28](https://github.com/kibitan/masking/pull/28) special thanks [@isaiah](https://github.com/isaiah)

```
$ bin/benchmark.rb
(v0.0.2)
       user     system      total        real
   2.197755   0.239222   2.436977 (  2.460922)

(v0.0.3)
       user     system      total        real
   1.136621   0.198741   1.335362 (  1.355499)
```

## [v0.0.2] - 2019-01-06

### Fix

- fix bug about NoMethodError on some environment

## [v0.0.1] - 2019-01-05

Initial release version. 🎉

[Unreleased]: https://github.com/kibitan/masking/compare/v1.0.1...HEAD
[v1.0.1]: https://github.com/kibitan/masking/compare/v1.0.0...v1.0.1
[v1.0.0]: https://github.com/kibitan/masking/compare/v0.0.3...v1.0.0
[v0.0.3]: https://github.com/kibitan/masking/compare/v0.0.2...v0.0.3
[v0.0.2]: https://github.com/kibitan/masking/compare/v0.0.1...v0.0.2
[v0.0.1]: https://github.com/kibitan/masking/tree/v0.0.1
