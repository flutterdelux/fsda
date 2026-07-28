# Getting Started

Selamat datang di Feature Slice Driven Architecture (FSDA).

Dokumen ini membantu memahami cara kerja FSDA sebelum mulai mengembangkan fitur.

## What is FSDA?

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

Lanjutkan dengan dokumen pendukung berikut:

* [Foundations](architecture/foundations.md)
* [Sequence Decision Guide](guides/sequence-decision-guide.md)
* [Testing Strategy](guides/testing-strategy.md)
* [Anti-Patterns](guides/anti-patterns.md)
* [Tooling](guides/tooling.md)

## Getting Started Paths (Wikuy)

Untuk praktik end-to-end yang langsung bisa diikuti, gunakan salah satu jalur berikut:

1. [Manual E2E (tanpa FSDA CLI)](getting-started-cli-wikuy)
2. [CLI-Driven E2E (mayoritas FSDA CLI + finalisasi manual)](getting-started-cli-wikuy)

Keduanya menghasilkan target yang sama:

* Workspace: `Wikuy`
* App: `wikuy`
* Module: `travel`
* Feature: `destination`
* Slice: `list`
* Sequence: `R`
* UI: `lsv`
* Main page class: `DestinationListPage`
* API source: `GET /destinations`
