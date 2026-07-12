# infra_sqflite

Infrastructure package yang mengimplementasikan `DatabaseClient`.

&nbsp;

## Purpose

Memberikan implementasi database lokal menggunakan SQLite.

&nbsp;

## Implements

- DatabaseClient

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

Business layer hanya mengenal `DatabaseClient`.

Seluruh dependency terhadap SQLite berada di package ini.