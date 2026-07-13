# Structure Example

This document is illustrative, not normative.

For readability, this example focuses on core implementation structure and does not always repeat every module baseline file in full detail.

App page examples should be read as composition surfaces. In real projects, pages can be single-slice pages or aggregate pages.

## Example Workspace Tree

```text
fsda-base/
├── apps/
│   └── fsda_base/
│       ├── pubspec.yaml
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
│           │   ├── di/
│           │   │   ├── core_di.dart
│           │   │   ├── di.dart
│           │   │   ├── di_keys.dart
│           │   │   └── external_di.dart
│           │   ├── extensions/
│           │   ├── externals/
│           │   ├── mixins/
│           │   └── pages/
│           └── modules/
│               ├── attendance/
│               │   ├── attendance_di.dart
│               │   ├── attendance_route.dart
│               │   └── features/attendance/pages/attendance_list_page.dart
│               ├── finance/
│               │   ├── finance_di.dart
│               │   ├── finance_route.dart
│               │   └── features/wallet/pages/wallet_detail_page.dart
│               ├── product/
│               │   ├── product_di.dart
│               │   ├── product_route.dart
│               │   └── features/product/pages/product_detail_page.dart
│               └── task/
│                   ├── task_di.dart
│                   ├── task_route.dart
│                   └── features/task/pages/task_create_page.dart
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

## Reading This Example

Use this example to understand where artifacts typically live.

When implementation details differ between sequences, the sequence blueprint is the source of truth.

## Sequence-Oriented Reminder

Even with a clear folder structure, implementation should still begin with:

```text
requirement
→ module
→ feature
→ slice
→ sequence
→ blueprint
→ implementation
```

## Related Documents

- [Structure](structure.md)
- [Dependency Rules](dependency-rules.md)
- [Sequence Pattern](sequence-pattern.md)
- [Naming Conventions](../conventions/naming-conventions.md)
- [Development Workflow](../guides/development-workflow.md)
