# infra_dio

Infrastructure package yang mengimplementasikan contract `ApiClient` menggunakan Dio.

&nbsp;

## Purpose

Package ini menyediakan implementasi HTTP client yang lengkap dengan timeout, streaming, response mapping, dan exception mapping.

Seluruh dependency terhadap Dio diisolasi di package ini.

&nbsp;

## Implements

- ApiClient

&nbsp;

## Dependencies

- app_core
- dio

&nbsp;

## Responsibilities

- GET
- POST
- PUT
- PATCH
- DELETE
- Server Sent Events (SSE)
- timeout configuration
- header configuration
- response mapping
- exception mapping

&nbsp;

## Exception Mapping

DioException dikonversi menjadi:

- timeout
- network
- unauthenticated
- service unavailable
- server error

menggunakan `CoreException`.

&nbsp;

## Notes

Business layer tidak pernah mengenal Dio.

Business hanya bergantung pada `ApiClient`.