# Structure

Dokumen ini merupakan peta struktur global FSDA.

Detail rule tetap dijelaskan pada dokumen khusus, seperti dependency-rules.md, sequence-pattern.md, naming-conventions.md, dan layer docs.

Dokumen ini menjelaskan:

* Workspace Structure
* App Structure
* Module Structure
* Feature Structure
* Layer Structure
* Feature Slice Structure
* Shared Structure

Dokumen ini membantu melihat gambaran besar struktur proyek. Jika terjadi konflik pada aturan detail, maka dokumen khusus yang membahas concern tersebut menjadi acuan utama.

&nbsp;

## Workspace Structure

```text
root-workspace/
├── apps/
├── modules/
└── packages/
```

### 1. apps/

Berisi aplikasi yang menyusun modules dan packages.

Contoh:

```text
apps/
└── demo/
```

### 2. modules/

Berisi business modules. Module merupakan boundary bisnis utama dalam sistem.

Contoh:

```text
modules/
├── inbox/
├── finance/
├── task/
└── product/
```

### 3. packages/

Berisi shared packages. Package tidak mengandung business feature.

Package hanya berisi reusable component yang dapat digunakan oleh seluruh aplikasi.

Contoh:

```text
packages/
├── app_core/
├── app_infrastructure/
├── app_l10n/
└── app_ui/
```

&nbsp;

## App Structure

App bertanggung jawab sebagai composition root aplikasi.

App bertugas untuk:

* Bootstrap application
* Configure dependencies
* Configure routing
* Configure MaterialApp
* Compose modules
* Provide global state

```text
lib/
├── main.dart
├── app/
├── core/
└── modules/
```

### 1. main.dart

Entry point aplikasi.

Contoh tanggung jawab:

* WidgetsFlutterBinding.ensureInitialized()
* Logging initialization
* Database initialization
* Dependency initialization
* runApp()

### 2. app/

Berisi composition root aplikasi.

```text
app/
├── app_router.dart
├── main_app.dart
├── startup.dart
└── dashboard/
```

- app_router.dart

    Menyusun seluruh route module.

- main_app.dart

    Mengonfigurasi root widget.

- startup.dart

  Biasanya digunakan sebagai:

    * Splash Screen
    * Initial Loading Screen

- dashboard/

    Dashboard merupakan shell UI utama aplikasi. Dashboard berada pada App Structure karena bertugas menyusun akses menuju berbagai module.

    ```text
    dashboard/
    ├── dashboard_route.dart
    ├── pages/
    │   ├── dashboard.dart
    │   └── home_page.dart
    └── widgets/
        └── bottom_nav_bar.dart
    ```

### 3. core/

Berisi kebutuhan teknis aplikasi.

```text
core/
├── constants/
│   ├── app_config.dart
│   ├── app_constants.dart
│   └── app_external_links.dart
├── di/
│   ├── core_di.dart
│   ├── di.dart
│   ├── di_keys.dart
│   └── external_di.dart
├── extensions/
│   └── failure_x.dart
├── externals/
│   ├── fdelux_mock_config.dart
│   ├── logging_config.dart
│   ├── network_timeout_config.dart
│   ├── owm_config.dart
│   ├── sqflite_config.dart
│   └── supabase_config.dart
├── mixins/
│   └── page_provider_mixin.dart
└── pages/
    ├── invalid_argument_page.dart
    └── not_found_page.dart
```

### 4. modules/

Berisi compose module. Setiap module memiliki:

```text
<module>_di.dart
<module>_route.dart
```
    
```text
modules/
├── <module>/
│   ├── <module>_di.dart
│   ├── <module>_route.dart
│   └── features/
│       └── <feature>/
│           └── pages/
│               └── <page>.dart (compose UI & logic; dapat merepresentasikan single-slice maupun aggregate page)
└── <module>/
```

&nbsp;

## Module Structure

Module merupakan business boundary utama.

Contoh:

```text
attendance
finance
travel
inbox
```

Struktur:

```text
modules/
├── <module>/ (module name)
│   ├── analysis_options.yaml
│   ├── build.yaml
│   ├── l10n.yaml
│   ├── pubspec.yaml
│   └── lib/
│       ├── <module>.dart (module barrel)
│       ├── l10n/
│       │   ├── <module>_en.arb
│       │   └── <module>_id.arb
│       └── src/
│           ├── features/
│           ├── generated/
│           │   └── <module>_localizations.dart
│           └── shared/
│               ├── data/
│               │   └── errors/
│               │       └── <module>_exception.dart (module exception)
│               ├── domain/
│               │   └── errors/
│               │       └── <module>_failure.dart (module failure)
│               ├── logic/
│               └── ui/
│                   └── extensions/
│                       └── <module>_failure_x.dart (extension for module failure)
└── <module>/
```

Setiap module menjadi Flutter package mandiri, sehingga baseline file seperti `build.yaml`, `l10n.yaml`, dan dependency untuk Freezed serta serialization perlu disiapkan pada level module.

Dalam baseline Flutter saat ini, module umumnya juga bergantung pada shared package berikut:

* `app_core` untuk contract dan abstraction lintas app maupun module
* `app_l10n` untuk localization umum lintas app maupun module
* `app_ui` untuk kebutuhan standard UI lintas app maupun module

Detail teknis seperti package dependency, `Freezed`, `json_serializable`, `build.yaml`, dan `l10n.yaml` dijelaskan pada [Development Workflow](../guides/development-workflow.md).

&nbsp;

## Feature Structure

Feature merupakan business capability dalam suatu module.

Contoh:

```text
attendance
wallet
city
inbox
```

