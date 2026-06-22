# app_infrastructure

Package fondasi untuk implementasi teknis bersama yang kecil, sering dipakai ulang, dan belum perlu dipecah menjadi package teknologi yang lebih spesifik.

&nbsp;

## Status

`app_infrastructure` saat ini masih dalam tahap pengembangan dan belum dipatok final bentuknya.

Ada dua arah yang sama-sama valid:

* tetap mempertahankan `app_infrastructure` sebagai package gabungan untuk implementasi kecil yang sering dipakai bersama
* memecahnya menjadi package yang lebih spesifik seperti `infra_dio`, `infra_logger`, `infra_supabase`, dan lainnya ketika boundary teknologinya sudah jelas

&nbsp;

## Purpose

Selama boundary teknologinya belum perlu dipisahkan, `app_infrastructure` bisa menjadi tempat yang pragmatis untuk mengumpulkan adapter atau helper teknis yang reusable lintas App dan Module.

&nbsp;

## Typical Responsibilities

Contoh isi yang mungkin cocok berada di `app_infrastructure`:

* adapter teknis kecil yang dipakai berulang
* helper integrasi teknologi yang belum layak menjadi package terpisah
* contract-to-implementation bridge yang bersifat infrastructural dan reusable
* konfigurasi atau wrapper kecil yang dipakai lintas aplikasi

&nbsp;

## Split Criteria

Pertimbangkan memecah `app_infrastructure` menjadi package terpisah jika:

* satu concern teknologi tumbuh besar dan punya lifecycle sendiri
* dependency tree-nya mulai berat atau spesifik
* package itu sudah cukup jelas ownership dan reuse surface-nya
* tim ingin mengontrol versioning atau boundary dependency dengan lebih tegas

&nbsp;

## Not For

`app_infrastructure` bukan tempat untuk:

* business feature
* repository implementation yang hanya milik satu feature tertentu
* widget UI
* contract domain inti yang seharusnya tetap berada di `app_core` atau module boundary

&nbsp;

## Dependency Position

Posisikan `app_infrastructure` sebagai shared technical layer, bukan business boundary.

Jika suatu implementasi ternyata hanya relevan untuk satu feature atau satu module, lebih baik tetap berada di boundary module tersebut daripada dipindahkan terlalu cepat ke package shared.