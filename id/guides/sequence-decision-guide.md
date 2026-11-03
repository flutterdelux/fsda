# Panduan Menentukan Sequence dan Slice

Sequence dan slice menjawab dua pertanyaan berbeda:

* **Sequence**: kontrak apa yang mengatur alur Use Case-to-Data?
* **Slice fitur**: komponen mana yang dikelompokkan sebagai unit modular dengan tanggung jawab terkait, dan bagian Logic/UI apa yang diperlukan?

Tentukan sequence dari kontrak Use Case, bukan dari nama slice. Keterkaitan slice dan sequence mengikuti alur fitur, bukan aturan satu-ke-satu.

## Menentukan Tipe Sequence Use Case

Tentukan dua hal dari kontrak Use Case:

1. Flow-nya: `async`, `sync`, atau `stream`?
2. Signature-nya: `void`, `param`, `return`, atau `return + param`?

Gabungan keduanya menentukan satu dari 12 contract Use Case yang dijelaskan pada [Sequence Pattern](../architecture/sequence-pattern.md). Contoh:

* Operasi async tanpa input dan tanpa payload hasil → `VoidUseCase`.
* Operasi async yang menerima input dan tidak mengembalikan payload → `ParamUseCase<P>`.
* Operasi async yang mengembalikan entity tanpa input → `ReturnUseCase<T>`.
* Operasi async yang menerima param dan mengembalikan entity → `ReturnParamUseCase<T, P>`.
* Untuk operasi sync dan stream, gunakan varian contract yang berakhiran `Sync` atau `Stream`.

Pagination, limit tertentu seperti `5`, offline-first, serta transformasi state bukan sequence type tersendiri. Tempatkan perilakunya pada Param/Use Case, Logic, atau Data sesuai ownership-nya. Misalnya, slice `list` dan `recent` dapat memiliki keterkaitan dengan Use Case dan tipe sequence yang sama, tetapi alur masing-masing dapat memberikan parameter berbeda. App mengorkestrasi bagian UI/Logic dan sequence terkait untuk tiap alur.

## Menentukan Logic dan UI Slice

Setelah memahami requirement dan Use Case yang diperlukan, kelompokkan kode berdasarkan tanggung jawab layer:

* Bagian Logic dari slice menyimpan state serta dapat memanggil satu atau beberapa Use Case. Slice form juga dapat memiliki bagian Logic untuk input/validasi lokal tanpa memanggil Use Case.
* Bagian UI dari slice mengelompokkan View dan widget terkait; UI menyajikan data dan mengirim interaksi melalui callback.
* App menggunakan dan mengorkestrasi bagian UI/Logic serta sequence yang berkaitan, termasuk menyampaikan input dan meneruskan aksi.

Folder `logic/update` dan `ui/update` merupakan bagian Logic/UI dari satu slice fitur `update`. Slice fitur `form_update` memiliki tanggung jawab lain dan dapat mendukung alur fitur yang sama.

## Tidak Ada Pemetaan Satu-ke-Satu

Contoh alur update product:

* App mengorkestrasi bagian UI `ui/update` dan bagian Logic `logic/update` serta `logic/form_update`.
* Logic `update` memanggil Use Case upload image dan update product, yang masing-masing memiliki sequence.
* Slice `form_update` mengelola form/state dan dapat tidak memiliki keterkaitan langsung dengan sequence.

Contoh reuse: App menggunakan dan mengorkestrasi slice `list` dan `recent` melalui bagian UI `ui/list` dan `ui/recent`, serta bagian Logic yang masing-masing berkaitan dengan Use Case/sequence yang sama. Alur `recent` dapat memberi limit `5`, sedangkan alur `list` mengirim parameter pagination.

Sebut keseluruhan requirement tersebut sebagai **alur fitur** (*feature flow*) bila perlu merujuk komposisinya. Ini istilah deskriptif, bukan unit arsitektur baru atau struktur folder wajib.