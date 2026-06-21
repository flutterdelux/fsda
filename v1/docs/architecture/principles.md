# FSDA Principles

## 1. Modular First

Aplikasi dibangun dari kumpulan module yang independen.

Setiap module merepresentasikan satu business domain yang dapat dikembangkan, diuji, dipelihara, dan digunakan kembali secara terpisah.

Module menjadi unit organisasi utama dalam codebase.

Contoh:

* Inbox Module
* Task Module
* Finance Module
* Product Module

App tidak berisi business logic.

App hanya mengkomposisikan module yang dibutuhkan.

&nbsp;

## 2. Feature-Oriented Design

Setiap module terdiri dari satu atau lebih feature.

Feature menjadi batas fungsional yang jelas di dalam suatu business domain.

Contoh pada Task Module:

* Task Feature
* Task Category Feature
* Task Milestone Feature

Feature tidak dibagi berdasarkan layer secara global.

Feature menjadi pusat organisasi kode.

&nbsp;

## 3. Sequence-Driven Development

Implementasi feature slice harus mengikuti sequence pattern yang telah didefinisikan.

Sequence mendefinisikan pola aliran data, struktur implementasi, serta bentuk interaksi antar layer.

Contoh sequence:

* Mutation
* Mutation + Param
* Mutation + Return
* Mutation + Return + Param
* Retrieval
* Retrieval + Param
* Retrieval + Pagination
* Retrieval + Stream
* Retrieval + Stream + Param
* Retrieval + Cache
* Retrieval + Local First

Setiap feature slice harus dapat dipetakan ke tepat satu sequence yang jelas.

Contoh:

```
mark_all_read  -> Mutation

delete         -> Mutation + Param

create         -> Mutation + Return + Param

detail         -> Retrieval + Param

list           -> Retrieval + Pagination
```

Dengan pendekatan ini seluruh implementasi menjadi:

* predictable
* konsisten
* mudah dipelajari
* mudah diautomasi

&nbsp;

## 4. Single Responsibility per Feature Slice

Setiap feature slice hanya merepresentasikan satu tujuan bisnis yang spesifik.

Feature slice tidak boleh menggabungkan beberapa tujuan yang berbeda ke dalam satu implementasi.

Contoh feature slice:

* create
* update
* delete
* list
* detail
* status
* mark_all_read

Setiap feature slice harus memiliki tanggung jawab yang jelas, dapat dipahami secara mandiri, dan dapat dipetakan ke satu sequence yang telah didefinisikan.

Feature slice menjadi unit terkecil pengembangan dalam FSDA.

&nbsp;

## 5. Explicit Data Flow

Aliran data harus selalu terlihat dan dapat ditelusuri.

Data bergerak secara eksplisit melalui layer.

UI → Logic → Domain → Data

Tidak diperbolehkan membuat alur tersembunyi yang sulit dipahami.

Developer harus dapat mengikuti perjalanan data dari UI sampai sumber data dengan mudah.

&nbsp;

## 6. Dependency Inward

Ketergantungan selalu mengarah ke dalam.

Layer yang lebih luar boleh mengetahui layer yang lebih dalam.

Layer yang lebih dalam tidak boleh mengetahui layer yang lebih luar.

```
UI
 ↓
Logic
 ↓
Domain
 ↑
Data
```

atau secara dependency:

```
(Dalam)
Domain

↑
Logic

↑
UI

↑
Data
(Luar)
```

Domain menjadi pusat bisnis yang independen terhadap implementasi teknis.

&nbsp;

## 7. Shared by Boundary

Komponen yang digunakan bersama harus ditempatkan pada boundary terdekat yang membutuhkannya.

Shared bukan tempat penyimpanan kode umum tanpa batas.

Setiap shared component harus memiliki cakupan penggunaan yang jelas.

Shared Placement Guidelines:

* Digunakan oleh beberapa slice dalam satu feature → letakkan pada shared yang berada dalam boundary feature tersebut.
* Digunakan oleh beberapa feature dalam satu module → letakkan pada module shared.
* Digunakan oleh seluruh aplikasi → letakkan pada app atau package yang sesuai.
* Komponen tidak harus dipindahkan ke boundary yang lebih tinggi hanya karena diakses oleh boundary yang lebih tinggi. Ownership tetap mengikuti boundary penggunaan utamanya.

Shared mengikuti boundary penggunaan aktual, bukan perkiraan penggunaan di masa depan.

&nbsp;

## 8. Consistency Over Preference

Konsistensi lebih penting daripada preferensi pribadi.

Jika suatu pola sudah dipilih, seluruh codebase harus mengikuti pola tersebut.

Developer tidak boleh membuat variasi baru hanya karena lebih menyukai gaya tertentu.

Codebase yang konsisten lebih mudah dipelajari dan dipelihara dibanding codebase yang memiliki banyak variasi.

&nbsp;

## 9. Discoverability First

Struktur kode harus memudahkan developer menemukan sesuatu tanpa perlu mencari terlalu jauh.

Developer harus dapat menjawab pertanyaan berikut dengan cepat:

* Di mana feature ini berada?
* Di mana use case ini berada?
* Di mana state ini berada?
* Di mana widget ini berada?

Navigasi kode harus lebih diutamakan dibanding optimasi struktur yang terlalu kompleks.

&nbsp;

## 10. Convention Over Configuration

Keputusan yang berulang harus diselesaikan melalui convention.

Developer tidak perlu terus-menerus memikirkan:

* nama folder
* nama file
* lokasi class
* lokasi state
* lokasi widget

Convention yang jelas mengurangi diskusi yang berulang dan mempercepat pengembangan.

&nbsp;

## 11. Scalable by Default

Struktur harus tetap nyaman digunakan ketika project berkembang.

Struktur yang baik harus tetap dapat digunakan saat aplikasi memiliki:

* puluhan module
* ratusan feature
* ribuan file

Keputusan arsitektur harus dapat diterapkan pada berbagai skala aplikasi, sehingga ketika project berkembang maupun menyusut, struktur dan prinsip arsitektur tetap konsisten.

&nbsp;

## 12. Automation Friendly

Arsitektur harus dapat dipahami oleh manusia maupun tooling.

Convention yang konsisten memungkinkan:

* code generation
* scaffolding
* linting
* validation
* automation

Semakin sedikit pengecualian dalam struktur, semakin mudah arsitektur diotomatisasi.
