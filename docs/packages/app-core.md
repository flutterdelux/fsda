# app_core

Package fondasi untuk kontrak dan utilitas inti yang stabil dan digunakan lintas aplikasi, module, atau package lain.

&nbsp;

## Purpose

`app_core` menjadi tempat untuk resource paling dasar yang tidak membawa business feature tertentu dan tidak terikat pada implementasi teknologi spesifik.

Tujuannya adalah menyediakan surface yang kecil, stabil, dan aman dijadikan acuan bersama.

&nbsp;

## Typical Responsibilities

Contoh isi yang cocok berada di `app_core`:

* contract dasar seperti `Failure`, `Result`, `AsyncResult`, atau `UseCase`
* abstraction kecil yang dipakai lintas module
* utility inti yang benar-benar technology-agnostic
* extension atau helper yang sangat umum dan tidak membawa ownership feature tertentu

&nbsp;

## Good Candidates

Letakkan sesuatu di `app_core` jika resource tersebut:

* dipakai lintas banyak module atau package
* bersifat stabil dan jarang berubah karena kebutuhan feature tertentu
* tidak mengandung business capability spesifik
* tidak bergantung pada UI atau integrasi teknologi konkret

&nbsp;

## Not For

`app_core` bukan tempat untuk:

* feature bisnis
* widget atau design system
* repository implementation atau datasource
* konfigurasi teknologi konkret seperti Dio, Supabase, Firebase, dan sejenisnya

&nbsp;

## Dependency Position

`app_core` idealnya menjadi salah satu fondasi paling bawah dalam shared packages.

Semakin kecil dan stabil surface `app_core`, semakin aman package ini dijadikan dependency oleh App, Module, maupun shared package lain.

Dalam baseline Flutter saat ini, module umumnya bergantung pada `app_core` untuk mengakses contract dan abstraction yang dipakai bersama lintas app maupun module.