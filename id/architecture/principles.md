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

## 2. Feature-Oriented Design

Setiap module terdiri dari satu atau lebih feature.

Feature menjadi batas fungsional yang jelas di dalam suatu business domain.

Contoh pada Task Module:

* Task Feature
* Task Category Feature
* Task Milestone Feature

Feature tidak dibagi berdasarkan layer secara global.

Feature menjadi pusat organisasi kode.

## 3. Sequence-Driven Development

Sequence menstandarkan jalur implementasi dari Use Case ke kontrak Repository dan implementasi Data. Jenisnya mengikuti signature Use Case: tiga flow (async, sync, stream), masing-masing dengan empat bentuk (void, param, return, return + param), sehingga terdapat 12 tipe sequence.

Sequence berkaitan dengan kontrak Use Case dan alur Domain-to-Data, bukan dengan UI. Bagian Logic dari slice dapat memanggil satu atau beberapa Use Case; sebuah slice juga dapat mengelola state lokal tanpa Use Case. App mengorkestrasi bagian UI/Logic dengan sequence yang relevan untuk menjalankan alur fitur. Detail tipe dan kontraknya dijelaskan di [Sequence Pattern](sequence-pattern.md).

Dengan pendekatan ini seluruh implementasi menjadi:

* predictable
* konsisten
* mudah dipelajari
* mudah diautomasi

## 4. Slice Fitur dan Tanggung Jawab

Slice fitur adalah unit modular di dalam feature yang mengelompokkan komponen dengan tanggung jawab terkait. Slice dapat memiliki bagian implementasi pada `logic/<slice>`, `ui/<slice>`, atau keduanya. Folder `logic/update` dan `ui/update` adalah dua bagian layer dari slice `update`. UI mengekspos interaksi melalui callback; App yang menghubungkannya dengan Logic.

Satu slice perlu memiliki fokus yang jelas. Bagian Logic dapat memanggil beberapa Use Case/sequence atau tidak memanggil Use Case sama sekali. Beberapa slice dapat berkaitan dengan Use Case/sequence yang sama, dan satu alur fitur dapat menghubungkan beberapa slice dengan beberapa sequence.

Contoh feature slice:

* create
* update
* delete
* list
* detail
* status
* mark_all_read

Setiap slice harus memiliki tanggung jawab yang jelas dan dapat dipahami secara mandiri. Nama slice mengelompokkan tanggung jawab feature; sequence menyatakan kontrak aliran Use Case-to-data dan tidak ditentukan oleh nama slice.

Dalam struktur FSDA, satu Module dapat memiliki banyak Feature, satu Feature dapat mendukung banyak alur fitur, dan satu alur fitur dapat melibatkan beberapa slice dan/atau sequence. App menggunakan dan mengorkestrasi komponen-komponen yang berkaitan agar alur fitur berjalan.

## 5. Aliran Data Eksplisit

Aliran data harus selalu terlihat dan dapat ditelusuri.

Data bergerak secara eksplisit melalui layer. Pada runtime, App mengorkestrasi komunikasi UI dan Logic; UI menyediakan callback untuk interaksi dan menerima data/state untuk ditampilkan, bukan memanggil Logic secara langsung.

```
User → UI part (callback) → App (composition/orchestration)
			   ├── provides data/state to UI
			   └── dispatches actions/input to Logic part(s)
				      ↓ calls related Use Case(s)
			      Sequence(s): Domain contract → Data implementation
```                  

Data mengimplementasikan kontrak yang didefinisikan Domain, sehingga arah dependency struktural Data tetap mengarah ke Domain.

Tidak diperbolehkan membuat alur tersembunyi yang sulit dipahami.

Developer harus dapat mengikuti perjalanan data dari UI sampai sumber data dengan mudah.

## 6. Dependency Inward

Ketergantungan selalu mengarah ke dalam.

Layer yang lebih luar boleh mengetahui layer yang lebih dalam.

Layer yang lebih dalam tidak boleh mengetahui layer yang lebih luar.


```
(Dalam)
Domain

↑
Logic, UI & Data
(Luar)
```

Atau dapat digambarkan sebagai struktur composition di App:
```
App (Composition Root)
 ├── UI
 ├── Logic
 ├── Domain
 └── Data

UI ──────┐
Logic ───┼──► Domain
Data ────┘
```

Domain menjadi pusat bisnis yang independen terhadap implementasi teknis.

## 7. Shared by Boundary

Komponen yang digunakan bersama harus ditempatkan pada boundary terdekat yang membutuhkannya.

Shared bukan tempat penyimpanan kode umum tanpa batas.

Setiap shared component harus memiliki cakupan penggunaan yang jelas.

Shared Placement Guidelines:

* Digunakan oleh beberapa slice dalam satu feature → letakkan pada shared yang berada dalam boundary feature tersebut.
* Digunakan oleh beberapa feature dalam satu module → letakkan pada module shared.
* Digunakan oleh seluruh aplikasi → letakkan pada app atau package yang sesuai.
* Komponen tidak harus dipindahkan ke boundary yang lebih tinggi hanya karena diakses oleh boundary yang lebih tinggi. Ownership tetap mengikuti boundary penggunaan utamanya.

## 8. Consistency Over Preference

Konsistensi lebih penting daripada preferensi pribadi.

Jika suatu pola sudah dipilih, seluruh codebase harus mengikuti pola tersebut.

Developer tidak boleh membuat variasi baru hanya karena lebih menyukai gaya tertentu.

Codebase yang konsisten lebih mudah dipelajari dan dipelihara dibanding codebase yang memiliki banyak variasi.

## 9. Discoverability First

Struktur kode harus memudahkan developer menemukan sesuatu tanpa perlu mencari terlalu jauh.

Developer harus dapat menjawab pertanyaan berikut dengan cepat:

* Di mana feature ini berada?
* Di mana use case ini berada?
* Di mana state ini berada?
* Di mana widget ini berada?

Navigasi kode harus lebih diutamakan dibanding optimasi struktur yang terlalu kompleks.

## 10. Convention Over Configuration

Keputusan yang berulang harus diselesaikan melalui convention.

Developer tidak perlu terus-menerus memikirkan:

* nama folder
* nama file
* lokasi class
* lokasi state
* lokasi widget

Convention yang jelas mengurangi diskusi yang berulang dan mempercepat pengembangan.

## 11. Scalable by Default

Struktur harus tetap nyaman digunakan ketika project berkembang.

Struktur yang baik harus tetap dapat digunakan saat aplikasi memiliki:

* puluhan module
* ratusan feature
* ribuan file

Keputusan arsitektur harus dapat diterapkan pada berbagai skala aplikasi, sehingga ketika project berkembang maupun menyusut, struktur dan prinsip arsitektur tetap konsisten.

## 12. Automation Friendly

Arsitektur harus dapat dipahami oleh manusia maupun tooling.

Convention yang konsisten memungkinkan:

* code generation
* scaffolding
* linting
* validation
* automation

Semakin sedikit pengecualian dalam struktur, semakin mudah arsitektur diotomatisasi.
