# Sequence Decision Guide

Dokumen ini membantu memilih sequence yang paling sesuai untuk sebuah feature slice.

&nbsp;

## Purpose

Pertanyaan pertama saat memulai implementasi di FSDA bukan lokasi folder, melainkan sequence apa yang paling tepat.

Dokumen ini membantu mempercepat keputusan tersebut.

&nbsp;

## Quick Decision Flow

Gunakan alur berikut:

1. Apakah slice ini mengubah data?
2. Jika ya, maka mulai dari keluarga `Mutation`.
3. Jika tidak, maka mulai dari keluarga `Retrieval`.
4. Apakah slice membutuhkan input?
5. Apakah slice mengembalikan data hasil operasi?
6. Apakah slice membutuhkan pagination, stream, cache, atau local-first behavior?

&nbsp;

## Mutation Family

Gunakan:

* `Mutation` jika tidak membutuhkan param dan tidak mengembalikan data
* `Mutation + Param` jika membutuhkan input
* `Mutation + Return` jika mengembalikan hasil operasi
* `Mutation + Return + Param` jika membutuhkan input dan mengembalikan hasil operasi

Contoh:

* `mark_all_read` → Mutation
* `delete` → Mutation + Param
* `take` → Mutation + Return
* `create` → Mutation + Return + Param

&nbsp;

## Retrieval Family

Gunakan:

* `Retrieval` jika membaca data tanpa input tambahan
* `Retrieval + Param` jika membaca data dengan input
* `Retrieval + Pagination` jika daftar data perlu paging
* `Retrieval + Stream` jika data terus berubah dan harus dipantau
* `Retrieval + Stream + Param` jika stream juga membutuhkan input
* `Retrieval + Cache` jika membaca data dengan mekanisme cache sederhana
* `Retrieval + Local First` jika local source menjadi prioritas awal sebelum remote source

Contoh:

* `popular` → Retrieval
* `detail` → Retrieval + Param
* `list` → Retrieval + Pagination
* `status` → Retrieval + Stream + Param
* `mode` → Retrieval + Cache
* `note list` → Retrieval + Local First

&nbsp;

## Selection Rule

Satu feature slice harus dipetakan ke satu sequence yang paling jelas.

Jika satu slice terasa membutuhkan terlalu banyak sequence sekaligus, biasanya:

* slice-nya terlalu besar
* boundary tanggung jawabnya belum cukup jelas
* atau flow-nya perlu dipisah menjadi beberapa slice