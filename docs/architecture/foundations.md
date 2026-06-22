# Foundations

Dokumen ini menjelaskan fondasi abstraksi yang sering muncul pada contoh-contoh FSDA.

&nbsp;

## Purpose

FSDA tidak hanya bergantung pada struktur folder, tetapi juga pada beberapa abstraction dasar yang membantu menjaga alur implementasi tetap konsisten.

Dokumen ini tidak mengunci implementasi final satu package tertentu, tetapi menjelaskan peran abstraction yang umum dipakai.

&nbsp;

## Core Concepts

Abstraction yang sering muncul antara lain:

* `Failure`
* `Exception`
* `Result` atau `AsyncResult`
* `UseCase`
* `Repository Contract`
* `RepositoryExceptionHandler`
* `AppLogger`

&nbsp;

## Failure

`Failure` merepresentasikan kegagalan di sisi domain.

Failure dipakai oleh layer di atas Data sebagai bentuk error yang sudah diterjemahkan ke bahasa bisnis atau boundary yang lebih stabil.

Pada FSDA, failure yang bersifat module-scope diletakkan di:

```text
module/shared/domain/errors/
```

&nbsp;

## Exception

`Exception` merepresentasikan kegagalan teknis pada Data layer.

Exception tidak boleh bocor ke Logic atau UI. Exception harus diterjemahkan terlebih dahulu menjadi Failure.

Pada FSDA, exception yang bersifat module-scope diletakkan di:

```text
module/shared/data/errors/
```

&nbsp;

## Result dan AsyncResult

`Result` atau `AsyncResult` membantu menjaga hasil operasi tetap eksplisit.

Pendekatan ini biasanya digunakan agar keberhasilan dan kegagalan dapat diperlakukan secara konsisten tanpa melemparkan error ke layer atas secara sembarangan.

&nbsp;

## UseCase

`UseCase` menjadi entry point bisnis pada Domain layer.

UseCase biasanya:

* menerima input berupa `Param`
* memanggil `Repository Contract`
* mengembalikan `Result` atau `AsyncResult`

&nbsp;

## Repository Contract

Repository contract berada pada Domain.

Repository contract mendefinisikan operasi bisnis yang dibutuhkan, tanpa mengetahui bagaimana detail implementasinya dilakukan.

&nbsp;

## RepositoryExceptionHandler

Abstraction ini biasanya digunakan pada Data layer untuk membantu menerjemahkan exception teknis menjadi failure yang lebih stabil.

Implementasi konkretnya dapat berbeda, tetapi perannya tetap sama: menjaga alur error translation tetap konsisten.

&nbsp;

## AppLogger

`AppLogger` atau abstraction logging sejenis dipakai untuk mencatat kejadian teknis tanpa mencampurkan detail logging ke setiap flow bisnis secara acak.

Jika logging dibutuhkan lintas banyak boundary, letakkan abstraction-nya pada fondasi yang stabil seperti `app_core` atau package shared yang sesuai.

&nbsp;

## Placement Guidance

Tidak semua abstraction harus diletakkan di tempat yang sama untuk semua project.

Gunakan prinsip berikut:

* abstraction yang lintas sistem dan stabil cocok berada di shared package seperti `app_core`
* abstraction yang hanya relevan di satu module tetap lebih baik berada pada boundary module tersebut
* jangan memindahkan fondasi ke boundary yang lebih tinggi sebelum reuse dan ownership-nya benar-benar jelas