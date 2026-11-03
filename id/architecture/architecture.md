# Feature Slice Driven Architecture (FSDA)

> Arsitektur Flutter yang pragmatis dan digerakkan oleh aturan, berfokus pada konsistensi, kemudahan pencarian, pemeliharaan, skalabilitas, dan automasi.



## Apa itu Feature Slice Driven Architecture (FSDA)?

FSDA adalah arsitektur Flutter yang dirancang untuk membangun aplikasi yang konsisten, mudah dipahami, mudah dipelihara, dan mudah dikembangkan dalam jangka panjang.

Arsitektur ini menggabungkan berbagai konsep yang telah terbukti efektif dari:

- Clean Architecture
- Domain Driven Design (DDD)
- Feature First Architecture
- Modular Monorepo Architecture
- Layered Architecture
- Package-Based Architecture
- Separation of Concerns
- SOLID Principles
- Dependency Inversion Principle

Namun FSDA tidak dimaksudkan sebagai salinan utuh dari satu filosofi tertentu.

Sebaliknya, FSDA berfokus pada bagaimana membangun struktur proyek yang konsisten, dapat diprediksi, mudah ditemukan, mudah dipahami, dan mudah diautomasi.



## Mengapa FSDA?

Banyak arsitektur menjelaskan:

- Layer apa saja yang harus ada
- Bagaimana dependency mengalir
- Apa tanggung jawab setiap layer

Namun sering kali tidak menjelaskan:

- Di mana file harus diletakkan
- Bagaimana struktur module dibangun
- Bagaimana struktur feature dibangun
- Bagaimana menjaga konsistensi antar developer
- Bagaimana menjaga konsistensi antar project
- Bagaimana mengurangi architectural drift
- Bagaimana membuat struktur yang dapat diautomasi

Akibatnya dua project yang mengaku menggunakan arsitektur yang sama sering kali memiliki struktur yang berbeda secara signifikan.

FSDA hadir untuk mengurangi ambiguitas tersebut melalui aturan implementasi yang eksplisit dan konsisten.



## Ringkasan Struktur

FSDA menggunakan pendekatan Modular Monorepo.

```text
Workspace
├── Apps
├── Modules
└── Packages
```

Setiap layer memiliki tanggung jawab yang jelas dan batasan yang eksplisit.

---

### Workspace

Workspace merupakan root dari seluruh sistem.

Workspace mengelompokkan:

- Apps
- Modules
- Shared Packages

Workspace bukan tempat implementasi business logic.

---

### App

App Layer merupakan composition layer.

Tanggung jawab App Layer:

- Bootstrap application
- Configure external services
- Register dependencies
- Configure routing
- Compose modules
- Configure MaterialApp
- Provide global state

App Layer tidak mengandung business logic domain.

Contoh:

```text
lib/
├── app/
├── core/
└── modules/
```

---

### Module

Module merupakan unit modular utama dalam FSDA.

Module mengelompokkan feature yang masih berada dalam domain bisnis yang sama.

Contoh:

```text
task/
├── task
├── task_category
└── task_milestone
```

Module dapat digunakan oleh satu atau lebih aplikasi.

---

### Feature

Feature merupakan representasi capability bisnis dalam suatu module.

Contoh:

```text
task
task_category
task_milestone
wallet
product
destination
```

Feature menjadi boundary utama implementasi domain.

---

### Feature Slice

Slice fitur adalah unit modular di dalam sebuah feature yang mengelompokkan komponen dengan tanggung jawab terkait. Sebuah slice dapat memiliki bagian Logic di `logic/<slice>`, bagian UI di `ui/<slice>`, atau keduanya. Folder bernama sama pada Logic dan UI merupakan bagian dari satu slice.

Contoh:

```text
features/product/
├── logic/
│   ├── update/
│   └── form_update/
└── ui/
	└── update/
```

Contoh: `logic/update` dan `ui/update` adalah bagian Logic dan UI dari slice `update`. Slice `form_update` memiliki tanggung jawab berbeda dan mendukung alur update; slice ini dapat memiliki bagian Logic saja.

Slice tidak harus memiliki keterkaitan langsung dengan sequence. App sebagai orchestrator memilih dan menghubungkan bagian UI dan Logic yang diperlukan dalam alur fitur. Bagian Logic dari slice `update` dapat memanggil beberapa Use Case yang masing-masing memiliki sequence; slice `form_update` dapat mengelola state/form tanpa memanggil Use Case. Beberapa slice berbeda dapat memiliki keterkaitan dengan Use Case atau sequence yang sama.

Secara konseptual, struktur kebutuhan FSDA dapat dibaca sebagai:

```text
Module 1 ──► banyak Feature
Feature 1 ──► banyak Alur Fitur
Alur Fitur 1 ──► komposisi Slice dan/atau Sequence
```

Alur fitur (*feature flow*) adalah pengelompokan konseptual untuk menjelaskan satu kebutuhan/kemampuan yang berjalan. Ia tidak menambahkan layer atau folder baru. App menggunakan dan mengorkestrasi bagian slice UI/Logic serta sequence yang berkaitan agar alur tersebut dapat berjalan.

---

### Shared Package

Shared Package menyediakan fondasi yang digunakan bersama oleh seluruh sistem.

Contoh:

```text
packages/
├── app_core
├── infra_...
├── app_l10n
└── app_ui
```

