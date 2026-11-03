# Sequence Pattern

## Apa itu Sequence

Sequence adalah pola aliran dan kontrak implementasi yang dimulai dari Use Case, melewati kontrak Repository pada Domain, lalu dijalankan oleh implementasi Repository/Data hingga data source. Sequence menjelaskan bagaimana satu operasi Domain meminta atau mengubah data.

Sequence tidak mencakup UI slice atau Logic slice. Use Case dan sequence terkait dengan bagian Logic yang memanggilnya, sedangkan UI menyajikan data dan mengirim interaksi melalui callback. App mengorkestrasi bagian-bagian UI dan Logic tersebut bersama sequence yang diperlukan oleh alur fitur.

## 12 Tipe Sequence

Jenis sequence ditentukan oleh dua dimensi:

1. **Flow**: async, sync, atau stream.
2. **Signature Use Case**: tanpa input dan tanpa nilai hasil (`void`), input saja (`param`), nilai hasil saja (`return`), atau input dan nilai hasil (`return + param`).

Kombinasinya menghasilkan 12 tipe berikut. Nama contract di tabel mengikuti `app_core`.

| Flow | Signature | Use Case contract | Bentuk hasil `call` |
| --- | --- | --- | --- |
| Async | Void | `VoidUseCase` | `AsyncResult<void> call()` |
| Async | Param | `ParamUseCase<P>` | `AsyncResult<void> call(P param)` |
| Async | Return | `ReturnUseCase<T>` | `AsyncResult<T> call()` |
| Async | Return + Param | `ReturnParamUseCase<T, P>` | `AsyncResult<T> call(P param)` |
| Sync | Void | `VoidSyncUseCase` | `Result<void> call()` |
| Sync | Param | `ParamSyncUseCase<P>` | `Result<void> call(P param)` |
| Sync | Return | `ReturnSyncUseCase<T>` | `Result<T> call()` |
| Sync | Return + Param | `ReturnParamSyncUseCase<T, P>` | `Result<T> call(P param)` |
| Stream | Void | `VoidStreamUseCase` | `Stream<Result<void>> call()` |
| Stream | Param | `ParamStreamUseCase<P>` | `Stream<Result<void>> call(P param)` |
| Stream | Return | `ReturnStreamUseCase<T>` | `Stream<Result<T>> call()` |
| Stream | Return + Param | `ReturnParamStreamUseCase<T, P>` | `Stream<Result<T>> call(P param)` |

`void` berarti operasi tidak mengembalikan payload domain; `param` adalah input Use Case; `return` adalah payload hasil. Async tetap membungkus operasi dalam `AsyncResult`, sync memakai `Result`, dan stream mengirim rangkaian `Result`.

## Batas Sequence

```text
App mengorkestrasi bagian UI/Logic yang terkait dengan alur fitur
	↓ memicu aksi Logic
Logic slice (opsional)
	↓ memanggil Use Case yang berkaitan
Use Case [awal sequence]
	↓
Repository contract (Domain)
	⇣ diimplementasikan oleh
Repository implementation (Data)
	↓
Data source / external system
```

Setiap Use Case memiliki satu tipe sequence berdasarkan flow dan signature-nya. Banyak Use Case dapat memiliki tipe sequence yang sama. Sequence dapat berkaitan dengan beberapa alur fitur; App menentukan bagian Logic/UI yang dikomposisikan pada setiap alur.

## Sequence dan Slice Tidak Berpasangan Satu-ke-Satu

Slice adalah unit modular di dalam feature, dengan bagian implementasi pada Logic dan/atau UI, seperti `logic/update`, `logic/form_update`, atau `ui/update`. Sequence adalah pola Use Case-to-data. Keduanya tidak berhubungan satu-ke-satu:

* bagian Logic dari slice `update` dapat memanggil Use Case upload image dan update product, yang masing-masing memiliki sequence;
* slice `form_update` dapat mengelola form/state tanpa keterkaitan langsung dengan sequence;
* beberapa slice dapat berkaitan dengan Use Case atau tipe sequence yang sama;
* satu alur fitur dapat melibatkan beberapa slice dan sequence yang dikomposisikan oleh App.

Gunakan **alur fitur** (*feature flow*) sebagai sebutan deskriptif untuk keseluruhan proses requirement. Ini bukan folder atau abstraksi tambahan yang diwajibkan.


