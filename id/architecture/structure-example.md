# Structure Example

Dokumen ini bersifat ilustratif, bukan normatif.

Untuk kemudahan pembacaan, contoh ini berfokus pada struktur implementasi inti dan tidak selalu mengulang setiap file dasar modul secara detail.

Contoh page pada App juga perlu dibaca sebagai ilustrasi surface page. Dalam praktiknya, page dapat berupa single-slice page maupun aggregate page sesuai kebutuhan composition aplikasi.

## Example Workspace Tree

```text
fsda-base/
├── apps/
│   └── fsda_base/
│       ├── analysis_options.yaml
│       ├── flutter_launcher_icons.yaml
│       ├── package_rename_config.yaml
│       ├── pubspec.yaml
│       ├── assets/
│       │   └── images/
│       │       └── launcher-icon-foreground.png
│       │       └── launcher-icon.png
│       │       └── logo.png
│       └── lib/
│           ├── main.dart
│           ├── app/
│           │   ├── app_router.dart
│           │   ├── main_app.dart
│           │   ├── startup.dart
│           │   └── dashboard/
│           │       ├── dashboard_route.dart
│           │       ├── pages/
│           │       │   ├── dashboard.dart
│           │       │   └── home_page.dart
│           │       └── widgets/
│           │           └── bottom_nav_bar.dart
│           ├── core/
│           │   ├── constants/
│           │   │   ├── app_assets.dart
│           │   │   └── app_external_links.dart
│           │   ├── di/
│           │   │   ├── core_di.dart
│           │   │   ├── di.dart
│           │   │   ├── di_keys.dart
│           │   │   └── external_di.dart
│           │   ├── extensions/
│           │   │   └── failure_x.dart
│           │   ├── externals/
│           │   │   ├── fdelux_mock_config.dart
│           │   │   ├── logging_config.dart
│           │   │   └── network_timeout_config.dart
│           │   ├── mixins/
│           │   │   └── page_provider_mixin.dart
│           │   └── pages/
│           │       ├── invalid_argument_page.dart
│           │       └── not_found_page.dart
│           └── modules/
│               ├── attendance/
│               │   ├── attendance_di.dart
│               │   ├── attendance_route.dart
│               │   └── features/attendance/pages/attendance_list_page.dart
│               └── finance/
│                   └── ... (same compose module pattern)
├── modules/
│   ├── attendance/
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── l10n.yaml
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── attendance.dart
│   │       ├── l10n/
│   │       │   ├── attendance_en.arb
│   │       │   └── attendance_id.arb
│   │       └── src/
│   │           ├── features/
│   │           │   └── attendance/
│   │           │       ├── attendance_feature.dart
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   ├── datasources/
│   │           │       │   ├── dtos/
│   │           │       │   ├── repositories/
│   │           │       │   ├── requests/
│   │           │       │   └── responses/
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   ├── enums/
│   │           │       │   ├── params/
│   │           │       │   ├── repositories/
│   │           │       │   └── usecases/
│   │           │       ├── logic/
│   │           │       │   └── list/
│   │           │       └── ui/
│   │           │           ├── list/
│   │           │           │   ├── views/
│   │           │           │   └── widgets/
│   │           │           └── extensions/
│   │           └── shared/
│   │               ├── data/errors/attendance_exception.dart
│   │               ├── domain/errors/attendance_failure.dart
│   │               └── ui/extensions/attendance_failure_x.dart
│   └── finance/
│       └── ... (same module pattern)
└── packages/
    ├── app_core/
    ├── app_l10n/
    ├── app_ui/
    └── infra_.../
```