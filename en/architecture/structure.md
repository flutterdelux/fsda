# Structure

This document is the global structure map of FSDA.

Detailed rules are covered in dedicated documents such as [dependency rules](dependency-rules.md), [sequence patterns](sequence-pattern.md), [naming conventions](../conventions/naming-conventions.md), and [layer docs](layers/domain-layer.md).

This document explains:

* Workspace Structure
* App Structure
* Module Structure
* Feature Structure
* Layer Structure
* Feature Slice Structure
* Shared Structure

If a rule conflicts with detailed docs, detailed docs take precedence.

&nbsp;

## Workspace Structure

```text
root-workspace/
├── apps/
├── modules/
└── packages/
```

### 1. apps/

Contains applications that compose modules and packages.

Example:

```text
apps/
└── demo/
```

### 2. modules/

Contains business modules. Module is the primary business boundary in the system.

Example:

```text
modules/
├── inbox/
├── finance/
├── task/
└── product/
```

### 3. packages/

Contains shared packages. Packages do not contain business features.

Packages contain reusable components used by all applications.

Example:

```text
packages/
├── app_core/
├── infra_.../
├── app_l10n/
└── app_ui/
```

&nbsp;

## App Structure

App is the application composition root.

App responsibilities:

* bootstrap application
* configure dependencies
* configure routing
* configure MaterialApp
* compose modules
* provide global state

```text
lib/
├── main.dart
├── app/
├── core/
└── modules/
```

### 1. main.dart

Application entry point.

Typical responsibilities:

* WidgetsFlutterBinding.ensureInitialized()
* logging initialization
* database initialization
* dependency initialization
* runApp()

### 2. app/

Contains app bootstrap.

```text
app/
├── app_router.dart
├── main_app.dart
├── startup.dart
└── dashboard/
```

- app_router.dart: composes all module routes
- main_app.dart: configures root widget
- startup.dart: splash/initial loading surface
- dashboard/: main app shell UI for module entry points

### 3. core/

Contains application technical needs.

```text
core/
├── constants/
│   ├── app_config.dart
│   ├── app_assets.dart
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

Contains module composition adapters. Each module has:

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
│               └── <page>.dart
└── <module>/
```

App page can represent single-slice page or aggregate page.

&nbsp;

## Module Structure

Module is the primary business boundary.

Examples:

```text
attendance
finance
travel
inbox
```

Structure:

```text
modules/
├── <module>/
│   ├── analysis_options.yaml
│   ├── build.yaml
│   ├── l10n.yaml
│   ├── pubspec.yaml
│   └── lib/
│       ├── <module>.dart
│       ├── l10n/
│       │   ├── <module>_en.arb
│       │   └── <module>_id.arb
│       └── src/
│           ├── features/
│           ├── generated/
│           └── shared/
│               ├── data/
│               │   └── errors/
│               │       └── <module>_exception.dart
│               ├── domain/
│               │   └── errors/
│               │       └── <module>_failure.dart
│               ├── logic/
│               └── ui/
│                   └── extensions/
│                       └── <module>_failure_x.dart
└── <module>/
```

Each module is an independent Flutter package.

In current baseline, modules commonly depend on:

* `app_core` for shared contracts/abstractions
* `app_l10n` for shared localization
* `app_ui` for shared UI standards

Technical details for package dependencies, Freezed, json_serializable, build.yaml, and l10n.yaml are covered in [Development Workflow](../guides/development-workflow.md).

&nbsp;

## Feature Structure

Feature is a business capability within a module.

Example:

```text
attendance
wallet
city
inbox
```

Structure:

```text
features/
├── <feature>/
│   ├── <feature>_feature.dart
│   ├── data/
│   ├── domain/
│   ├── logic/
│   └── ui/
└── <feature>/
```

&nbsp;

## Layer Structure

Each feature uses four layers:

```text
data
domain
logic
ui
```

### 1. Data

Contains data-access implementation.

```text
data/
├── converters/
├── datasources/
├── dtos/
├── repositories/
├── requests/
└── responses/
```

### 2. Domain

Contains business contracts.

```text
domain/
├── entities/
├── enums/
├── params/
├── repositories/
└── usecases/
```

### 3. Logic

Contains state management.

```text
logic/
└── <feature_slice>/
    ├── ...state_management.dart
    └── ...state.dart
```

### 4. UI

Contains views and presentation components.

```text
ui/
└── <feature_slice>/
    ├── views/
    └── widgets/
```

&nbsp;

## Feature Slice Structure

Feature slice is the smallest implementation unit in FSDA.

Feature slice aligns with business use-case flow. In practice, slice folder emphasis is strongest in Logic and UI, while Data and Domain often use per-file methods and models.

```text
features/
└── <feature>/
    ├── <feature>_feature.dart
    ├── data/
    │   ├── converters/
    │   ├── datasources/
    │   │   ├── <feature>_remote_data_source.dart
    │   │   └── <feature>_remote_data_source_impl.dart
    │   ├── dtos/
    │   ├── repositories/
    │   │   └── <feature>_repository_impl.dart
    │   ├── requests/
    │   │   └── <feature>_<slice>_request.dart
    │   └── responses/
    │       └── <feature>_<slice>_response.dart
    ├── domain/
    │   ├── entities/
    │   ├── enums/
    │   ├── params/
    │   │   └── <feature>_<slice>_param.dart
    │   ├── repositories/
    │   │   └── <feature>_repository.dart
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
```

Detailed per-sequence references are available in blueprint docs and example projects.

&nbsp;

## Shared Structure

* Feature Shared: used by several slices in one feature

```text
feature/
└── shared/
```

* Module Shared: used by several features in one module

```text
module/
├── features/
└── shared/
    ├── data/errors/<module>_exception.dart
    ├── domain/errors/<module>_failure.dart
    └── ui/extensions/<module>_failure_x.dart
```

Module-scoped Failure, Exception, and FailureX are placed in module shared for reuse across all features in the same module.

* App Shared: used by several composed modules in one app

```text
lib/
├── app/
├── core/
│   └── extensions/ => shared extensions
│       └── ... 
└── modules/
```

or

```text
lib/
├── app/
├── core/
├── modules/
└── shared/
```

First pattern is generally preferred for app shared concerns.

* Package Shared: used by all applications

```text
packages/
├── app_core/
├── infra_.../
├── app_l10n/
└── app_ui/
```

See [Structure Example](structure-example.md) for a concrete sample layout.
