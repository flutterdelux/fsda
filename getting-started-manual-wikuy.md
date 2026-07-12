# Getting Started Manual E2E (Tanpa FSDA CLI) - Wikuy

Dokumen ini memandu pembuatan project FSDA secara manual end-to-end tanpa command generator FSDA CLI.

## Target Hasil

- Workspace: `Wikuy`
- App: `wikuy`
- Module: `travel`
- Feature: `destination`
- Slice: `list`
- Sequence: `R` (Retrieval)
- UI: `lsv` (list vertical)
- Main page class: `DestinationListPage`
- Data source: `GET /destinations` dari API publik:
  - `https://fdelux-mock-545621765686.asia-southeast2.run.app/docs/api/v1/#/Destinations`
  - endpoint runtime: `https://fdelux-mock-545621765686.asia-southeast2.run.app/api/v1/destinations`

## Prasyarat

- Flutter SDK terpasang
- Dart SDK terpasang
- Tooling yang disarankan: `flutter_bloc`, `get_it`, `dio`, `freezed` (opsional), `json_serializable` (opsional)

## 1) Inisialisasi Workspace Manual

```bash
mkdir Wikuy
cd Wikuy
mkdir apps modules packages
```

Buat `fsda.yaml` agar struktur workspace tetap kompatibel dengan ekosistem FSDA.

```yaml
packages:
  - app_core
  - app_l10n
  - app_ui
  - infra_dio
```

## 2) Buat Shared Packages Manual

Buat package foundation satu per satu.

```bash
flutter create packages/app_core --template=package
flutter create packages/app_l10n --template=package
flutter create packages/app_ui --template=package
flutter create packages/infra_dio --template=package
```

Minimal isi package:

- `app_core`: result/failure abstraction
- `app_l10n`: localization foundation
- `app_ui`: widget dasar reusable
- `infra_dio`: wrapper HTTP client berbasis dio

## 3) Buat App dan Module Manual

```bash
flutter create apps/wikuy
flutter create modules/travel --template=package
```

Di `apps/wikuy/pubspec.yaml`, tambahkan dependency path ke module dan shared packages.

Contoh minimal:

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

Di `modules/travel/pubspec.yaml`, tambahkan dependency yang dibutuhkan feature `destination`.

## 4) Bentuk Struktur Feature `destination/list`

Buat struktur target berikut di module `travel`:

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

Implementasi minimum per layer:

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
  - method utama: `destinationList()`
- ui (`lsv`)
  - `destination_list_view.dart`
  - `destination_list_content.dart`
  - `destination_list_skeleton.dart`
  - `destination_list_error_feedback.dart`
  - `destination_list_empty_feedback.dart`

## 5) Implementasi Data Source API Publik

Di remote data source impl, panggil endpoint:

```text
GET /api/v1/destinations
```

Base URL:

```text
https://fdelux-mock-545621765686.asia-southeast2.run.app
```

Pastikan mapping response diubah menjadi list entity domain `DestinationEntity`.

## 6) Compose Main Page Manual: `DestinationListPage`

Buat page wrapper app di:

```text
apps/wikuy/lib/modules/travel/features/destination/pages/destination_list_page.dart
```

Pola minimum page:

- `BlocProvider<DestinationListCubit>(create: (_) => sl()..destinationList())`
- body menggunakan `DestinationListView(content: ...)`
- state handling `initial/loading/failure/loaded`

Karena requirement adalah 1 slice = 1 view = 1 page, maka page ini menjadi halaman utama flow destination list.

## 7) Integrasi Route dan DI Manual

Lakukan wiring manual di app:

- route module travel: `apps/wikuy/lib/modules/travel/travel_route.dart`
  - route child ke `DestinationListPage`
  - helper navigasi, misal `toDestinationList(...)`
- app router: daftarkan `TravelRoute.base`
- DI app: register datasource, repository, use case, cubit
  - contoh file: `apps/wikuy/lib/core/di/core_di.dart`

## 8) Finalisasi Home/Dashboard

Tambahkan entry navigasi ke destination list di home page app:

- file contoh: `apps/wikuy/lib/app/dashboard/pages/home_page.dart`
- aksi tap menuju `TravelRoute.toDestinationList(context)`

## 9) Validasi

```bash
cd apps/wikuy
flutter pub get
flutter run
```

Quality gate:

```bash
dart analyze
```

## Checklist Selesai

- Workspace `Wikuy` terbentuk tanpa FSDA CLI
- App `wikuy` berjalan
- Module `travel` aktif di app
- Feature `destination` memiliki slice `list` (sequence R)
- UI menggunakan list vertical (`lsv`) sebagai main page
- `DestinationListPage` menampilkan data dari endpoint publik `/destinations`