Struktur:

```text
features/
├── <feature>/ (feature name)
│   ├── <feature>_feature.dart (feature barrel)
│   ├── data/
│   ├── domain/
│   ├── logic/
│   └── ui/
└── <feature>/
```

&nbsp;

## Layer Structure

Setiap feature menggunakan empat layer:

```text
data
domain
logic
ui
```

### 1. Data

Berisi implementasi akses data. Object modeling seperti DTO, Request, dan Response harus konsisten, mudah dirawat, dan sesuai dengan baseline stack yang dipakai.

```text
data/
├── converters/
│   └── ..._converter.dart
├── datasources/
│   └── ..._data_source.dart
├── dtos/
│   └── ..._dto.dart
├── repositories/
│   └── ..._repository_impl.dart
├── requests/
│   └── ..._request.dart
└── responses/
    └── ..._response.dart
```

### 2. Domain

Berisi business contract. Object modeling seperti Entity dan Param harus konsisten, mudah dirawat, dan sesuai dengan baseline stack yang dipakai.

```text
domain/
├── entities/
│   └── ..._entity.dart
├── enums/
│   └── ..._enum.dart
├── params/
│   └── ..._param.dart
├── repositories/
│   └── ..._repository.dart
└── usecases/
    └── ..._use_case.dart
```

### 3. Logic

Berisi state management.

```text
logic/
└── <feature_slice>/
    ├── ...state_management.dart
    └── ...state.dart
```

### 4. UI

Berisi tampilan dalam bentuk view dan komponen presentasi.

```text
ui/
└── <feature_slice>/
    ├── views/
    │   └── ..._view.dart
    └── widgets/
        └── ..._<widget>.dart
```

&nbsp;

## Feature Slice Structure

Feature Slice merupakan unit implementasi terkecil dalam FSDA.

Feature slice ini berbanding lurus dengan flow use case bisnis. Namun implementasi struktur folder nya lebih ke Logic dan UI. Sedangkan untuk implementasi di layer lain (Data & Domain) langsung dibuat per file dan ada juga sebagai method.


```text
features/
└── <feature>/
    ├── <feature>_feature.dart
    ├── data/
    │   ├── converters/
    │   │   └── <...>_converter.dart
    │   ├── datasources/
    │   │   ├── <feature>_remote_data_source.dart (slice method)
    │   │   └── <feature>_remote_data_source_impl.dart (slice method)
    │   ├── dtos/
    │   │   └── <feature>_dto.dart
    │   ├── repositories/
    │   │   └── <feature>_repository_impl.dart (slice method)
    │   ├── requests/
    │   │   └── <feature>_<slice>_request.dart
    │   └── responses/
    │       └── <feature>_<slice>_response.dart
    ├── domain/
    │   ├── entities/
    │   │   └── <...>_entity.dart
    │   ├── enums/
    │   │   └── <...>_enum.dart
    │   ├── params/
    │   │   └── <feature>_<slice>_param.dart
    │   ├── repositories/
    │   │   └── <feature>_repository.dart (slice method)
    │   └── usecases/
    │       └── <feature>_<slice>_use_case.dart
    ├── logic/
    │   └── <slice>/
    │       ├── <feature>_<slice>_cubit.dart
    │       └── <feature>_<slice>_state.dart
    └── ui/
        ├── <slice>/
        │   ├── views/
        │   │   └── <feature>_<slice>_view.dart
        │   └── widgets/
        │       ├── <feature>_<slice>_button.dart
        │       └── <feature>_<slice>_form.dart
        └── shared/
            └── widgets/
                ├── <feature>_<column>_field.dart
                └── <feature>_<column>_field.dart
```

Untuk lebih detailnya bisa dilihat pada dokumentasi per sequence atau cek contoh project.

Seluruh object modeling seperti DTO, Entity, Request, Response, dan Param diperlakukan sebagai contract yang harus mudah dirawat dalam jangka panjang. Untuk baseline Flutter saat ini, detail implementasi seperti `Freezed`, `json_serializable`, dan konfigurasi code generation dijelaskan pada [Development Workflow](../guides/development-workflow.md).

&nbsp;

## Shared Structure

* Feature Shared

Digunakan oleh beberapa slice dalam satu feature.

```text
feature/
└── shared/
```

* Module Shared

Digunakan oleh beberapa feature dalam satu module.

```text
module/
├── features/
│   └── feature1/
└── shared/
    ├── data/
    │   └── errors/
    │       └── <module>_exception.dart
    ├── domain/
    │   └── errors/
    │       └── <module>_failure.dart
    ├── logic/
    └── ui/
        └── extensions/
            └── <module>_failure_x.dart
```

Failure, Exception, dan FailureX yang bersifat module scope diletakkan pada shared module agar dapat dipakai bersama oleh seluruh feature di dalam module yang sama.

* App Shared

Digunakan oleh beberapa compose module dalam satu aplikasi.

```text
lib/
├── app/
├── core/
│   └── shared/
│       └── ... 
└── modules/
```

atau

```text
lib/
├── app/
├── core/ 
├── modules/
└── shared/
```

Referensi pertama diutamakan pada app shared. Karena nama folder nya bukan `shared` melainkan bentuk spesifik dari shared itu sendiri, misalnya extensions/.

* Package Shared

Digunakan oleh seluruh aplikasi. Semua package merupakan shared karena dapat digunakan oleh seluruh aplikasi dan menjadi referensi utama.

```text
packages/
├── app_core/
├── app_infrastructure/
├── app_l10n/
└── app_ui/
```

Contoh lengkap struktur bisa dilihat pada [Structure Example](structure-example.md).