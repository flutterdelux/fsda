# Development Workflow

Dokumen ini menjelaskan alur pengembangan aplikasi menggunakan FSDA.

Tujuan workflow ini adalah:

* Menjaga konsistensi pengembangan.
* Memastikan implementasi mengikuti sequence yang benar.
* Mempermudah scaling project.
* Mempermudah kolaborasi tim.
* Mempermudah automation dan code generation.



## Phase 1 — Workspace Setup

Phase ini dilakukan satu kali pada awal project.

---

### 1.1 Create Workspace

Buat root workspace.

Contoh:

```text
workspace_name/
├── apps/
├── modules/
└── packages/
```

---

### 1.2 Create Shared Packages

Buat package fondasi.

Minimal:

```text
packages/
├── app_core
├── app_l10n
├── app_ui
└── infra_...
```

`infra_...` untuk implementasi kecil yang sering dipakai bersama dipecah menjadi package infrastructure yang lebih spesifik.

Contoh:

```text
packages/
├── infra_http
├── infra_http
├── infra_firebase
├── infra_supabase
└── infra_storage
```

---

### 1.3 Create App Project

Buat project aplikasi.

Contoh:

```text
apps/
├── customer_app
└── admin_app
```

---

### 1.4 Setup App Foundation

Setup struktur dasar aplikasi.

Contoh:

```text
lib/
├── main.dart
├── app/
│   ├── app_router.dart
│   ├── main_app.dart
│   ├── startup.dart
│   └── dashboard/
├── core/
│   ├── constants/
│   ├── di/
│   │   ├── core_di.dart
│   │   ├── di.dart
│   │   ├── di_keys.dart
│   │   └── external_di.dart
│   ├── extensions/
│   │   └── failure_x.dart
│   ├── externals/
│   │   ├── <tech1>_config.dart
│   │   └── <tech2>_config.dart
│   ├── mixins/
│   │   └── page_provider_mixin.dart
│   └── pages/
│       ├── invalid_argument_page.dart
│       └── not_found_page.dart
└── modules/
```

---

### 1.5 Determine Infrastructure

Tentukan teknologi yang digunakan.

Contoh:

| Concern        | Technology    |
| -------------- | ------------- |
| ApiClient      | Http           |
| Local Storage  | Hive          |
| Database       | Sqflite       |
| BaaS           | Supabase      |
| Authentication | Firebase Auth |

---

### 1.6 Compose Infrastructure

Register seluruh dependency teknis.

Contoh:

```text
core/
├── di/
│   ├── external_di.dart
│   └── core_di.dart
└── externals/
```

Contoh:

```dart
Future<void> externalDI() async {
  getIt.registerLazySingleton<Client>(
    () => Client(),
  );
}
```

Infrastructure dapat ditambah atau diubah kembali selama pengembangan berlangsung.



## Phase 2 — Module Development

Phase ini dilakukan berulang selama pengembangan aplikasi.

---

### 2.1 Identify Requirement

Ubah requirement menjadi alur fitur, lalu identifikasi Use Case dan kebutuhan state/presentasi. Tentukan sequence dari kontrak Use Case. Secara terpisah, tentukan slice fitur yang terkait dan bagian Logic/UI yang diperlukan. App akan mengorkestrasi bagian-bagian tersebut.

Contoh:

| Requirement | Module | Feature | Use Case / Sequence | Slice fitur terkait |
| --- | --- | --- | --- | --- |
| Delete wallet | finance | wallet | delete Use Case dan sequence-nya | slice `delete`: bagian `logic/delete` + `ui/delete` |
| Create task | task | task | create Use Case dan sequence-nya | slice `create`: bagian `logic/create` + `ui/create`; slice `form_create`: bagian `logic/form_create` |
| Product update | product | product | upload image dan update product Use Cases beserta sequence masing-masing | slice `update`: bagian `logic/update` + `ui/update`; slice `form_update`: bagian `logic/form_update` |

---

### 2.2 Determine Sequence

Pilih sequence type untuk setiap Use Case berdasarkan flow dan signature-nya. Sequence dipilih dari 12 kombinasi async/sync/stream × void/param/return/return + param. Ini bukan keputusan per slice.

Contoh: `ProductImageUploadUseCase` dan `ProductUpdateUseCase` masing-masing memiliki sequence sesuai signature-nya. App mengorkestrasi bagian Logic `logic/update` yang memanggil kedua Use Case, bersama bagian UI dan state form yang terkait.

---

### 2.3 Create Module Skeleton

Jika module belum ada, buat struktur dasar module.

