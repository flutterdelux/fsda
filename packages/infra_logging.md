# infra_logging

Infrastructure package yang mengimplementasikan `AppLogger`.

&nbsp;

## Purpose

Menghubungkan contract logging di `app_core` dengan package `logging`.

&nbsp;

## Implements

- AppLogger

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

Seluruh business code hanya mengenal `AppLogger`.

Implementasi logger dapat diganti tanpa mengubah business layer.