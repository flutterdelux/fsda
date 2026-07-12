# infra_connectivity_plus

Infrastructure package yang mengimplementasikan contract `NetworkInfo` dari `app_core` menggunakan `connectivity_plus`.

&nbsp;

## Purpose

Package ini menyediakan implementasi untuk:

- mengecek apakah device memiliki network interface
- mengecek koneksi Wi-Fi
- melakukan verifikasi akses internet

Contract tetap berada di `app_core`, sedangkan implementasi teknologi berada di package ini.

&nbsp;

## Implements

- `NetworkInfo`

&nbsp;

## Dependencies

- app_core
- connectivity_plus

&nbsp;

## Responsibilities

- membaca status konektivitas perangkat
- mengecek koneksi Wi-Fi
- melakukan internet reachability check

&nbsp;

## Notes

Package ini hanya bertanggung jawab pada informasi konektivitas.

Ia bukan network client dan tidak melakukan request HTTP.