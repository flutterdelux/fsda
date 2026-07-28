# Getting Started E2E - Wikuy (Manual)

Dokumen ini memandu pembuatan project FSDA secara manual *end-to-end* tanpa menggunakan command generator FSDA CLI. 

Sebagai panduan komparatif, kita akan mengambil komponen *boilerplate* dari repositori [fsda-templates](https://github.com/flutterdelux/fsda-templates) dan merakitnya mengikuti standar arsitektur FSDA.

## Target Hasil

- Workspace: `Wikuy`
- App: `wikuy`
- Module: `travel`
- Feature: `destination`
- Slice: `list`
- Sequence: `R` (Retrieval)
- UI: `lsv` (list vertical)
- Method: `getDestinationList`
- Compose target page: `destination_list_page`
- API source: `GET /destinations`
  - URL docs: `https://fdelux-mock-545621765686.asia-southeast2.run.app/docs/api/v1/#/Destinations`
  - Endpoint runtime: `GET https://fdelux-mock-545621765686.asia-southeast2.run.app/api/v1/destinations`

## Prasyarat

- Flutter SDK dan Dart SDK terpasang
- Git tersedia di sistem (Opsional but recommended)

## 1. Setup Workspace

Langkah pertama adalah membuat *root directory* dan mendefinisikan batas-batas utama (App, Module, Packages).

```bash
mkdir Wikuy
cd Wikuy
mkdir apps modules packages
```

## 2. Setup Workspace Foundation

Unduh repositori template nya terlebih dahulu dan simpan ke dalam folder sementara (`temp_templates`) di dalam workspace agar kita bisa mengambil komponen yang dibutuhkan.

```bash
git clone https://github.com/flutterdelux/fsda-templates.git temp_templates
```

Buat file `analysis_options.yaml` di root workspace, tambahkan template ke *exclude* agar tidak dianalisis oleh Dart analyzer sehingga memunculkan warning dan error analyzer di IDE:

::: code-group
```yaml [analysis_options.yaml]
analyzer:
  exclude:
    - temp_templates/**
```
:::

Ambil file `fsda.yaml` dari template, edit isinya. fsda.yaml ini berisi konfigurasi *workspace* dan *app* yang akan digunakan oleh FSDA CLI jika nanti ingin menggunakannya.

```bash
cp temp_templates/fsda.yaml .
```

Salin template package yang dibutuhkan dari folder sementara ke dalam folder `packages/` workspace. Jangan lupa jalankan `flutter pub get` di masing-masing package untuk memastikan dependensi terunduh dengan benar.

Copy packages:

```bash
cp -r temp_templates/packages/app_core packages/
cp -r temp_templates/packages/app_l10n packages/
cp -r temp_templates/packages/app_ui packages/
cp -r temp_templates/packages/infra_http packages/
cp -r temp_templates/packages/infra_logging packages/
```

Run pub get pada masing-masing package:

```bash
cd packages/app_core && flutter pub get && cd ../..
cd packages/app_l10n && flutter pub get && cd ../..
cd packages/app_ui && flutter pub get && cd ../..
cd packages/infra_http && flutter pub get && cd ../..
cd packages/infra_logging && flutter pub get && cd ../..
```

## 3. Setup App

Langkah ini mengharuskan kita membuat project Flutter standar terlebih dahulu agar basis project sesuai dengan versi Flutter SDK yang terinstal di sistem, baru kemudian menimpanya (merge) dengan isi dari template aplikasi (misalnya base).

Buat project Flutter dasar:

```bash
flutter create --empty apps/wikuy
```

Salin dan merge isi template aplikasi ke dalam project yang baru dibuat:

```bash
cp -r temp_templates/apps/base/* apps/wikuy/
```

Pastikan name pubspec nya `wikuy` apabila berubah tertimpa oleh template.

Tambahkan shared packages:

```yaml
dependencies:
  app_core:
    path: ../../packages/app_core
  app_l10n:
    path: ../../packages/app_l10n
  app_ui:
    path: ../../packages/app_ui
  infra_http:
    path: ../../packages/infra_http
  infra_logging:
    path: ../../packages/infra_logging
```

Tambah package yang dibutuhkan infrastructure:

```bash
cd apps/wikuy
dart pub add http logging
cd ../../
```

Daftarkan external infrastructure ke external di dan core di.

::: code-group

```dart [external_di.dart] {1,6}
import 'package:http/http.dart' as http;

import 'di.dart';

Future<void> externalDI() async {
  sl.registerLazySingleton<http.Client>(() => http.Client());
}
```

```dart [core_di.dart] {2-4,6,11-22}
import 'package:app_core/app_core.dart';
import 'package:infra_http/infra_http.dart';
import 'package:infra_logging/infra_logging.dart';
import 'package:logging/logging.dart';

import '../externals/fdelux_mock_config.dart';
import '../externals/network_timeout_config.dart';
import 'di.dart';

Future<void> coreDI() async {
  sl.registerLazySingleton<ApiClient>(
    () => HttpApiClient(
      client: sl(),
      baseUrl: FDeluxMockConfig.cloudRunBaseUrl,
      requestTimeout: NetworkTimeoutConfig.requestTimeout,
      streamConnectionTimeout: NetworkTimeoutConfig.streamConnectionTimeout,
    ),
  );

  sl.registerFactoryParam<AppLogger, String, void>(
    (name, _) => LoggingImpl(logger: Logger(name)),
  );
}
```

:::

Pastikan konfigurasi package_rename_config mengarah ke App ID yang benar (misal: com.fdelux.wikuy) dan sesuaikan flutter_launcher_icons.

Jalankan command untuk konfigurasi App ID dan launcher icon:

```bash
cd apps/wikuy
dart run package_rename
dart run flutter_launcher_icons
cd ../../
```

## 4. Pembuatan Module, Feature, Slice

Sama halnya dengan aplikasi, module juga dibuat dengan melakukan `flutter create` terlebih dahulu agar kompatibel dengan lingkungan Flutter saat ini, baru kemudian dibentuk strukturnya sesuai pola *template module* bawaan FSDA.

### 4.1. Module

Buat *base package* module-nya:
```bash
flutter create modules/travel --template=package
```

Alih-alih membuat folder dan file satu per satu, kita akan langsung meng-copy isi module dari template `modules/travel` yang ada di repositori ke dalam module yang baru kita buat.

Struktur awal module `travel` yang akan terbentuk:

```text
modules/
└── travel/
    ├── analysis_options.yaml
    ├── build.yaml
    ├── l10n.yaml
    ├── pubspec.yaml
    └── lib/
        ├── travel.dart
        ├── l10n/
        │   ├── travel_en.arb
        │   └── travel_id.arb
        └── src/
            ├── features/
            └── shared/
                ├── data/
                │   └── errors/
                │       └── travel_exception.dart
                ├── domain/
                │   └── errors/
                │       └── travel_failure.dart
                └── ui/
                    └── extensions/
                        └── travel_failure_x.dart
```

Jalankan perintah berikut untuk men-copy file template:

```bash
cp -r temp_templates/modules/travel/* modules/travel/
```

Setelah menyalin file, idealnya kita perlu mengedit *file name* maupun isi *code*-nya. Namun, **karena saat ini module template juga menggunakan konteks `travel`**, maka isinya dianggap sudah sesuai dan tidak perlu diubah namanya.

Jalankan *post-hook* berikut di dalam folder `modules/travel` untuk me-resolve *dependencies*, men-generate file lokalisasi, dan menjalankan *build_runner*:

```bash
cd modules/travel
flutter pub get
flutter gen-l10n
dart run build_runner build --force-jit --delete-conflicting-outputs
cd ../../
```

### 4.2. Feature

Di dalam folder `lib/src/features/`, kita akan membuat folder feature `destination` dan menginisialisasi arsitektur dasarnya.

Struktur feature `destination`:
```text
modules/travel/lib/src/features/
└── destination/
    ├── data/
    │   ├── datasources/
    │   │   ├── destination_remote_data_source.dart
    │   │   └── destination_remote_data_source_impl.dart
    │   └── repositories/
    │       └── destination_repository_impl.dart
    ├── domain/
    │   └── repositories/
    │       └── destination_repository.dart
    ├── logic/
    ├── ui/
    └── destination_feature.dart
```

Buat file-file tersebut dan isikan *code block* dibawah ini ke masing-masing file.

```bash
cd modules/travel
mkdir -p lib/src/features/destination/data/datasources
mkdir -p lib/src/features/destination/data/dtos
mkdir -p lib/src/features/destination/data/requests
mkdir -p lib/src/features/destination/data/responses
mkdir -p lib/src/features/destination/data/repositories
mkdir -p lib/src/features/destination/domain/entities
mkdir -p lib/src/features/destination/domain/enums
mkdir -p lib/src/features/destination/domain/params
mkdir -p lib/src/features/destination/domain/repositories
mkdir -p lib/src/features/destination/domain/usecases
mkdir -p lib/src/features/destination/logic
mkdir -p lib/src/features/destination/ui

touch lib/src/features/destination/data/datasources/destination_remote_data_source.dart
touch lib/src/features/destination/data/datasources/destination_remote_data_source_impl.dart
touch lib/src/features/destination/data/repositories/destination_repository_impl.dart
touch lib/src/features/destination/domain/repositories/destination_repository.dart
touch lib/src/features/destination/destination_feature.dart
cd ../../
```


::: code-group

```dart [destination_remote_data_source.dart]
abstract interface class DestinationRemoteDataSource {
  // ------- Retrieval -------

  // ------- Mutation -------
}
```

```dart [destination_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import 'destination_remote_data_source.dart';

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  final ApiClient _apiClient;

  const DestinationRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  // ------- Mutation -------
}
```

```dart [destination_repository.dart]
abstract interface class DestinationRepository {
  // ------- Retrieval -------

  // ------- Mutation -------
}
```

```dart [destination_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/repositories/destination_repository.dart';
import '../datasources/destination_remote_data_source.dart';

class DestinationRepositoryImpl
    with RepositoryExceptionHandler
    implements DestinationRepository {
  final AppLogger _log;
  final DestinationRemoteDataSource _remoteDataSource;

  const DestinationRepositoryImpl({
    required AppLogger appLogger,
    required DestinationRemoteDataSource destinationRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = destinationRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  // ------- Mutation -------
}
```

```dart [destination_feature.dart]
// data
export 'data/datasources/destination_remote_data_source.dart';
export 'data/datasources/destination_remote_data_source_impl.dart';
export 'data/repositories/destination_repository_impl.dart';
// domain
export 'domain/repositories/destination_repository.dart';
// logic
// ui
```

```dart [travel.dart] {1}
export 'src/features/destination/destination_feature.dart';
export 'src/generated/travel_localizations.dart';
export 'src/shared/domain/errors/travel_failure.dart';
export 'src/shared/ui/extensions/travel_failure_x.dart';
```

:::

### 4.3. Slice

Karena slice ini menggunakan tipe sequence `R` (Retrieval), buat *file* yang dibutuhkan di dalam feature `destination`. 

```bash
cd modules/travel/lib/src/features/destination
mkdir -p logic/list
mkdir -p ui/list/views
mkdir -p ui/list/widgets
mkdir -p ui/list/widgets/parts

touch data/dtos/destination_dto.dart
touch data/responses/destination_list_response.dart
touch domain/entities/destination_entity.dart
touch domain/usecases/destination_list_use_case.dart
touch logic/list/destination_list_state.dart
touch logic/list/destination_list_cubit.dart
touch ui/list/views/destination_list_view.dart
touch ui/list/widgets/parts/destination_list_item_skeleton.dart
touch ui/list/widgets/parts/destination_list_item.dart
touch ui/list/widgets/destination_list_content.dart
touch ui/list/widgets/destination_list_empty_feedback.dart
touch ui/list/widgets/destination_list_error_feedback.dart
touch ui/list/widgets/destination_list_skeleton.dart
cd ../../../../../../
```

::: code-group

```dart [destination_dto.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/destination_entity.dart';

part 'destination_dto.freezed.dart';
part 'destination_dto.g.dart';

@freezed
abstract class DestinationDto with _$DestinationDto {
  const DestinationDto._();

  const factory DestinationDto({
    required int id,
    required String name,
    required String description,
    required String imageUrl,
    required double rating,
    required int reviewCount,
    required bool isPopular,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DestinationDto;

  factory DestinationDto.fromJson(Map<String, dynamic> json) =>
      _$DestinationDtoFromJson(json);

  DestinationEntity toEntity() {
    return DestinationEntity(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      isPopular: isPopular,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

```dart [destination_list_response.dart]
import 'package:freezed_annotation/freezed_annotation.dart';
import '../dtos/destination_dto.dart';

part 'destination_list_response.freezed.dart';
part 'destination_list_response.g.dart';

@freezed
abstract class DestinationListResponse with _$DestinationListResponse {
  const factory DestinationListResponse({
    required String status,
    required String message,
    List<DestinationDto>? data,
    String? code,
    List<String>? errors,
  }) = _DestinationListResponse;

  factory DestinationListResponse.fromJson(Map<String, dynamic> json) =>
      _$DestinationListResponseFromJson(json);
}
```


```dart [destination_remote_data_source.dart] {1,6}
import '../dtos/destination_dto.dart';

abstract interface class DestinationRemoteDataSource {
  // ------- Retrieval -------

  Future<List<DestinationDto>> getDestinationList();

  // ------- Mutation -------
}
```

```dart [destination_remote_data_source_impl.dart] {3-5,16-33}
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/travel_exception.dart';
import '../dtos/destination_dto.dart';
import '../responses/destination_list_response.dart';
import 'destination_remote_data_source.dart';

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  final ApiClient _apiClient;

  const DestinationRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  @override
  Future<List<DestinationDto>> getDestinationList() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/destinations',
    );
    if (response.statusCode == 200) {
      final destinationListResponse = DestinationListResponse.fromJson(
        response.body,
      );
      if (destinationListResponse.data != null) {
        return destinationListResponse.data!;
      }

      throw const CoreException.serverError();
    }

    throw TravelException.fromApiResponse(response, st: StackTrace.current);
  }

  // ------- Mutation -------
}
```

```dart [destination_repository.dart] {1-2,7}
import 'package:app_core/app_core.dart';
import '../entities/destination_entity.dart';

