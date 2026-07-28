# Development Workflow

This document describes the recommended application development workflow using FSDA.

The goals of this workflow are to:

- Maintain development consistency.
- Ensure implementation follows the correct sequence.
- Improve project scalability.
- Facilitate team collaboration.
- Simplify automation and code generation.



## Phase 1 — Workspace Setup

This phase is performed once at the beginning of a project.

---

### 1.1 Create Workspace

Create the workspace root.

Example:

```text
workspace_name/
├── apps/
├── modules/
└── packages/
```

---

### 1.2 Create Shared Packages

Create the foundation packages.

Minimum structure:

```text
packages/
├── app_core
├── app_l10n
├── app_ui
└── infra_...
```

`infra_...` packages contain small infrastructure implementations that are frequently shared across the workspace. Each concern should be extracted into its own infrastructure package.

Example:

```text
packages/
├── infra_http
├── infra_hive
├── infra_firebase
├── infra_supabase
└── infra_storage
```

---

### 1.3 Create App Projects

Create the application projects.

Example:

```text
apps/
├── customer_app
└── admin_app
```

---

### 1.4 Setup App Foundation

Create the application's base structure.

Example:

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

### 1.5 Choose Infrastructure

Decide which technologies will be used.

Example:

| Concern | Technology |
|---------|------------|
| API Client | HTTP |
| Local Storage | Hive |
| Database | Sqflite |
| BaaS | Supabase |
| Authentication | Firebase Auth |

---

### 1.6 Compose Infrastructure

Register all technical dependencies.

Example:

```text
core/
├── di/
│   ├── external_di.dart
│   └── core_di.dart
└── externals/
```

Example:

```dart
Future<void> externalDI() async {
  getIt.registerLazySingleton<Client>(
    () => Client(),
  );
}
```

Infrastructure may evolve throughout the lifetime of the project as new technologies are introduced or existing ones are replaced.

---

## Phase 2 — Module Development

This phase is repeated throughout the development lifecycle.

---

### 2.1 Identify Requirements

Translate business requirements into feature slices.

Example:

| Requirement | Module | Feature | Slice |
|-------------|---------|---------|-------|
| Delete wallet | finance | wallet | delete |
| Create task | task | task | create |
| Product detail | product | product | detail |
| Watch payment status | subscription | payment | status |

---

### 2.2 Determine the Sequence

Choose the sequence that matches the implementation.

| Slice | Sequence | Code |
|--------|----------|------|
| delete | Mutation + Param | Mp |
| create | Mutation + Return + Param | Mrp |
| detail | Retrieval + Param | Rp |
| status | Retrieval + Stream + Param | Rsp |

---

### 2.3 Create the Module Skeleton

If the module does not yet exist, create its baseline structure.

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

The baseline module structure is important because every module is an independent Flutter package.

If a module displays user-facing text, it should maintain its own localization resources. The `app_l10n` package should remain responsible for common localization shared across applications and modules.

Recommended `l10n.yaml` baseline:

```yaml
arb-dir: lib/l10n
template-arb-file: <module>_en.arb
output-localization-file: <module>_localizations.dart
output-class: <Module>Localizations
output-dir: lib/src/generated
untranslated-messages-file: missing_keys.json
```

The module's `build.yaml` can also be used to limit code generation to the module boundary.

Example:

```yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          field_rename: snake
          explicit_to_json: true
```

Each module should also include the dependencies required for object modeling and code generation.

Recommended baseline packages:

**dependencies**

- `freezed_annotation`
- `json_annotation`

**dev_dependencies**

- `build_runner`
- `freezed`
- `json_serializable`

Within the current Flutter ecosystem, object models such as DTOs, Entities, Requests, Responses, Params, and States are recommended to be implemented using **Freezed**.

For serializable objects, use **json_serializable** with the baseline `build.yaml` configuration shown above.

Modules will typically also depend on the following shared packages:

- `app_core` for contracts and abstractions shared across applications and modules.
- `app_l10n` for shared localization.
- `app_ui` for reusable UI components and design system resources.

---

### 2.4 Create Shared Module Resources

Creation order:

```text
Failure
↓
Exception
↓
FailureX
```

Because:

```text
Failure
→ defines the canonical business failure
→ becomes the reference for Exception
→ becomes the reference for FailureX

FailureX
→ translates business failures into presentation-layer concerns
```

---

### 2.5 Create the Feature Skeleton

If the feature does not yet exist:

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

### 2.6 Create the Slice Skeleton

Create the slice directory according to the selected sequence.

Examples:

```text
detail/
```

or

```text
create/
```

---

### 2.7 Build the Domain Layer

Recommended order:

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

### 2.8 Build the Data Layer

If the domain defines enums:

```text
Enum
↓
Converter
```

Then continue with:

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

### 2.9 Build the Logic Layer

Recommended order:

```text
State
↓
Cubit / Bloc / Controller
```

---

### 2.10 Build the UI Layer

Recommended order:

```text
View
↓
Widgets
↓
Shared UI
```

---

### 2.11 Validate Against the Blueprint

Compare the implementation against the blueprint sequence.

Verify that the following are consistent with the blueprint:

```text
folder
file
class
dependency
flow
```

---

## Phase 3 — App Composition

This phase integrates modules into the application.

---

### 3.1 Create the App Composition Page

Compose the Logic and UI at the application layer.

Example:

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

A page may represent a single primary slice or aggregate multiple slices into a single surface.

Logic may be registered at the page scope or a higher scope, such as the root/global scope, depending on lifecycle and composition requirements.

Example:

```text
ProductDetailPage
├── BlocProvider
└── ProductDetailView
```

---

### 3.2 Compose Module Routes

Register the module routes.

Example:

```dart
abstract final class Module1Route {
  RouteBase get base => ...
}
```

```dart
routes: [
  ...,
  Module1Route.base,
],
```

---

### 3.3 Compose Localization

Compose shared localization from `app_l10n` together with the localization resources provided by the modules used by the application.

Example:

```dart
MaterialApp(
  localizationsDelegates: [
    AppLocalizations.delegate,
    ProductLocalizations.delegate,
    FinanceLocalizations.delegate,
  ],
)
```

At this stage, the application decides which localization resources are actually required and assembles them within the composition root.

---

### 3.4 Compose Feature DI

Register feature dependencies.

Example:

```dart
abstract final class Module1Di {
  static void register() {
    _feature1Di();
  }

  static void _feature1Di() {
    // Datasources

    // Repositories

    // Use Cases

    // Logic (Cubits / Blocs)
  }
}
```

---

### 3.5 Compose Module DI

Register the module dependency injection.

Example:

```dart
Future<void> initDI() async {
  ...
  Module1Di.register();
}
```

---

### 3.6 Run the Application

Verify that the feature works correctly.



## Solo Developer Workflow

For solo development, small iterative cycles are recommended.

Example:

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

Or:

```text
One Module
↓
Compose
↓
Test
↓
Next Module
```

This approach shortens the feedback loop and allows issues to be detected earlier.



## Team Workflow

For larger teams.

Example:

```text
Team A
→ Finance Module

Team B
→ Product Module

Team C
→ Subscription Module
```

Each team may maintain its own:

```text
module_app
```

Each `module_app` serves as a dedicated application for developing and testing a single module in isolation.

Once the module is stable:

```text
Module
↓
Merge
↓
Compose
↓
Integrate into Main Applications
```


## Golden Rule

Do not start with the UI.

Do not start with the API.

Do not start with the folder structure.

Always start from:

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

The **Sequence** and the **Blueprint** are the single source of truth for every implementation.