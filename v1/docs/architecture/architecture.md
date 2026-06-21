# Feature Slice Driven Architecture (FSDA)

> A pragmatic, rule-driven Flutter architecture focused on consistency, discoverability, maintainability, scalability, and automation.

&nbsp;

## What is Feature Slice Driven Architecture (FSDA)?

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

&nbsp;

## Why FSDA?

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

&nbsp;

## Structural Overview

FSDA menggunakan pendekatan Modular Monorepo.

```text
Workspace
├── Apps
├── Modules
└── Packages
```

Setiap layer memiliki tanggung jawab yang jelas dan batasan yang eksplisit.

&nbsp;

### Workspace

Workspace merupakan root dari seluruh sistem.

Workspace mengelompokkan:

- Apps
- Modules
- Shared Packages
- Documentation

Workspace bukan tempat implementasi business logic.

&nbsp;

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

&nbsp;

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

&nbsp;

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

&nbsp;

### Feature Slice

Feature Slice merupakan unit pengembangan terkecil dalam FSDA.

Contoh:

```text
create
update
delete
list
detail
status
mark_all_read
```

Feature Slice memiliki satu tujuan yang jelas dan mengikuti satu sequence yang jelas.

&nbsp;

### Shared Package

Shared Package menyediakan fondasi yang digunakan bersama oleh seluruh sistem.

Contoh:

```text
packages/
├── app_core
├── app_infrastructure
├── app_l10n
└── app_ui
```

Shared Package menyediakan kontrak, utilitas, fondasi UI, dan integrasi teknologi yang dapat digunakan oleh seluruh aplikasi dan module.

&nbsp;

## Architecture Layers

```
UI
 ↓
Logic
 ↓
Domain

Data
 └─ implement Domain Contract
```

Detail layer dan tanggung jawabnya dijelaskan pada:

* [Data Layer](layers/data-layer.md)
* [Domain Layer](layers/domain-layer.md)
* [Logic Layer](layers/logic-layer.md)
* [UI Layer](layers/ui-layer.md)

App sebagai composition layer dijelaskan terpisah pada:

* [App Layer](layers/app.md)

&nbsp;

## Dependency Overview

```
UI
 ↓
Logic
 ↓
Domain
 ↑
Data
```

Detail aturan dependency dijelaskan pada:

* [Dependency Rules](dependency-rules.md)

&nbsp;

## Sequence-Based Development

FSDA menggunakan pendekatan Sequence-Based Development.

Setiap Feature Slice harus mengikuti sequence yang telah didefinisikan.

Contoh:

- Mutation
- Mutation + Param
- Mutation + Return
- Mutation + Return + Param
- Retrieval
- Retrieval + Param
- Retrieval + Pagination
- Retrieval + Stream
- Retrieval + Stream + Param
- Retrieval + Cache
- Retrieval + Local First

Sequence menyediakan pola implementasi yang konsisten, dapat diprediksi, dan mudah diautomasi.

&nbsp;

## Principles

Seluruh prinsip dasar FSDA dijelaskan pada:

* [Principles](principles.md)

&nbsp;

## Structure

Struktur folder, module, feature, feature slice, dan sequence dijelaskan pada:

* [Structure](structure.md)

&nbsp;

## Shared Packages

Dokumentasi shared package disusun terpisah per package agar tanggung jawab tiap fondasi tetap eksplisit.

* [app_core](../packages/app-core.md)
* [app_l10n](../packages/app-l10n.md)
* [app_ui](../packages/app-ui.md)
* [app_infrastructure](../packages/app-infrastructure.md)

&nbsp;

## Conventions

Dokumen konvensi yang tersedia saat ini:

* [Naming Conventions](../conventions/naming-conventions.md)
* [Coding Standards](../conventions/coding-standards.md)
* [Commit Conventions](../conventions/commit-conventions.md)

Konvensi lain akan dipublikasikan terpisah sesuai kebutuhan dokumentasi.

&nbsp;

## Supporting Docs

Dokumen pendukung berikut membantu menjelaskan fondasi, pengambilan keputusan, testing, dan arah tooling FSDA.

* [Foundations](foundations.md)
* [Sequence Decision Guide](../guides/sequence-decision-guide.md)
* [Testing Strategy](../guides/testing-strategy.md)
* [Anti-Patterns](../guides/anti-patterns.md)
* [Tooling](../guides/tooling.md)

&nbsp;

## Philosophy

> A good architecture helps developers make decisions.

> A great architecture reduces the number of decisions developers need to make.

FSDA dibangun berdasarkan filosofi tersebut.

Dengan aturan yang jelas, struktur yang konsisten, dan batasan yang eksplisit, developer dapat lebih fokus menyelesaikan masalah bisnis tanpa harus terus-menerus memikirkan bagaimana proyek seharusnya disusun.

&nbsp;

## Status

🚧 Under Active Development

FSDA terus berkembang berdasarkan pengalaman nyata dalam pengembangan aplikasi Flutter dan kebutuhan untuk menjaga konsistensi, skalabilitas, dan kemudahan automasi dalam jangka panjang.