abstract interface class DestinationRepository {
  // ------- Retrieval -------

  AsyncResult<List<DestinationEntity>> getDestinationList();

  // ------- Mutation -------
}
```

```dart [destination_repository_impl.dart] {3,24-32}
import 'package:app_core/app_core.dart';

import '../../domain/entities/destination_entity.dart';
import '../../domain/repositories/destination_repository.dart';
import '../datasources/destination_remote_data_source.dart';

class DestinationRepositoryImpl
    with RepositoryExceptionHandler
    implements DestinationRepository {
  final AppLogger _log;
  final DestinationRemoteDataSource _remoteDataSource;

  const DestinationRepositoryImpl({
    required AppLogger appLogger,
    required DestinationRemoteDataSource destinationRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = destinationRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  @override
  AsyncResult<List<DestinationEntity>> getDestinationList() async {
    try {
      final dtos = await _remoteDataSource.getDestinationList();
      return Result.success(dtos.map((e) => e.toEntity()).toList());
    } catch (e, st) {
      return handleException('getDestinationList', e, st);
    }
  }

  // ------- Mutation -------
}
```

```dart [destination_entity.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination_entity.freezed.dart';

@freezed
abstract class DestinationEntity with _$DestinationEntity {
  const factory DestinationEntity({
    required int id,
    required String name,
    required String description,
    required String imageUrl,
    required double rating,
    required int reviewCount,
    required bool isPopular,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DestinationEntity;
}
```

```dart [destination_list_use_case.dart]
import 'package:app_core/app_core.dart';

import '../entities/destination_entity.dart';
import '../repositories/destination_repository.dart';

class DestinationListUseCase
    extends NoParamUseCase<List<DestinationEntity>> {
  final DestinationRepository _repository;

  const DestinationListUseCase({
    required DestinationRepository destinationRepository,
  }) : _repository = destinationRepository;

  @override
  AsyncResult<List<DestinationEntity>> call() =>
      _repository.getDestinationList();
}
```

```dart [destination_list_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/destination_entity.dart';

part 'destination_list_state.freezed.dart';

@freezed
sealed class DestinationListState with _$DestinationListState {
  const factory DestinationListState.initial() = _Initial;
  const factory DestinationListState.loading() = _Loading;
  const factory DestinationListState.loaded({
    required List<DestinationEntity> data,
  }) = _Loaded;
  const factory DestinationListState.failure({required Failure failure}) =
      _Failure;
}
```

```dart [destination_list_cubit.dart]
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/usecases/destination_list_use_case.dart';
import 'destination_list_state.dart';

class DestinationListCubit extends Cubit<DestinationListState> {
  final DestinationListUseCase _useCase;

  DestinationListCubit({
    required DestinationListUseCase destinationListUseCase,
  }) : _useCase = destinationListUseCase,
       super(const DestinationListState.initial());

  Future<void> getDestinationList() async {
    emit(const DestinationListState.loading());

    final result = await _useCase();

    emit(
      result.when(
        success: (data) => DestinationListState.loaded(data: data),
        failure: (failure) => DestinationListState.failure(failure: failure),
      ),
    );
  }
}
```

```dart [destination_list_view.dart]
import 'package:flutter/material.dart';
import '../../../../../generated/travel_localizations.dart';

class DestinationListView extends StatelessWidget {
  final Widget content;
  const DestinationListView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final l10n = TravelLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.destinationListTitle)),
      body: content,
    );
  }
}
```

```dart [destination_list_item_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DestinationListItemSkeleton extends StatelessWidget {
  const DestinationListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppListTileSkeleton();
  }
}
```

```dart [destination_list_item.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/destination_entity.dart';

class DestinationListItem extends StatelessWidget {
  final int index;
  final DestinationEntity destination;
  final void Function() onTap;
  const DestinationListItem({
    super.key,
    required this.index,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: AppNetworkImage(
        url: destination.imageUrl,
        width: 48,
        height: 48,
        borderRadius: BorderRadius.circular(8),
      ),
      title: destination.name,
      subtitle: destination.description,
      includeChevron: true,
      onTap: onTap,
    );
  }
}
```

```dart [destination_list_content.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/destination_entity.dart';
import 'parts/destination_list_item.dart';

class DestinationListContent extends StatelessWidget {
  final List<DestinationEntity> list;
  final void Function(DestinationEntity item) onItemTap;
  const DestinationListContent({
    super.key,
    required this.list,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        0,
        0,
        0,
        AppSpacing.screen + padding.bottom,
      ),
      itemCount: list.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final destination = list[index];
        return DestinationListItem(
          index: index,
          destination: destination,
          onTap: () => onItemTap(destination),
        );
      },
    );
  }
}
```

```dart [destination_list_empty_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/travel_localizations.dart';

class DestinationListEmptyFeedback extends StatelessWidget {
  final VoidCallback onRefresh;
  const DestinationListEmptyFeedback({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = TravelLocalizations.of(context)!;
    return AppEmptyFeedback(
      title: l10n.destinationListEmptyTitle,
      message: l10n.destinationListEmptyMessage,
      onRefresh: onRefresh,
      refreshText: appL10n.refresh,
    );
  }
}
```

```dart [destination_list_error_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/travel_localizations.dart';

class DestinationListErrorFeedback extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const DestinationListErrorFeedback({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = TravelLocalizations.of(context)!;
    return AppErrorFeedback(
      title: l10n.destinationListErrorTitle,
      message: message,
      retryText: appL10n.refresh,
      onRetry: onRetry,
    );
  }
}
```

```dart [destination_list_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'parts/destination_list_item_skeleton.dart';

class DestinationListSkeleton extends StatelessWidget {
  final int itemCount;
  const DestinationListSkeleton({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        0,
        0,
        0,
        AppSpacing.screen + padding.bottom,
      ),
      itemBuilder: (context, index) {
        return const DestinationListItemSkeleton();
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: itemCount,
    );
  }
}
```

```dart [destination_feature.dart] {6,8,10-11,13-17}
// data
export 'data/datasources/destination_remote_data_source.dart';
export 'data/datasources/destination_remote_data_source_impl.dart';
export 'data/repositories/destination_repository_impl.dart';
// domain
export 'domain/entities/destination_entity.dart';
export 'domain/repositories/destination_repository.dart';
export 'domain/usecases/destination_list_use_case.dart';
// logic
export 'logic/list/destination_list_cubit.dart';
export 'logic/list/destination_list_state.dart';
// ui
export 'ui/list/views/destination_list_view.dart';
export 'ui/list/widgets/destination_list_content.dart';
export 'ui/list/widgets/destination_list_empty_feedback.dart';
export 'ui/list/widgets/destination_list_error_feedback.dart';
export 'ui/list/widgets/destination_list_skeleton.dart';
```

```arb [travel_en.arb] {7-15}
{
  "@@locale": "en",
  "@failureTravelNotFound": {
    "description": "========================= Failure ========================="
  },
  "failureTravelNotFound": "Travel not found",
  "failureDestinationNotFound": "Destination not found",
  "@destinationAlt": {
    "description": "========================= Destination ========================="
  },
  "destinationAlt": "Destination",
  "destinationListTitle": "Destination List",
  "destinationListEmptyTitle": "No Destination Found",
  "destinationListEmptyMessage": "No destination found at the moment",
  "destinationListErrorTitle": "Failed to Load Destination List"
}
```

```arb [travel_id.arb] {7-15}
{
  "@@locale": "id",
  "@failureTravelNotFound": {
    "description": "========================= Failure ========================="
  },
  "failureTravelNotFound": "Travel tidak ditemukan",
  "failureDestinationNotFound": "Destination tidak ditemukan",
  "@destinationAlt": {
    "description": "========================= Destination ========================="
  },
  "destinationAlt": "Destination",
  "destinationListTitle": "Daftar Destinasi",
  "destinationListEmptyTitle": "Destinasi Tidak Ditemukan",
  "destinationListEmptyMessage": "Tidak ada destinasi yang ditemukan saat ini",
  "destinationListErrorTitle": "Gagal Memuat Daftar Destinasi"
}
```

:::

### 4.4. Post Hooks

Jalankan perintah berikut di dalam folder `modules/travel` untuk men-generate arb dan file freezed/json_serializable:

```bash
cd modules/travel
flutter gen-l10n
dart run build_runner build --force-jit --delete-conflicting-outputs
cd ../../
```


## 5. Register Module dan Feature DI ke App

Setelah module selesai dibuat, module tersebut harus didaftarkan (*registered*) ke *App*.

Buka `apps/wikuy/pubspec.yaml` dan daftarkan path module.

```yaml
dependencies:
  travel:
    path: ../../modules/travel
```

Berikut adalah ringkasan struktur register module yang sudah terbentuk setelah module `travel` didaftarkan ke dalam app `wikuy`:

```text
lib/
├── app/
│   ├── app_router.dart <- inject TravelRoute.base
│   └── main_app.dart <- inject TravelLocalizations.delegate
├── core/
│   ├── di/
│   │   └── di.dart <- inject TravelDi.register()
│   └── extensions/
│       └── failure_x.dart <- inject TravelFailureX
└── modules/
    └── travel
        ├── features/
        ├── travel_di.dart
        └── travel_route.dart
```

```bash
cd apps/wikuy
flutter pub get
mkdir -p lib/modules/travel

touch lib/modules/travel/travel_di.dart 
touch lib/modules/travel/travel_route.dart
cd ../../
```

::: code-group

```dart [travel_route.dart]
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/pages/not_found_page.dart';

abstract final class TravelRoute {
  static const _travel = 'travel';

  static RouteBase get base => GoRoute(
    path: '/travel',
    name: _travel,
    builder: (context, state) => const NotFoundPage(),
    routes: [

    ],
  );

  static Future<dynamic> toTravel(BuildContext context) {
    return context.pushNamed(_travel);
  }
}
```

```dart [app_router.dart] {2,15}
...
import '../modules/travel/travel_route.dart';
...

late final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: startupPath,
  redirect: _redirect,
  debugLogDiagnostics: false,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    _mainRoute,
    DashboardRoute.base,
    // ...inject here
    TravelRoute.base,
  ],
);

...
```

```dart [travel_di.dart]
import 'package:travel/travel.dart';

import '../../core/di/di.dart';

abstract final class TravelDi {
  static void register() {
    // reg feature di
    _destinationDi();
  }

  // destination feature
  static void _destinationDi() {
    // Datasources
    sl.registerLazySingleton<DestinationRemoteDataSource>(
      () => DestinationRemoteDataSourceImpl(apiClient: sl()),
    );

    // Repositories
    sl.registerLazySingleton<DestinationRepository>(
      () => DestinationRepositoryImpl(
        appLogger: sl(param1: 'DestinationRepository'),
        destinationRemoteDataSource: sl(),
      ),
    );

    // Usecases
    sl.registerLazySingleton(
      () => DestinationListUseCase(destinationRepository: sl()),
    );

    // Logic (Cubits/Blocs)
    sl.registerFactory(
      () => DestinationListCubit(destinationListUseCase: sl()),
    );
  }
}
```

```dart [di.dart] {3,15}
import 'package:get_it/get_it.dart';

import '../../modules/travel/travel_di.dart';
import 'core_di.dart';
import 'external_di.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  await externalDI();
  await coreDI();
  await sl.allReady();

  // Modules DI
  TravelDi.register();
}
```

```dart [main_app.dart] {4,22}
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:travel/travel.dart';

import 'app_router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,

        /// Module L10n delegate injection
        ...TravelLocalizations.localizationsDelegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('id_ID'),
      routerConfig: AppRouter().router,
    );
  }
}
```

```dart [failure_x.dart] {4,24-26}
import 'package:app_core/app_core.dart';
import 'package:app_l10n/app_l10n.dart';
import 'package:flutter/material.dart';
import 'package:travel/travel.dart';

