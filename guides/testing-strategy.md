# Testing Strategy

Dokumen ini menjelaskan strategi testing dasar pada FSDA.

&nbsp;

## Purpose

Testing strategy membantu memastikan tiap layer dapat diverifikasi tanpa mengaburkan boundary arsitektur.

&nbsp;

## Layer-Based Testing

Gunakan pendekatan berikut sebagai baseline:

* Domain: unit test untuk use case, contract behavior, dan rule bisnis
* Data: test untuk mapping, translation error, repository behavior, dan adapter teknis
* Logic: test untuk state transition dan orchestration logic
* UI: widget test untuk presentation dan interaction utama
* App: integration atau smoke test untuk composition, route, dan dependency wiring

&nbsp;

## Sequence-Based Testing

Selain berdasarkan layer, testing juga dapat dilihat dari sequence.

Contoh fokus pengujian:

* Mutation: input valid, input invalid, success flow, failure flow
* Mutation + Return: verifikasi hasil return dan side effect yang relevan
* Retrieval: success, empty state, failure, loading
* Retrieval + Pagination: page progression, append behavior, end-of-list behavior
* Retrieval + Stream: initial emission, update emission, failure emission bila relevan
* Retrieval + Local First: local hit, remote fallback, sync behavior bila ada

&nbsp;

## What To Prioritize

Prioritaskan test pada area berikut:

* boundary yang rawan berubah
* error translation dari Data ke Domain
* state transition pada Logic
* flow App composition yang kritis

&nbsp;

## What To Avoid

Hindari test yang:

* terlalu terikat pada detail implementasi internal yang tidak penting
* sulit dirawat karena setup teknisnya lebih kompleks daripada behavior yang diuji
* mengulang verifikasi yang sama di terlalu banyak layer tanpa nilai tambah jelas