```text
module1/
├── analysis_options.yaml
├── build.yaml
├── l10n.yaml
├── pubspec.yaml
└── lib/
  ├── module1.dart
  ├── l10n/
  │   ├── module1_en.arb
  │   └── module1_id.arb
  └── src/
    ├── features/
    ├── generated/
    └── shared/
      ├── data/
      │   └── errors/
      │       └── module1_exception.dart
      ├── domain/
      │   └── errors/
      │       └── module1_failure.dart
      ├── logic/
      └── ui/
        └── extensions/
          └── module1_failure_x.dart
```

Baseline module di atas penting karena setiap module adalah Flutter package mandiri.

Jika module memiliki UI text yang tampil ke user, module tersebut sebaiknya memiliki resource localization sendiri. `app_l10n` tetap dipakai untuk localization yang sifatnya umum atau shared lintas module.

`l10n.yaml` module dapat menggunakan baseline berikut:

```yaml
arb-dir: lib/l10n
template-arb-file: <module>_en.arb
output-localization-file: <module>_localizations.dart
output-class: <Module>Localizations
output-dir: lib/src/generated
untranslated-messages-file: missing_keys.json
```

`build.yaml` module dapat digunakan untuk membatasi scope code generation agar tetap fokus pada boundary module.

Contoh baseline:

```yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          field_rename: snake
          explicit_to_json: true
```

Selain itu, setiap module juga sebaiknya menyiapkan dependency dan dev dependency yang mendukung object modeling dan code generation.

Baseline package yang umum dibutuhkan:

dependencies:
* `freezed_annotation`
* `json_annotation`

dev_dependencies:
* `build_runner`
* `freezed`
* `json_serializable`

Dalam baseline Flutter saat ini, object modeling seperti DTO, Entity, Request, Response, Param, dan State direkomendasikan menggunakan `Freezed`. Untuk object yang membutuhkan serialisasi, gunakan `json_serializable` dengan baseline `build.yaml` di atas.

Selain dependency teknis tersebut, module umumnya juga bergantung pada shared package berikut:

* `app_core` untuk contract dan abstraction lintas app maupun module
* `app_l10n` untuk localization umum lintas app maupun module
* `app_ui` untuk kebutuhan standard UI lintas app maupun module

---

### 2.4 Create Module Shared Resources

Urutan pembuatan:

```text
Failure
↓
Exception
↓
FailureX
```

Karena:

```text
Failure
→ menjadi acuan untuk Exception
→ menjadi acuan untuk FailureX

FailureX
→ menerjemahkan Failure ke kebutuhan presentasi
```

---

### 2.5 Create Feature Skeleton

Jika feature belum ada.

```text
feature1/
├── feature1_feature.dart
├── data/
│   ├── converters/
│   ├── datasources/
│   │   ├── feature1_remote_data_source.dart
│   │   └── feature1_remote_data_source_impl.dart
│   ├── dtos/
│   ├── repositories/
│   │   └── feature1_repository_impl.dart
│   ├── requests/
│   └── responses/
├── domain/
│   ├── entities/
│   ├── enums/
│   ├── params/
│   ├── repositories/
│   │   └── feature1_repository.dart
│   └── usecases/
├── logic/
└── ui/
```

---

### 2.6 Plan Layer Slices and Use Case Sequences

Buat daftar Use Case dan tentukan sequence type masing-masing. Secara terpisah, identifikasi slice fitur yang terkait serta bagian Logic/UI yang diperlukan. App mengorkestrasi komponen tersebut untuk menjalankan alur fitur.

Contoh:

```text
slice: update
├── logic/update/ # memanggil UploadImageUseCase dan UpdateProductUseCase
└── ui/update/    # form, tombol, dan callback; tanpa akses langsung ke Logic

slice: form_update
└── logic/form_update/ # mengelola input/state form
```

Tidak semua slice memiliki bagian UI maupun Logic. Bagian Logic dapat memanggil beberapa Use Case yang masing-masing memiliki sequence, atau mengelola state lokal tanpa Use Case. App menentukan bagian-bagian yang disusun bersama.

---

### 2.7 Create Domain

Urutan:

```text
Enum
↓
Entity
↓
Param
↓
Repository Contract
↓
Use Case
```

---

### 2.8 Create Data

Jika domain menggunakan enum:

```text
Enum
↓
Converter
```

Kemudian:

```text
Converter
↓
DTO
↓
Request
↓
Response
↓
Datasource
↓
Repository Implementation
```

---

### 2.9 Implement Use Case Sequences

Implementasikan setiap Use Case mengikuti contract sequence-nya dari Domain ke Data.

---

### 2.10 Complete Logic

Implementasikan bagian Logic dari setiap slice yang membutuhkan state dan koordinasi Use Case. Slice form/state yang tidak memanggil Use Case tetap valid.

Urutan:

```text
State
↓
Cubit / Bloc / Controller
```

---

### 2.11 Create UI

