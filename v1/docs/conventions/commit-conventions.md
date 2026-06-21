# Commit Conventions

Dokumen ini menjelaskan baseline commit convention untuk FSDA.

&nbsp;

## Purpose

Commit convention membantu menjaga histori repository tetap mudah dibaca, mudah ditelusuri, dan mudah direview.

&nbsp;

## General Rules

Gunakan commit yang:

* fokus pada satu concern utama
* menjelaskan intent perubahan dengan singkat
* tidak mencampur refactor, formatting, dan perubahan behavior besar tanpa alasan jelas

&nbsp;

## Recommended Format

Format yang direkomendasikan:

```text
<type>: <summary>
```

Contoh:

```text
docs: clarify cross-feature dependency rules
fix: align param naming in structure docs
refactor: simplify module shared placement examples
```

&nbsp;

## Suggested Types

Gunakan type yang paling representatif:

* `feat` untuk penambahan capability baru
* `fix` untuk perbaikan bug atau perilaku yang salah
* `docs` untuk perubahan dokumentasi
* `refactor` untuk perubahan struktur internal tanpa mengubah behavior eksternal
* `test` untuk penambahan atau perbaikan test
* `chore` untuk pekerjaan maintenance umum
* `build` untuk perubahan build, tooling, atau dependency setup

&nbsp;

## Scope Guidance

Jika perlu, ringkasan dapat menyebut boundary yang berubah.

Contoh:

```text
docs: refine app composition workflow
fix: align domain failure placement
refactor: simplify note list page example
```

&nbsp;

## What To Avoid

Hindari commit seperti:

* `update`
* `fix bug`
* `misc`
* `final`

Hindari juga commit yang terlalu besar dan mencampur terlalu banyak concern yang berbeda.

&nbsp;

## Documentation Changes

Jika perubahan menyentuh aturan arsitektur, naming, dependency, atau structure, gunakan ringkasan yang eksplisit agar perubahan normatif mudah ditemukan kembali di histori commit.