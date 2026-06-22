# app_ui

Package fondasi untuk design system, visual primitives, dan komponen UI bersama yang digunakan lintas aplikasi.

&nbsp;

## Purpose

`app_ui` membantu menjaga konsistensi visual dan interaction pattern tanpa memaksa feature menyimpan komponen presentasi umum di dalam boundary bisnis.

&nbsp;

## Typical Responsibilities

Contoh isi yang cocok berada di `app_ui`:

* theme, color tokens, typography, spacing tokens
* shared widget atau visual primitive lintas module
* feedback component umum seperti loading, empty state, atau error presentation yang reusable
* helper UI yang menjadi bagian dari design system

&nbsp;

## Good Candidates

Letakkan sesuatu di `app_ui` jika resource tersebut:

* reusable lintas banyak module atau app
* tidak membawa ownership feature bisnis tertentu
* berfokus pada presentation, styling, atau interaction pattern umum

&nbsp;

## Not For

`app_ui` bukan tempat untuk:

* page composition milik App
* widget yang sangat spesifik ke satu feature bisnis
* business orchestration
* datasource, repository, atau use case

&nbsp;

## Dependency Position

`app_ui` berada pada shared UI foundation.

Module UI boleh bergantung ke `app_ui` untuk menjaga konsistensi komponen presentasi tanpa menarik masuk business dependency yang tidak perlu.

Dalam baseline Flutter saat ini, module umumnya bergantung pada `app_ui` untuk kebutuhan standard UI lintas app maupun module.