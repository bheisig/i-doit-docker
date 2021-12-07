# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased][]

_tbd_

### Added

-   Add i-doit open/pro, version `1.17.2`

## [0.4.0][] – 2021-10-27

### Added

-   Add i-doit open, versions `1.16`, `1.16.1`, `1.16.2`, `1.16.3`, `1.17`, `1.17.1`
-   Add i-doit pro, versions `1.16`, `1.16.1`, `1.16.2`, `1.16.3`, `1.17`, `1.17.1`

### Changed

-   Bump version of MariaDB; recommended version is `v10.5.x`
-   Upgrade base container image Debian GNU/Linux from 10 `buster` to 11 `bullseye`

### Removed

-   Drop support for i-doit open/pro `1.14` and `1.15` branches
-   Drop support for PHP `7.1`, `7.2`, and `7.3` (end of life)
-   Remove command `./docker.sh test` in favor of `npm test`

## [0.3.0][] – 2020-10-23

### Added

-   Add i-doit open, version `1.15.1`
-   Add i-doit pro, version `1.15.1`
-   Add i-doit open, version `1.15`
-   Add i-doit pro, version `1.15`
-   Add i-doit open, version `1.14.2`

### Fixed

-   `apache` service: Add content from i-doit's `.htaccess` file to Apache's configuration file

### Removed

-   Do not build images for `1.13.x` branch anymore

## [0.2.0][] – 2020-06-02

### Added

-   Add i-doit pro/open, versions `1.13.1`, `1.13.2`, `1.14`, `1.14.1` and `1.14.2`
-   Scan images for vulnerabilities with `./docker.sh scan`
-   Add `./docker.sh fix` to fix file permissions

### Fixed

-   Ensure to remove all remaining docker images while cleaning up

### Removed

-   Do not build images for `1.12.x` branch anymore

## 0.1.0 – 2019-07-24

Initial release

### Added

-   Add i-doit versions `1.12.1`, `1.12.4` and `1.13`
-   Add i-doit editions open and pro
-   Add PHP versions `7.0`, `7.1`, `7.2`, `7.3` and `7.4` (experimental)
-   Add services Apache Web server and PHP-FPM
-   Add examples for docker-compose incl. environment variables, MariaDB and Memcached

[Unreleased]: https://github.com/bheisig/i-doit-docker/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/bheisig/i-doit-docker/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/bheisig/i-doit-docker/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/bheisig/i-doit-docker/compare/v0.1.0...v0.2.0
