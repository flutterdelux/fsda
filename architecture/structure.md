# Structure

This document is the global structure map of FSDA.

Detailed rules are still explained in specific documents, such as [dependency rules](dependency-rules.md), [sequence patterns](sequence-pattern.md), [naming conventions](../conventions/naming-conventions.md), and [layer docs](layers/domain-layer.md).

This document explains:

* Workspace Structure
* App Structure
* Module Structure
* Feature Structure
* Layer Structure
* Feature Slice Structure
* Shared Structure

This document helps to see the big picture of the project structure. If there is a conflict regarding detailed rules, the specific document discussing that concern is the primary reference.

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

Contains business modules. A module is the main business boundary in the system.

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

Packages only contain reusable components that can be used by all applications.

Example:

```text
packages/
├── app_core/
├── infra_.../
├── app_l10n/
└── app_ui/
```

## App Structure

The App is responsible for acting as the composition root of the application.

The App is tasked to:

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

The application entry point.

Example responsibilities:

* WidgetsFlutterBinding.ensureInitialized()
* Logging initialization
* Database initialization
* Dependency initialization
* runApp()

### 2. app/

Contains the application bootstrap.

```text
app/
├── app_router.dart
├── main_app.dart
├── startup.dart
└── dashboard/
```

- app_router.dart

    Arranges all module routes.

- main_app.dart

    Configures the root widget.

- startup.dart

  Usually used as:

    * Splash Screen
    * Initial Loading Screen

- dashboard/

    The Dashboard is the main UI shell of the application. The Dashboard is in the App Structure because it is responsible for arranging access to various modules.

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

Contains the technical needs of the application.

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

Contains module compositions. Each module has:

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
│               └── <page>.dart (compose UI & logic; can represent a single-slice or aggregate page)
└── <module>/
```

## Module Structure

A module is the primary business boundary.

Example:

```text
attendance
finance
travel
inbox
```

Structure:

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

Each module becomes an independent Flutter package, so baseline files like `build.yaml`, `l10n.yaml`, and dependencies for Freezed and serialization need to be prepared at the module level.

In the current Flutter baseline, modules generally also depend on the following shared packages:

* `app_core` for contracts and abstractions across apps and modules
* `app_l10n` for general localization across apps and modules
* `app_ui` for standard UI needs across apps and modules

Technical details like package dependencies, `Freezed`, `json_serializable`, `build.yaml`, and `l10n.yaml` are explained in [Development Workflow](../guides/development-workflow.md).

## Feature Structure

A feature is a business capability within a module.

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
├── <feature>/ (feature name)
│   ├── <feature>_feature.dart (feature barrel)
│   ├── data/
│   ├── domain/
│   ├── logic/
│   └── ui/
└── <feature>/
```

## Layer Structure

Each feature uses four layers:

```text
data
domain
logic
ui
```

### 1. Data

Contains data access implementations. Object modeling such as DTOs, Requests, and Responses must be consistent, maintainable, and in accordance with the baseline stack used.

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

Contains business contracts. Object modeling such as Entities and Params must be consistent, maintainable, and in accordance with the baseline stack used.

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

Contains state management.

```text
logic/
└── <feature_slice>/
    ├── ...state_management.dart
    └── ...state.dart
```

### 4. UI

Contains displays in the form of views and presentation components.

```text
ui/
└── <feature_slice>/
    ├── views/
    │   └── ..._view.dart
    └── widgets/
        └── ..._<widget>.dart
```

## Feature Slice Structure

A Feature Slice is the smallest implementation unit in FSDA.

This feature slice is directly proportional to the business use case flow. However, its folder structure implementation leans more towards Logic and UI. Meanwhile, implementations in other layers (Data & Domain) are directly created per file and also exist as methods.


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

For more details, refer to the documentation per sequence or check the example project.

All object modeling such as DTO, Entity, Request, Response, and Param are treated as contracts that must be easily maintainable in the long run. For the current Flutter baseline, implementation details like `Freezed`, `json_serializable`, and code generation configurations are explained in [Development Workflow](../guides/development-workflow.md).

## Shared Structure

* Feature Shared

Used by multiple slices within a single feature.

```text
feature/
└── shared/
```

* Module Shared

Used by multiple features within a single module.

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

Failures, Exceptions, and FailureX that are module-scoped are placed in the module shared so they can be used together by all features within the same module.

* App Shared

Used by several composed modules within a single application.

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

The primary reference is prioritized for the app shared. Because the folder name is not `shared` but rather a specific form of the shared itself, for example `extensions/`.

* Package Shared

Used by the entire application. All packages are shared because they can be used by all applications and serve as the main reference.

```text
packages/
├── app_core/
├── infra_.../
├── app_l10n/
└── app_ui/
```

A complete example of the structure can be seen in [Structure Example](structure-example.md).