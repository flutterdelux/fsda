# infra_dio

Infrastructure package implementing `ApiClient` contract using Dio.

&nbsp;

## Purpose

This package provides a full HTTP client implementation with timeout, streaming, response mapping, and exception mapping.

All Dio dependency is isolated in this package.

&nbsp;

## Implements

- `ApiClient`

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

DioException is translated into:

- timeout
- network
- unauthenticated
- service unavailable
- server error

using `CoreException`.

&nbsp;

## Notes

Business layer should never know Dio.

Business depends only on `ApiClient`.
