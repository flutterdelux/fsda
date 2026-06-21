# Development Workflow

Dokumen ini menjelaskan alur pengembangan aplikasi menggunakan FSDA.

Tujuan workflow ini adalah:

* Menjaga konsistensi pengembangan.
* Memastikan implementasi mengikuti sequence yang benar.
* Mempermudah scaling project.
* Mempermudah kolaborasi tim.
* Mempermudah automation dan code generation.

&nbsp;

## Phase 1 — Workspace Setup

Phase ini dilakukan satu kali pada awal project.

&nbsp;

### 1.1 Create Workspace

Buat root workspace.

Contoh:

```text
workspace_name/
├── apps/
├── modules/
└── packages/
```

&nbsp;

### 1.2 Create Shared Packages

Buat package fondasi.

Minimal:

```text
packages/
├── app_core
├── app_l10n
├── app_ui
└── app_infrastructure
```

`app_infrastructure` masih dapat berubah sesuai kebutuhan project. Ia bisa tetap menjadi package gabungan untuk implementasi kecil yang sering dipakai bersama, atau dipecah menjadi package yang lebih spesifik jika boundary teknologinya memang perlu dipisahkan sejak awal.

Jika diperlukan dapat dipecah menjadi package infrastructure yang lebih spesifik.

Contoh:

```text
packages/
├── infra_http
├── infra_dio
├── infra_firebase
├── infra_supabase
└── infra_storage
```

&nbsp;

### 1.3 Create App Project

Buat project aplikasi.

Contoh:

```text
apps/
├── customer_app
└── admin_app
```

&nbsp;

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

&nbsp;

### 1.5 Determine Infrastructure

Tentukan teknologi yang digunakan.

Contoh:

| Concern        | Technology    |
| -------------- | ------------- |
| ApiClient      | Dio           |
| Local Storage  | Hive          |
| Database       | Sqflite       |
| BaaS           | Supabase      |
| Authentication | Firebase Auth |

&nbsp;

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
  getIt.registerLazySingleton<Dio>(
    () => Dio(),
  );
}
```

Infrastructure dapat ditambah atau diubah kembali selama pengembangan berlangsung.

&nbsp;

## Phase 2 — Module Development

Phase ini dilakukan berulang selama pengembangan aplikasi.

&nbsp;

### 2.1 Identify Requirement

Ubah requirement menjadi feature slice.

Contoh:

| Requirement          | Module       | Feature | Slice  |
| -------------------- | ------------ | ------- | ------ |
| Delete wallet        | finance      | wallet  | delete |
| Create task          | task         | task    | create |
| Product detail       | product      | product | detail |
| Watch payment status | subscription | payment | status |

&nbsp;

### 2.2 Determine Sequence

Tentukan sequence yang sesuai.

| Slice  | Sequence                     | Code |
| ------ | ---------------------------- | ---- |
| delete | Mutation + Param             | Mp   |
| create | Mutation + Return + Param    | Mrp  | 
| detail | Retrieval + Param            | Rp   |
| status | Retrieval + Stream + Param   | Rsp  |

&nbsp;

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

* `freezed_annotation`
* `json_annotation`
* `build_runner`
* `freezed`
* `json_serializable`

Dalam baseline Flutter saat ini, object modeling seperti DTO, Entity, Request, Response, Param, dan State direkomendasikan menggunakan `Freezed`. Untuk object yang membutuhkan serialisasi, gunakan `json_serializable` dengan baseline `build.yaml` di atas.

Selain dependency teknis tersebut, module umumnya juga bergantung pada shared package berikut:

* `app_core` untuk contract dan abstraction lintas app maupun module
* `app_l10n` untuk localization umum lintas app maupun module
* `app_ui` untuk kebutuhan standard UI lintas app maupun module

&nbsp;

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

&nbsp;

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

&nbsp;

### 2.6 Create Slice Skeleton

Buat struktur slice sesuai sequence.

Contoh:

```text
detail/
```

atau

```text
create/
```

&nbsp;

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

&nbsp;

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

&nbsp;

### 2.9 Create Logic

Urutan:

```text
State
↓
Cubit / Bloc / Controller
```

&nbsp;

### 2.10 Create UI

Urutan:

```text
View
↓
Widgets
↓
Shared UI
```

&nbsp;

### 2.11 Validate Against Blueprint

Bandingkan implementasi dengan blueprint sequence.

Pastikan:

```text
folder
file
class
dependency
flow
```

sesuai dengan blueprint.

&nbsp;

## Phase 3 — App Composition

Phase ini menghubungkan module ke aplikasi.

&nbsp;

### 3.1 Create App Composition Page

Compose Logic dan UI pada App layer.

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

Logic dapat diregistrasikan di page scope atau scope yang lebih tinggi seperti root/global scope sesuai kebutuhan lifecycle dan composition.

Contoh:

```text
ProductDetailPage
├── BlocProvider
└── ProductDetailView
```

&nbsp;

### 3.2 Compose Module Route

Tambahkan route module.

Contoh:

```dart
class Module1Route {
  RouteBase get base => ...
}
```

```dart
routes: [
  ...,
  Module1Route.base,
],
```

&nbsp;

### 3.3 Compose Localization

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

&nbsp;

### 3.4 Compose Feature DI

Tambahkan feature DI.

Contoh:

```dart
Future<void> module1DI() async {
  _feature1DI();
  ...
}

void _feature1DI() {
  // Datasources

  // Repositories

  // Usecases

  // Logics
}
```

### 3.5 Compose Module DI

Tambahkan module DI.

Contoh:

```dart
Future<void> initDI() async {
  ...
  await module1DI();
}
```

&nbsp;

### 3.6 Run Application

Verifikasi bahwa feature dapat berjalan.

&nbsp;

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

&nbsp;

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

&nbsp;

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
Slice
↓
Sequence
↓
Blueprint
↓
Implementation
```

Sequence dan Blueprint adalah sumber kebenaran implementasi.
