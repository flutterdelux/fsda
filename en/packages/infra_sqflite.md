# infra_sqflite

Infrastructure package implementing `DatabaseClient`.

&nbsp;

## Purpose

Provide local database implementation using SQLite.

&nbsp;

## Implements

- `DatabaseClient`

&nbsp;

## Dependencies

- app_core
- sqflite

&nbsp;

## Responsibilities

- insert
- insertMany
- update
- delete
- findById
- findAll
- clear

&nbsp;

## Notes

Business layer should only know `DatabaseClient`.

All SQLite dependency is isolated in this package.
