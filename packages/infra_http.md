# infra_http

Infrastructure package yang mengimplementasikan `ApiClient` menggunakan package `http`.

&nbsp;

## Purpose

Package ini menyediakan implementasi HTTP client yang ringan, sederhana, dan mudah digunakan.

&nbsp;

## Implements

- ApiClient

&nbsp;

## Dependencies

- app_core
- http

&nbsp;

## Responsibilities

- REST request
- SSE stream
- request timeout
- response mapping

&nbsp;

## Notes

Tidak menyediakan interceptor maupun fitur advanced seperti Dio.

Cocok untuk project sederhana.