extension FailureX on Failure {
  String localizeAny(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (this is CoreFailure) {
      final l10n = AppLocalizations.of(context)!;
      return switch (this as CoreFailure) {
        .cacheError => l10n.coreFailureCacheError,
        .networkError => l10n.coreFailureNetworkError,
        .timeoutError => l10n.coreFailureTimeoutError,
        .serverError => l10n.coreFailureServerError,
        .unauthenticated => l10n.coreFailureUnauthenticated,
        .serviceUnavailable => l10n.coreFailureServiceUnavailable,
      };
    }

    // Module Failures

    if (this is TravelFailure) {
      return (this as TravelFailure).localize(context);
    }

    return l10n.unknownError;
  }
}
```

:::

## 6. Compose Slice ke Page

View skeleton sudah dibuat di slice list, jadi tinggal dicompose di page target beserta logic nya.

```text
lib/
├── app/
├── core/
└── modules/
    └── travel
        ├── features
        │   └── destination
        │       └── pages
        │           └── destination_list_page.dart <- compose page wrapper
        ├── travel_di.dart
        └── travel_route.dart
```

```bash
cd apps/wikuy
mkdir -p lib/modules/travel/features/destination/pages
touch lib/modules/travel/features/destination/pages/destination_list_page.dart
cd ../../
```

::: code-group

```dart [destination_list_page.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/travel.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/extensions/failure_x.dart';
import '../../../../../core/mixins/page_provider_mixin.dart';

class DestinationListPage extends StatelessWidget with PageProviderMixin {
  const DestinationListPage({super.key});

  void _getDestinationList(BuildContext context) {
    context.read<DestinationListCubit>().getDestinationList();
  }

  void _onItemTap(BuildContext context, DestinationEntity item) {
    context.showSuccessSnackbar('Tapped on: ${item.name}');
  }

  @override
  Widget build(BuildContext context) {
    return buildPage(
      providers: [
        BlocProvider<DestinationListCubit>(
          create: (_) => sl()..getDestinationList(),
        ),
      ],
      listeners: [],
      builder: (context) {
        return DestinationListView(content: _buildPrimaryContent(context));
      },
    );
  }

  Widget _buildPrimaryContent(BuildContext context) {
    return BlocBuilder<DestinationListCubit, DestinationListState>(
      builder: (_, state) => state.maybeWhen(
        orElse: () => const DestinationListSkeleton(),
        loading: () => const DestinationListSkeleton(),
        failure: (failure) => DestinationListErrorFeedback(
          message: failure.localizeAny(context),
          onRetry: () => _getDestinationList(context),
        ),
        loaded: (data) => data.isEmpty
            ? DestinationListEmptyFeedback(
                onRefresh: () => _getDestinationList(context),
              )
            : DestinationListContent(
                list: data,
                onItemTap: (item) => _onItemTap(context, item),
              ),
      ),
    );
  }
}
```

```dart [travel_route.dart] {2,6,13-17,23-25}
...
import 'features/destination/pages/destination_list_page.dart';

abstract final class TravelRoute {
  static const _travel = 'travel';
  static const _destinationList = 'destination-list';

  static RouteBase get base => GoRoute(
    path: '/travel',
    name: _travel,
    builder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: 'destination-list',
        name: _destinationList,
        builder: (context, state) => const DestinationListPage(),
      ),
    ],
  );

  ...

  static Future<dynamic> toDestinationList(BuildContext context) {
    return context.pushNamed(_destinationList);
  }
}
```

:::

Hasil compose utama:

- generate page app wrapper DestinationListPage
- inject provider cubit retrieval
- update route module app wrapper

## 7. Buat Button Navigasi ke Destination List

Buka halaman Home di App (`apps/wikuy/lib/app/dashboard/pages/home_page.dart`) dan tambahkan navigasi menuju slice yang baru saja di-*compose*.

::: code-group

```dart [home_page.dart] {1,8-13}
import '../../../modules/travel/travel_route.dart';

...

body: ListView(
  padding: const EdgeInsets.all(AppSpacing.screen),
  children: [
    FilledButton(
      onPressed: () {
        TravelRoute.toDestinationList(context);
      },
      child: const Text('Destination List'),
    ),
  ],
),

...
```

:::

## 8. Run & Cleanup

Jalankan aplikasi.

```bash
cd apps/wikuy
flutter run
```

Hapus folder sementara `temp_templates` jika sudah tidak dibutuhkan lagi.

```bash
cd ../../
rm -rf temp_templates
```

## 9. Result

Jika seluruh konfigurasi benar, akan menghasilkan *output* dibawah ini.

| Startup | Home Page | Destination List |
|:---------:|:---------:|:------------------:|
| ![img](/images/startup.png) | ![img](/images/home.png) | ![img](/images/destination-list.png) |