Shared Package menyediakan kontrak, utilitas, fondasi UI, dan integrasi teknologi yang dapat digunakan oleh seluruh aplikasi dan module.



## Layer Arsitektur

*(Execution Flow — interaksi runtime)*
```
User
 ↓ event
UI slice (presentasi; mengirim callback)
 ↓ callback / data melalui composition
App (orchestrator)
 ├── mengirim input ke Logic slice
 ├── membaca state Logic dan memberikannya ke UI
 └── memanggil aksi Logic
		↓
	Logic slice(s)
		↓ 0..n Use Case
	Use Case(s) ──► Repository contract (Domain)
					  ⇣ implementasi runtime
				Repository implementation (Data)
					  ↓
				Data source / external system
```

Use Case-to-data flow di atas adalah sequence. UI dan Logic slice berada di luar definisi sequence. Nilai hasil bergerak kembali melalui Use Case dan Logic; App menghubungkan state atau callback tersebut ke UI. UI tidak memanggil Logic secara langsung.

Detail layer dan tanggung jawabnya dijelaskan pada:

* [Data Layer](layers/data-layer.md)
* [Domain Layer](layers/domain-layer.md)
* [Logic Layer](layers/logic-layer.md)
* [UI Layer](layers/ui-layer.md)

App sebagai composition layer dijelaskan terpisah pada:

* [App Layer](layers/app.md)



## Ringkasan Dependency

*(Dependency Rule)*
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

Panah dependency menunjukkan bahwa App dapat meng-compose UI, Logic, Domain, dan implementasi Data (misalnya saat registrasi DI). UI, Logic, dan Data masing-masing bergantung ke Domain sesuai kontraknya. Tidak ada dependency langsung UI → Logic; App mengorkestrasi bagian UI dan Logic melalui callback, provider, atau mekanisme composition lain.

Detail aturan dependency dijelaskan pada:

* [Dependency Rules](dependency-rules.md)



## Pengembangan Berbasis Sequence

FSDA menggunakan pendekatan Sequence-Based Development.

Sequence adalah pola aliran dari Use Case melalui kontrak Repository hingga implementasi Data. Sequence tidak mencakup UI atau Logic slice. Tipe Use Case ditentukan oleh kombinasi flow dan signature: async, sync, atau stream; masing-masing dapat berupa void, param, return, atau return + param. Kombinasi tersebut menghasilkan 12 tipe sequence.

Satu alur fitur dapat melibatkan satu atau lebih slice dan/atau sequence. Satu slice dapat berkaitan dengan beberapa sequence, dan satu sequence dapat berkaitan dengan beberapa slice atau alur fitur. App mengorkestrasi bagian UI/Logic yang relevan bersama sequence yang dibutuhkan.

Istilah deskriptif **alur fitur** (*feature flow*) digunakan untuk menyebut keseluruhan proses seperti update product. Istilah ini menjelaskan keterkaitan slice, sequence, dan orkestrasi App; ia bukan unit folder atau abstraksi arsitektur formal yang wajib dibuat.

Contohnya, App menggunakan dan mengorkestrasi bagian UI `ui/update`, bagian Logic `logic/update` dan `logic/form_update`, serta dua Use Case/sequence untuk upload image dan update product. Pada alur delete product, App dapat menggunakan bagian UI `ui/delete`, bagian Logic `logic/delete`, dan satu sequence delete. Susunan setiap alur ditentukan oleh kebutuhannya.



## Prinsip

Seluruh prinsip dasar FSDA dijelaskan pada:

* [Principles](principles.md)



## Struktur

Struktur folder, module, feature, feature slice, dan sequence dijelaskan pada:

* [Structure](structure.md)



## Shared Packages 

Dokumentasi shared package disusun terpisah per package agar tanggung jawab tiap fondasi tetap eksplisit.

* [app_core](../packages/app-core.md)
* [app_l10n](../packages/app-l10n.md)
* [app_ui](../packages/app-ui.md)



## Konvensi

Dokumen konvensi yang tersedia saat ini:

* [Naming Conventions](../conventions/naming-conventions.md)
* [Coding Standards](../conventions/coding-standards.md)
* [Commit Conventions](../conventions/commit-conventions.md)

Konvensi lain akan dipublikasikan terpisah sesuai kebutuhan dokumentasi.



## Dokumen Pendukung

Dokumen pendukung berikut membantu menjelaskan fondasi, pengambilan keputusan, testing, dan arah tooling FSDA.

* [Foundations](foundations.md)
* [Sequence Decision Guide](../guides/sequence-decision-guide.md)
* [Testing Strategy](../guides/testing-strategy.md)
* [Anti-Patterns](../guides/anti-patterns.md)
* [Tooling](../guides/tooling.md)



## Filosofi

> Arsitektur yang baik membantu developer membuat keputusan.

> Arsitektur yang hebat mengurangi jumlah keputusan yang perlu dibuat oleh developer.

FSDA dibangun berdasarkan filosofi tersebut.

Dengan aturan yang jelas, struktur yang konsisten, dan batasan yang eksplisit, developer dapat lebih fokus menyelesaikan masalah bisnis tanpa harus terus-menerus memikirkan bagaimana proyek seharusnya disusun.



## Status

🚧 Sedang Dalam Pengembangan Aktif

FSDA terus berkembang berdasarkan pengalaman nyata dalam pengembangan aplikasi Flutter dan kebutuhan untuk menjaga konsistensi, skalabilitas, dan kemudahan automasi dalam jangka panjang.