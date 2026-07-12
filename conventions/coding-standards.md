# Coding Standards

Dokumen ini menjelaskan pedoman coding dasar pada FSDA.

&nbsp;

## Purpose

Coding standards digunakan untuk menjaga konsistensi implementasi, memudahkan review, dan mengurangi variasi yang tidak perlu di dalam codebase.

&nbsp;

## General Principles

Gunakan pedoman berikut sebagai baseline:

* utamakan perubahan kecil dan terfokus
* ikuti boundary arsitektur yang sudah ditetapkan
* utamakan kejelasan dibanding cleverness
* pertahankan naming sesuai convention yang berlaku
* hindari side effect tersembunyi

&nbsp;

## Layer Discipline

Setiap layer harus tetap berada pada tanggung jawabnya:

* Domain berisi contract dan business rule yang stabil
* Data berisi detail implementasi teknis
* Logic berisi state management dan alur interaksi
* UI berisi presentation
* App berisi composition

Jika sebuah perubahan membuat tanggung jawab layer menjadi kabur, biasanya struktur implementasinya perlu ditinjau ulang.

&nbsp;

## Code Style

Gunakan gaya penulisan yang konsisten:

* nama harus jelas dan deskriptif
* hindari singkatan yang tidak umum
* hindari one-letter variable kecuali untuk konteks yang sangat pendek dan jelas
* komentar hanya ditambahkan jika benar-benar membantu menjelaskan keputusan atau alur yang tidak langsung terbaca
* hindari file atau class yang memegang terlalu banyak tanggung jawab

&nbsp;

## Flow Clarity

Alur data harus mudah ditelusuri dari UI ke sumber data.

Pertahankan aturan berikut:

* jangan biarkan DTO bocor ke Logic atau UI
* jangan biarkan repository implementation bocor ke Domain
* jangan taruh business orchestration di UI
* jangan taruh composition concern di Module

&nbsp;

## Shared Placement

Jangan memindahkan sesuatu ke shared terlalu cepat.

Naikkan boundary hanya jika:

* benar-benar dipakai bersama
* ownership-nya jelas
* reuse-nya stabil

Jika resource masih spesifik untuk satu feature atau satu module, simpan tetap pada boundary terdekatnya.

&nbsp;

## Testing Awareness

Saat menulis kode, pikirkan juga bentuk test-nya.

Implementasi yang baik biasanya:

* punya dependency yang jelas
* tidak terlalu banyak state tersembunyi
* mudah diuji per layer
* tidak membutuhkan setup teknis yang berlebihan untuk memverifikasi behavior inti