# Development Workflow

This document explains application development flow using FSDA.

Workflow goals:

* keep development consistent
* ensure implementation follows correct sequence
* support project scaling
* simplify team collaboration
* support automation and code generation

&nbsp;

## Phase 1 - Workspace Setup

This phase is usually done once at project start.

### 1.1 Create Workspace

Create workspace root.

```text
workspace_name/
├── apps/
├── modules/
└── packages/
```

### 1.2 Create Shared Packages

Create foundation packages.

Minimum baseline:

```text
packages/
├── app_core
├── app_l10n
├── app_ui
└── infra_...
```

Split `infra_...` into focused infrastructure packages.

Example:

```text
packages/
├── infra_http
├── infra_dio
├── infra_firebase
├── infra_supabase
└── infra_storage
```

### 1.3 Create App Project

Create application projects.

```text
apps/
├── customer_app
└── admin_app
```

### 1.4 Setup App Foundation

Setup baseline app structure.

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
│   ├── externals/
│   ├── mixins/
│   └── pages/
└── modules/
```

### 1.5 Determine Infrastructure

Choose technology stack.

| Concern        | Technology    |
| -------------- | ------------- |
| ApiClient      | Dio           |
| Local Storage  | Hive          |
| Database       | Sqflite       |
| BaaS           | Supabase      |
| Authentication | Firebase Auth |

### 1.6 Compose Infrastructure

Register technical dependencies.

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
  getIt.registerLazySingleton<Dio>(() => Dio());
}
```

Infrastructure can be updated as development evolves.

&nbsp;

## Phase 2 - Module Development

This phase is repeated during feature development.

### 2.1 Identify Requirement

Map requirement into feature slice.

| Requirement          | Module       | Feature | Slice  |
| -------------------- | ------------ | ------- | ------ |
| Delete wallet        | finance      | wallet  | delete |
| Create task          | task         | task    | create |
| Product detail       | product      | product | detail |
| Watch payment status | subscription | payment | status |

### 2.2 Determine Sequence

Choose matching sequence.

| Slice  | Sequence                   | Code |
| ------ | -------------------------- | ---- |
| delete | Mutation + Param           | Mp   |
| create | Mutation + Return + Param  | Mrp  |
| detail | Retrieval + Param          | Rp   |
| status | Retrieval + Stream + Param | Rsp  |

### 2.3 Create Module Skeleton

If module does not exist, prepare baseline module:

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
      ├── data/errors/module1_exception.dart
      ├── domain/errors/module1_failure.dart
      ├── logic/
      └── ui/extensions/module1_failure_x.dart
```

If module displays user-facing text, module should own module-specific localization. `app_l10n` remains for cross-module shared text.

Baseline module tools commonly include:

* `freezed_annotation`
* `json_annotation`
* `build_runner`
* `freezed`
* `json_serializable`

### 2.4 Create Module Shared Resources

Recommended creation order:

```text
Failure
↓
Exception
↓
FailureX
```

Reason:

```text
Failure
→ reference for Exception
→ reference for FailureX

FailureX
→ translates Failure to presentation needs
```

### 2.5 Create Feature Skeleton

If feature does not exist:

```text
feature1/
├── feature1_feature.dart
├── data/
├── domain/
├── logic/
└── ui/
```

### 2.6 Create Slice Skeleton

Create slice structure by sequence.

Examples:

```text
detail/
```

or

```text
create/
```

### 2.7 Create Domain

Order:

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

### 2.8 Create Data

If domain uses enum:

```text
Enum
↓
Converter
```

Then:

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

### 2.9 Create Logic

Order:

```text
State
↓
Cubit / Bloc / Controller
```

### 2.10 Create UI

Order:

```text
View
↓
Widgets
↓
Shared UI
```

### 2.11 Validate Against Blueprint

Compare implementation against sequence blueprint.

Verify:

```text
folder
file
class
dependency
flow
```

&nbsp;

## Phase 3 - App Composition

This phase connects modules into application.

### 3.1 Create App Composition Page

Compose Logic and UI in App layer.

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

App page may represent a primary single-slice page or aggregate multiple slices.

### 3.2 Compose Module Route

Add module route.

```dart
class Module1Route {
  RouteBase get base => ...;
}
```

```dart
routes: [
  ...,
  Module1Route.base,
],
```

### 3.3 Compose Localization

Compose shared localization from `app_l10n` with module localization used by application.

```dart
MaterialApp(
  localizationsDelegates: [
    AppLocalizations.delegate,
    ProductLocalizations.delegate,
    FinanceLocalizations.delegate,
  ],
)
```

At this stage App decides which localization delegates are required and composes them in root.

### 3.4 Compose Feature DI

Add feature DI.

```dart
Future<void> module1DI() async {
  _feature1DI();
}

void _feature1DI() {
  // Datasources
  // Repositories
  // Usecases
  // Logics
}
```

### 3.5 Compose Module DI

Add module DI.

```dart
Future<void> initDI() async {
  ...
  await module1DI();
}
```

### 3.6 Run Application

Verify feature behavior in runtime.

&nbsp;

## Solo Developer Workflow

For solo development, use short loops.

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

Alternative:

```text
1 Module
↓
Compose
↓
Test
↓
Next Module
```

This keeps feedback loops fast.

&nbsp;

## Team Workflow

For larger teams.

Example:

```text
Team A -> Finance Module
Team B -> Product Module
Team C -> Subscription Module
```

Each team may use a dedicated `module_app` for isolated local testing.

After module is stable:

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

Do not start from UI.

Do not start from API.

Do not start from folders.

Start from:

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

Sequence and Blueprint are the source of truth for implementation.