Implementasikan bagian UI dari slice sebagai presentasi dumb yang menerima data dan callback. UI boleh memvalidasi input untuk feedback lokal, lalu mengekspos nilai melalui callback. App menyampaikan aksi/input ke Logic dan memberikan data/state Logic ke UI.

Urutan:

```text
View
↓
Widgets
↓
Shared UI
```

---

### 2.12 Validate Against FSDA Rules

Tinjau implementasi terhadap aturan tiap layer, kontrak sequence, batas slice, dan orkestrasi App. Pastikan:

```text
dependency
ownership tiap komponen
dependency antar layer
signature dan aliran sequence
keterkaitan slice dengan alur fitur
orkestrasi App antara UI dan Logic
```

sesuai dengan aturan FSDA yang berlaku.



## Phase 3 — App Composition

Phase ini menghubungkan module ke aplikasi.

---

### 3.1 Create App Composition Page

App menjadi orchestrator yang menyusun Logic dan UI. App membuat atau menyediakan Logic, menangani pemanggilannya, lalu memberikan state dan callback yang diperlukan ke UI. UI hanya menjadi titik interaksi/presentasi dan tidak mengakses Cubit/Bloc secara langsung.

Contoh:

```text
apps/
└── customer_app/
    └── lib/
        └── modules/
            └── product/
                └── features/
                    └── product/
                        └── pages/
                            └── product_detail_page.dart
```

Page pada App dapat mewakili satu primary slice atau mengagregasi beberapa slice sekaligus.

Contohnya, Page dapat membuat Cubit dan memanggil method awal saat provider dibuat. Untuk aksi berikutnya, Page menyediakan callback ke widget UI; ketika user berinteraksi, callback milik App itulah yang memanggil Logic.

Logic dapat diregistrasikan di page scope atau scope yang lebih tinggi seperti root/global scope sesuai kebutuhan lifecycle dan composition.

Contoh:

```text
ProductDetailPage
├── BlocProvider
└── ProductDetailView
```

---

### 3.2 Compose Module Route

Tambahkan route module.

Contoh:

```dart
abstract final class Module1Route {
  RouteBase get base => ...
}
```

```dart
routes: [
  ...,
  Module1Route.base,
↓
Tentukan slice fitur dan sequence yang berkaitan
↓
Komposisi App
↓
Implementasi dan pengujian

### 3.3 Compose Localization
Ikuti aturan tiap layer, sequence, dan slice. App menggunakan serta mengorkestrasi komponen yang berkaitan untuk menjalankan alur fitur.
Compose localization umum dari `app_l10n` bersama localization milik module-module yang digunakan aplikasi.

Contoh:

```dart
MaterialApp(
  localizationsDelegates: [
    AppLocalizations.delegate,
    ProductLocalizations.delegate,
    FinanceLocalizations.delegate,
  ],
)
```

Pada tahap ini App bertugas menentukan localization mana saja yang benar-benar dipakai pada aplikasi, lalu menyusunnya ke dalam composition root.

---

### 3.4 Compose Feature DI

Tambahkan feature DI.

Contoh:

```dart
abstract final class Module1Di {
  static void register() {
    // reg feature di
    _feature1Di();
  }


  // feature
  static void _feature1Di() {
    // Datasources

    // Repositories

    // Usecases

    // Logic (Cubits/Blocs)
  }
}
```

### 3.5 Compose Module DI

Tambahkan module DI.

Contoh:

```dart
Future<void> initDI() async {
  ...
  Module1Di.register();
}
```

---

### 3.6 Run Application

Verifikasi bahwa feature dapat berjalan.



## Solo Developer Workflow

Untuk solo developer disarankan menggunakan iterasi kecil.

Contoh:

```text
Module
↓
Feature
↓
Slice
↓
Compose
↓
Test
↓
Repeat
```

Atau:

```text
1 Module
↓
Compose
↓
Test
↓
Next Module
```

Dengan pendekatan ini feedback loop menjadi lebih cepat.



## Team Workflow

Untuk tim besar.

Contoh:

```text
Team A
→ Finance Module

Team B
→ Product Module

Team C
→ Subscription Module
```

Masing-masing tim dapat menggunakan:

```text
module_app
```

Setiap tim membuat `module_app` sendiri. App tersebut hanya menjadi implementasi untuk satu module saat testing lokal.

Setelah module stabil:

```text
Module
↓
Merge
↓
Compose
↓
Main Apps Integration
```



## Golden Rule

Jangan mulai dari UI.

Jangan mulai dari API.

Jangan mulai dari folder.

Mulailah dari:

```text
Requirement
↓
Module
↓
Feature
↓
Alur Fitur
↓
Use Case dan Sequence
↓
Slice fitur terkait
↓
Komposisi App
↓
Implementasi dan pengujian
```

Ikuti aturan masing-masing layer, sequence, dan slice. App mengorkestrasi bagian-bagian yang berkaitan.
