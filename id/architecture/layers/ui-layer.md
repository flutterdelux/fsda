# UI Layer

UI adalah visual atau bentuk tampilan yang dapat dilihat oleh user dan dapat berinteraksi dengannya.

UI bertanggung jawab menampilkan informasi kepada user.

UI harus fokus pada presentation.

UI tidak boleh mengandung business orchestration.



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



## UI Structure

Visual yang menjadi bagian UI dari suatu slice dikelompokkan di `ui/<slice>`. Jika visual tersebut digunakan bersama beberapa slice, letakkan di shared.

```text
ui/
├── <ui_slice>/
│   ├── views/
│   └── widgets/
└── shared/
```



## View

View adalah root visual untuk feature slice.

Contoh:

```dart
class ProductDetailView extends StatelessWidget {
}
```

View hanya menerima data dan callback yang diperlukan untuk menyampaikan interaksi.

View tidak memanggil repository.

View tidak memanggil datasource.



## Widget

Widget adalah komponen presentasi.

Contoh:

```dart
class ProductDetailCard extends StatelessWidget {
}
```



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



## Why This Layer Exists

UI ada untuk menyajikan informasi kepada user.



## Key Principle

UI hanya menampilkan data dan menyediakan titik interaksi melalui event/callback yang diberikan oleh App.

UI tidak mengorkestrasi bisnis dan tidak memanggil Logic (Cubit/Bloc/Controller) secara langsung. App yang menerima/menghubungkan interaksi UI dan mengorkestrasi Logic.

UI boleh menangani perilaku presentasi lokal seperti membaca input, validasi field/form untuk feedback langsung, dan menyusun nilai input. UI mengekspos nilai atau hasil interaksi melalui callback; App yang meneruskannya ke Logic. Aturan bisnis dan state aplikasi tetap menjadi tanggung jawab Domain/Logic.

UI tidak mengetahui implementasi data maupun Logic. Callback menjadi batas komunikasi; App bertanggung jawab menghubungkan callback UI dengan aksi Logic dan menyusun state Logic menjadi data presentasi.

UI hanya boleh mengetahui domain model yang dibutuhkan untuk presentasi, bukan repository contract atau use case.

App Layer bertugas meng-compose UI dan Logic.
