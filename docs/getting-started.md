# Getting Started

Selamat datang di Feature Slice Driven Architecture (FSDA).

Dokumen ini membantu memahami cara kerja FSDA sebelum mulai mengembangkan fitur.

&nbsp;

## What is Feature Slice Driven Architecture (FSDA)

FSDA adalah arsitektur Flutter modular yang dibangun dengan prinsip:

* Feature First
* Domain Centered
* Sequence Driven
* Automation Friendly

Tujuan utamanya adalah:

* Struktur mudah dipahami
* Implementasi mudah diprediksi
* Dependency tetap terkendali
* Feature mudah dipindahkan
* Mudah dihasilkan oleh tooling

&nbsp;

## Read Order

Sebelum mulai mengembangkan fitur, baca dokumentasi dengan urutan berikut:

1. [architecture/architecture.md](architecture/architecture.md)
2. [architecture/principles.md](architecture/principles.md)
3. [architecture/structure.md](architecture/structure.md)
4. [architecture/dependency-rules.md](architecture/dependency-rules.md)
5. [architecture/sequence-pattern.md](architecture/sequence-pattern.md)
6. [conventions/naming-conventions.md](conventions/naming-conventions.md)
7. [architecture/layers/domain-layer.md](architecture/layers/domain-layer.md)
8. [architecture/layers/data-layer.md](architecture/layers/data-layer.md)
9. [architecture/layers/logic-layer.md](architecture/layers/logic-layer.md)
10. [architecture/layers/ui-layer.md](architecture/layers/ui-layer.md)
11. [architecture/layers/app.md](architecture/layers/app.md)
12. [guides/development-workflow.md](guides/development-workflow.md)
13. [architecture/structure-example.md](architecture/structure-example.md)

Setelah fondasi utama dipahami, lanjutkan dengan dokumen pendukung berikut:

* [Foundations](architecture/foundations.md)
* [Sequence Decision Guide](guides/sequence-decision-guide.md)
* [Testing Strategy](guides/testing-strategy.md)
* [Anti-Patterns](guides/anti-patterns.md)
* [Tooling](guides/tooling.md)

&nbsp;

## Core Concepts

Sebelum mulai coding, pahami istilah berikut.

- ### Module

Module adalah boundary bisnis utama.

Contoh:

```text
finance
task
travel
product
```

- ### Feature

Feature adalah bagian bisnis di dalam module.

Contoh:

```text
finance
└── wallet
```

```text
travel
└── destination
```

- ### Feature Slice

Feature slice adalah unit implementasi terkecil.

Contoh:

```text
wallet/delete
wallet/list

destination/popular
destination/detail
```

- ### Sequence

Sequence adalah pola implementasi feature slice.

Contoh:

```text
delete wallet
→ Mutation + Param

create task
→ Mutation + Return + Param

product detail
→ Retrieval + Param

note list
→ Retrieval + Local First
```

Setiap feature slice harus mengikuti sequence yang sesuai.

&nbsp;

## Development Philosophy

Ketika membuat fitur baru:

Jangan mulai dari folder.

Jangan mulai dari UI.

Jangan mulai dari API.

Mulailah dari:

```text
Feature Slice
↓
Pilih Sequence
↓
Ikuti Blueprint
↓
Implementasikan
```

Sequence menjadi sumber kebenaran implementasi.

&nbsp;

## Choosing Sequence

Pertanyaan pertama yang harus dijawab:

"Feature slice ini termasuk sequence apa?"

Contoh:

| Slice Requirement     | Choose Sequence            | Code |
|- | - | - |
| Delete wallet         | Mutation + Param           | Mp   |
| Create task           | Mutation + Return + Param  | Mrp  |
| Product detail        | Retrieval + Param          | Rp   |
| Watch Payment Status  | Retrieval + Stream + Param | Rsp  |

Lebih lengkap tentang sequence pattern bisa dibaca di [architecture/sequence-pattern.md](architecture/sequence-pattern.md).

&nbsp;

## Blueprint First

Setelah sequence ditemukan:

Buka blueprint yang sesuai.

Contoh:

```text
Mutation + Param
```

Contoh:

* [Mutation Param Blueprint](../templates/blueprints/mutation-param-blueprint.md)

Blueprint adalah template implementasi.

Jangan membuat struktur sendiri.

Ikuti blueprint yang tersedia.

&nbsp;

## Dependency Direction

Dependency selalu mengarah ke domain.

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```

Domain tidak mengetahui layer lain.

&nbsp;

## App Responsibility

App bertugas meng-compose:

* Module
* Route
* Dependency Injection
* Logic
* UI

Contoh:

```text
ProductDetailPage
 ├── BlocProvider
 └── ProductDetailView
```

Page berada pada App.

Page dapat merepresentasikan satu primary slice atau menjadi aggregate surface yang menggabungkan beberapa slice.

View berada pada Module.

&nbsp;

## Naming Matters

Jangan membuat naming sendiri.

Gunakan aturan pada:

* [Naming Conventions](conventions/naming-conventions.md)

Karena:

* tooling bergantung pada naming
* blueprint bergantung pada naming
* automation bergantung pada naming

&nbsp;

## Golden Rule

Jika ragu:

1. Tentukan feature slice.
2. Cari sequence yang sesuai.
3. Buka blueprint.
4. Ikuti naming convention.
5. Ikuti dependency rules.
6. Diskusi di Forum (Github)

Jangan membuat pola baru jika sequence yang ada sudah dapat digunakan dan jadikan acuan.
