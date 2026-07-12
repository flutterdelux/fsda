# infra_logging

Infrastructure package implementing `AppLogger`.

&nbsp;

## Purpose

Connect logging contract from `app_core` to `logging` package.

&nbsp;

## Implements

- `AppLogger`

&nbsp;

## Dependencies

- app_core
- logging

&nbsp;

## Responsibilities

- info
- warning
- error

&nbsp;

## Notes

All business code should only know `AppLogger`.

Logger implementation can be replaced without changing business layer.
