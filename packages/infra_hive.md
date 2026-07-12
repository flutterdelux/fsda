# infra_hive

Infrastructure package yang mengimplementasikan `LocalStorage` menggunakan Hive.

&nbsp;

## Purpose

Alternatif LocalStorage dengan performa tinggi dan dukungan object yang lebih baik dibanding SharedPreferences.

&nbsp;

## Implements

- LocalStorage

&nbsp;

## Dependencies

- app_core
- hive

&nbsp;

## Responsibilities

- read
- write
- delete
- clear

&nbsp;

## Notes

Saat ini hanya mendukung primitive value sesuai contract `LocalStorage`.