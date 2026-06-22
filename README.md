# Feature Slice Driven Architecture (FSDA)

Current Specification:  
v1.0.0

> A pragmatic, rule-driven Flutter architecture focused on consistency, discoverability, and long-term maintainability.

&nbsp;

## What is Feature Slice Driven Architecture (FSDA)?

FSDA adalah pendekatan arsitektur Flutter yang berfokus pada:

* Konsistensi
* Discoverability
* Maintainability
* Scalability
* Developer Experience

Arsitektur ini menggabungkan berbagai ide dari Clean Architecture, Feature First, DDD, dan Modular Architecture ke dalam aturan yang lebih konsisten untuk kebutuhan implementasi nyata.

&nbsp;

## Why?

Banyak arsitektur menjelaskan prinsip.

Sedikit yang menjelaskan implementasi.

Akibatnya:

* Struktur proyek berbeda-beda
* Naming convention tidak konsisten
* Tanggung jawab layer menjadi ambigu
* Architectural drift mudah terjadi

FSDA hadir untuk mengurangi ambiguitas tersebut melalui aturan struktur, dependency, dan konvensi yang eksplisit.

&nbsp;

## High-Level Overview

```text
apps/
├── user_app
├── admin_app
└── operator_app

modules/
├── inbox
├── note
├── profile
└── task

packages/
├── app_core
├── app_ui
├── app_l10n
└── app_infrastructure
```

### Shared Packages

Fondasi yang digunakan bersama oleh seluruh sistem.

* app_core
* app_ui
* app_l10n
* app_infrastructure

`app_infrastructure` saat ini masih dalam tahap pengembangan. Bentuk akhirnya belum dipatok apakah tetap menjadi package fondasi gabungan untuk kebutuhan implementasi kecil yang sering dipakai, atau dipecah sejak awal menjadi package yang lebih spesifik seperti `infra_dio`, `infra_logger`, `infra_supabase`, dan lainnya.

### Modules

Boundary bisnis utama yang berisi feature-feature dalam domain yang sama dan dapat digunakan kembali oleh banyak aplikasi.

* inbox
* note
* profile
* task

### Apps

Lapisan komposisi yang menyusun modules dan shared packages menjadi aplikasi yang berjalan.

&nbsp;

## Core Ideas

* Rule-Driven Architecture
* Discoverability First
* Modular Monorepo
* Sequence-Based Development
* Composition over Duplication
* Stable Foundations, Flexible Implementations
* Technology Agnostic

&nbsp;

## Documentation

### Entry Point

* [Getting Started](docs/getting-started.md)

### Core Rules

* [Architecture](docs/architecture/architecture.md)
* [Principles](docs/architecture/principles.md)
* [Structure](docs/architecture/structure.md)
* [Dependency Rules](docs/architecture/dependency-rules.md)
* [Sequence Pattern](docs/architecture/sequence-pattern.md)

### Layer Details

* [Domain Layer](docs/architecture/layers/domain-layer.md)
* [Data Layer](docs/architecture/layers/data-layer.md)
* [Logic Layer](docs/architecture/layers/logic-layer.md)
* [UI Layer](docs/architecture/layers/ui-layer.md)
* [App Layer](docs/architecture/layers/app.md)

### Workflow And Reference

* [Development Workflow](docs/guides/development-workflow.md)
* [Structure Example](docs/architecture/structure-example.md)

### Conventions

* [Naming Conventions](docs/conventions/naming-conventions.md)
* [Coding Standards](docs/conventions/coding-standards.md)
* [Commit Conventions](docs/conventions/commit-conventions.md)

### Guides And Supporting Docs

* [Foundations](docs/architecture/foundations.md)
* [Sequence Decision Guide](docs/guides/sequence-decision-guide.md)
* [Testing Strategy](docs/guides/testing-strategy.md)
* [Anti-Patterns](docs/guides/anti-patterns.md)
* [Tooling](docs/guides/tooling.md)

### Shared Package Docs

* [app_core](docs/packages/app-core.md)
* [app_l10n](docs/packages/app-l10n.md)
* [app_ui](docs/packages/app-ui.md)
* [app_infrastructure](docs/packages/app-infrastructure.md)

&nbsp;

## Status

🚧 Under Active Development
