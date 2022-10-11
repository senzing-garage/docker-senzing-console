# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

-

## [1.2.3] - 2022-10-11

### Changed in 1.2.3

- In `Dockerfile`, updated FROM instruction to `senzing/senzingapi-tools:3.3.1`
- In `requirements.txt`, updated:
  - setuptools==65.4.1
  - VisiData==2.10.2

## [1.2.2] - 2022-09-28

### Changed in 1.2.2

- In `Dockerfile`, updated FROM instruction to `senzing/senzingapi-tools:3.3.0`
- In `requirements.txt`, updated:
  - setuptools==65.4.0

## [1.2.1] - 2022-09-23

### Changed in 1.2.1

- Migrated from pip `pyodbc` to apt `python3-pyodbc`
- Trimmed `requirements.txt`

## [1.2.0] - 2022-08-26

### Changed in 1.2.0

- removed psutils and duplicate packages from requirements.txt
- update to use `senzingapi-tools` base image

## [1.1.2] - 2022-05-02

### Changed in 1.1.2

- In Dockerfile. `ENV LC_ALL=C` to `ENV LC_ALL=C.UTF-8`

## [1.1.1] - 2022-04-19

### Changed in 1.1.1

- Updated python dependencies in `requirements.txt`

## [1.1.0] - 2022-04-13

### Added in 1.1.0

- Support for migration from Senzing V2 to V3, `/app/migrate-senzing-2-to-3.sh`

## [1.0.8] - 2022-04-01

### Changed in 1.0.8

- Update to Debian 11.3

## [1.0.7] - 2022-03-21

### Changed in 1.0.7

- Support for `libcrypto` and `libssl`

## [1.0.6] - 2022-02-17

### Changed in 1.0.6

- Created Dockerfile-slim

## [1.0.5] - 2022-02-09

### Changed in 1.0.5

- Update to Debian 11.2
- Build fio 3.27 in stage
- slimmed down tools pre-installed

## [1.0.4] - 2021-10-11

### Changed in 1.0.4

- Update to senzing/senzing-base:1.6.2

## [1.0.3] - 2021-07-15

### Changed in 1.0.3

- Update to senzing/senzing-base:1.6.1

## [1.0.2] - 2021-07-13

### Changed in 1.0.2

- Update to senzing/senzing-base:1.6.0

## [1.0.1] - 2021-03-16

### Changed in 1.0.1

- Update to senzing/senzing-base:1.5.5

## [1.0.0] - 2020-07-22

### Added in 1.0.0

- A copy of [Senzing/docker-senzing-debug](https://github.com/Senzing/docker-senzing-debug) with modifications from "debug" to "console"
