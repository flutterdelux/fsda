# Anti-Patterns

Dokumen ini merangkum pola yang sebaiknya dihindari saat menggunakan FSDA.


## Purpose

Anti-pattern membantu menjaga arsitektur tetap konsisten dengan menunjukkan bentuk-bentuk implementasi yang tampak praktis di awal, tetapi biasanya menimbulkan drift di kemudian hari.


## Common Anti-Patterns

Hindari pola berikut:

* mulai implementasi dari folder sebelum memahami alur fitur dan tanggung jawab tiap layer
* menaruh business orchestration di UI
* membiarkan DTO atau response bocor ke Logic atau UI
* mengakses repository implementation langsung dari layer yang tidak semestinya
* memindahkan resource ke shared terlalu cepat tanpa ownership yang jelas
* membuat variasi naming sendiri di luar convention
* menggabungkan beberapa tanggung jawab yang tidak berkaitan ke dalam satu slice fitur
* membiarkan circular dependence antar feature


## Folder First vs Sequence First

Anti-pattern ini tidak berarti folder tidak penting.

Workspace, module, dan feature tetap membutuhkan struktur folder yang jelas. Masalahnya muncul ketika implementasi dimulai dari menebak folder, file, dan class, sebelum jelas slice apa yang sedang dikerjakan dan sequence apa yang dipakai.

Contoh yang keliru:

* requirement baru datang: `delete wallet`
* developer langsung membuat folder `data/`, `domain/`, `logic/`, `ui/`, beberapa file request, response, cubit, widget, dan repository
* setelah itu baru mencoba menebak flow-nya

Masalah dari pendekatan ini:

* struktur mudah melebar tanpa alasan yang jelas
* implementasi dan test mudah melenceng dari aturan layer atau kontrak sequence
* naming dan dependency jadi mudah drift

Pendekatan yang benar:

* mulai dari requirement
* tentukan alur fitur dan Use Case yang diperlukan
* tetapkan sequence dari kontrak Use Case
* tentukan slice fitur serta bagian Logic/UI yang terkait
* baru turunkan ke folder, file, class, dependency, dan flow implementasi

Dengan kata lain, folder mengikuti batas layer dan slice; sequence ditentukan oleh kontrak Use Case. App mengorkestrasi bagian-bagian yang terkait.


## App vs Module Confusion

Hindari mencampur composition concern milik App dengan implementation concern milik Module.

Contoh yang perlu dihindari:

* menaruh page composition ke boundary yang salah
* menaruh route aggregation di Module package
* menaruh dependency injection App ke boundary feature


## Shared Misuse

`shared/` bukan tempat pembuangan untuk resource yang belum jelas posisinya.

Sebelum memindahkan sesuatu ke shared, pastikan:

* reuse-nya nyata
* ownership-nya jelas
* boundary terdekatnya memang sudah tidak cukup


## Sequence Misuse

Jangan memaksa satu slice mengikuti pola yang tidak sesuai hanya karena ingin meniru implementasi lain.

Jika sequence terasa tidak pas, evaluasi kembali requirement slice-nya lebih dulu.