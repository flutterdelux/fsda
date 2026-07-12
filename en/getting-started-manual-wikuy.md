# Manual E2E Getting Started (Without FSDA CLI) - Wikuy

This guide walks through creating an FSDA project manually end-to-end, without using FSDA CLI generators.

## Target Output

- Workspace: `Wikuy`
- App: `wikuy`
- Module: `travel`
- Feature: `destination`
- Slice: `list`
- Sequence: `R` (Retrieval)
- UI: `lsv` (vertical list)
- Main page class: `DestinationListPage`
- Data source: `GET /destinations` from public API:
  - `https://fdelux-mock-545621765686.asia-southeast2.run.app/docs/api/v1/#/Destinations`
  - runtime endpoint: `https://fdelux-mock-545621765686.asia-southeast2.run.app/api/v1/destinations`

## Prerequisites

- Flutter SDK installed
- Dart SDK installed
- Recommended tooling: `flutter_bloc`, `get_it`, `dio`, `freezed` (optional), `json_serializable` (optional)

## 1) Initialize Workspace Manually

```bash
mkdir Wikuy
cd Wikuy
mkdir apps modules packages
```

Create `fsda.yaml` so the workspace stays compatible with the FSDA ecosystem.

```yaml
packages:
  - app_core
  - app_l10n
  - app_ui
  - infra_dio
```

## 2) Create Shared Packages Manually

Create each foundation package manually:

```bash
flutter create packages/app_core --template=package
flutter create packages/app_l10n --template=package
flutter create packages/app_ui --template=package
flutter create packages/infra_dio --template=package
```

Minimum package responsibilities:

- `app_core`: result/failure abstraction
- `app_l10n`: localization foundation
- `app_ui`: reusable UI primitives
- `infra_dio`: HTTP client wrapper using dio

## 3) Create App and Module Manually

```bash
flutter create apps/wikuy
flutter create modules/travel --template=package
```

In `apps/wikuy/pubspec.yaml`, add path dependencies to module and shared packages.

Minimal example:

```yaml
dependencies:
  flutter:
    sdk: flutter
  travel:
    path: ../../modules/travel
  app_core:
    path: ../../packages/app_core
  app_l10n:
    path: ../../packages/app_l10n
  app_ui:
    path: ../../packages/app_ui
  infra_dio:
    path: ../../packages/infra_dio
```

In `modules/travel/pubspec.yaml`, add dependencies required by `destination` feature.

## 4) Build `destination/list` Feature Structure

Create this target structure inside `travel` module:

```text
modules/travel/lib/src/features/destination/
  data/
    datasources/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  logic/
    list/
  ui/
    list/
      views/
      widgets/
```

Minimum implementation per layer:

- data
  - `destination_remote_data_source.dart`
  - `destination_remote_data_source_impl.dart`
  - `destination_repository_impl.dart`
- domain
  - `destination_entity.dart`
  - `destination_repository.dart`
  - `destination_list_use_case.dart`
- logic (sequence R)
  - `destination_list_state.dart`
  - `destination_list_cubit.dart`
  - main method: `destinationList()`
- ui (`lsv`)
  - `destination_list_view.dart`
  - `destination_list_content.dart`
  - `destination_list_skeleton.dart`
  - `destination_list_error_feedback.dart`
  - `destination_list_empty_feedback.dart`

## 5) Implement Public API Data Source

In remote data source implementation, call:

```text
GET /api/v1/destinations
```

Base URL:

```text
https://fdelux-mock-545621765686.asia-southeast2.run.app
```

Map the response into domain entity list `DestinationEntity`.

## 6) Compose Main Page Manually: `DestinationListPage`

Create app wrapper page at:

```text
apps/wikuy/lib/modules/travel/features/destination/pages/destination_list_page.dart
```

Minimum page pattern:

- `BlocProvider<DestinationListCubit>(create: (_) => sl()..destinationList())`
- body uses `DestinationListView(content: ...)`
- state handling: `initial/loading/failure/loaded`

Because requirement is 1 slice = 1 view = 1 page, this page is the main destination list flow.

## 7) Integrate Route and DI Manually

Wire app integration manually:

- travel module route file: `apps/wikuy/lib/modules/travel/travel_route.dart`
  - add child route to `DestinationListPage`
  - add navigation helper, e.g. `toDestinationList(...)`
- app router: register `TravelRoute.base`
- app DI: register datasource, repository, use case, cubit
  - example file: `apps/wikuy/lib/core/di/core_di.dart`

## 8) Finalize Home/Dashboard

Add destination list navigation entry in app home page:

- example file: `apps/wikuy/lib/app/dashboard/pages/home_page.dart`
- tap action to `TravelRoute.toDestinationList(context)`

## 9) Validate

```bash
cd apps/wikuy
flutter pub get
flutter run
```

Quality gate:

```bash
dart analyze
```

## Done Checklist

- `Wikuy` workspace created without FSDA CLI
- `wikuy` app runs
- `travel` module integrated into app
- `destination` feature has `list` slice (sequence R)
- UI uses vertical list (`lsv`) as the main page
- `DestinationListPage` displays data from public `/destinations` endpoint
