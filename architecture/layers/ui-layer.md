# UI Layer

UI adalah visual atau bentuk tampilan yang dapat dilihat oleh user dan dapat berinteraksi dengannya.

UI bertanggung jawab menampilkan informasi kepada user.

UI harus fokus pada presentation.

UI tidak boleh mengandung business orchestration.

&nbsp;

## Responsibilities

UI bertanggung jawab menyediakan:

* View
* Widget
* Komponen visual lainnya

UI tidak bertanggung jawab terhadap:

* API
* Database
* Business Logic
* State Management

&nbsp;

## UI Structure

Visual yang terikat pada slice dikelompokkan di dalam slice. Jika visual tersebut digunakan bersama, letakkan di shared.

```text
ui/
├── <slice>/
│   ├── views/
│   └── widgets/
└── shared/
```

&nbsp;

## View

View adalah root visual untuk feature slice.

Contoh:

```dart
class ProductDetailView extends StatelessWidget {
}
```

View hanya menerima data.

View tidak memanggil repository.

View tidak memanggil datasource.

&nbsp;

## Widget

Widget adalah komponen presentasi.

Contoh:

```dart
class ProductDetailCard extends StatelessWidget {
}
```

&nbsp;

## Shared UI

Digunakan oleh beberapa slice dalam feature.

Contoh:

```text
ui/
└── shared/
    ├── widgets/
    └── extensions/
```

Failure extension untuk menerjemahkan module failure ke kebutuhan presentasi diletakkan pada module scope:

```text
shared/
└── ui/
    └── extensions/
        └── <module>_failure_x.dart
```

Jika UI pada module menampilkan text ke user, module tersebut sebaiknya memiliki resource localization sendiri. `app_l10n` tetap digunakan untuk text yang sifatnya umum atau shared lintas module.

&nbsp;

## Dependency Rules

Allowed:

```text
domain/ (entity, enum, param only)
ui/
flutter/
app_ui/
```

Forbidden:

```text
data/
logic/
```

&nbsp;

## Why This Layer Exists

UI ada untuk menyajikan informasi kepada user.

&nbsp;

## Key Principle

UI hanya menampilkan data.

UI tidak mengorkestrasi bisnis.

UI tidak mengetahui implementasi data.

UI hanya boleh mengetahui domain model yang dibutuhkan untuk presentasi, bukan repository contract atau use case.

App Layer bertugas meng-compose UI dan Logic.
