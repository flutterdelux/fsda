# Retrieval + Pagination Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rpag | Retrieval + Pagination        | location     | city        | list          | getCityList()            |


## Shared

::: code-group

```dart [location_failure.dart]
import 'package:app_core/app_core.dart';

enum LocationFailure implements Failure { locationNotFound, cityNotFound }
```

```dart [location_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/location_localizations.dart';
import '../../domain/errors/location_failure.dart';

extension LocationFailureX on LocationFailure {
  String localize(BuildContext context) {
    final l10n = LocationLocalizations.of(context)!;
    return switch (this) {
      LocationFailure.locationNotFound => l10n.failureLocationNotFound,
      LocationFailure.cityNotFound => l10n.failureCityNotFound,
    };
  }
}
```

```dart [location_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/location_failure.dart';

part 'location_exception.freezed.dart';

@freezed
sealed class LocationException
    with _$LocationException
    implements AppException {
  const LocationException._();

  const factory LocationException.locationNotFound({
    String? msg,
    StackTrace? st,
  }) = _LocationNotFound;
  const factory LocationException.cityNotFound({String? msg, StackTrace? st}) =
      _CityNotFound;

  @override
  String get message => when(
    locationNotFound: (msg, _) => msg ?? 'Location not found',
    cityNotFound: (msg, _) => msg ?? 'City not found',
  );

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() => when(
    locationNotFound: (_, _) => LocationFailure.locationNotFound,
    cityNotFound: (_, _) => LocationFailure.cityNotFound,
  );

  static AppException fromApiResponse(ApiResponse response, {StackTrace? st}) {
    return CoreException.fromException(response.body.toString(), st: st);
  }

  static AppException fromException(
    Object e, {
    StackTrace? st,
    bool isLocal = false,
  }) {
    if (e is AppException) {
      return e;
    }

    return CoreException.fromException(e, st: st, isLocal: isLocal);
  }
}
```

:::

## L10n

::: code-group

```arb [location_en.arb]
{
  "@@locale": "en",
  "@failureLocationNotFound": {
    "description": "========================= Failure ========================="
  },
  "failureLocationNotFound": "Location not found",
  "failureCityNotFound": "City not found",
  "@cityAlt": {
    "description": "========================= City ========================="
  },
  "cityAlt": "City",
  "cityListTitle": "City List",
  "cityListEmptyTitle": "No City Found",
  "cityListEmptyMessage": "No city found at the moment",
  "cityListErrorTitle": "Failed to Load City List"
}
```

```arb [location_id.arb]
{
  "@@locale": "id",
  "@failureLocationNotFound": {
    "description": "========================= Failure ========================="
  },
  "failureLocationNotFound": "Location tidak ditemukan",
  "failureCityNotFound": "City tidak ditemukan",
  "@cityAlt": {
    "description": "========================= City ========================="
  },
  "cityAlt": "City",
  "cityListTitle": "Daftar Kota",
  "cityListEmptyTitle": "Tidak ada kota ditemukan",
  "cityListEmptyMessage": "Tidak ada kota yang ditemukan saat ini",
  "cityListErrorTitle": "Gagal memuat daftar kota"
}
```

:::

## Domain Layer

::: code-group

```dart [city_entity.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_entity.freezed.dart';

@freezed
abstract class CityEntity with _$CityEntity {
  const factory CityEntity({
    required int id,
    required String name,
    required String state,
    required String country,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CityEntity;
}
```

```dart [city_list_param.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_list_param.freezed.dart';

@freezed
abstract class CityListParam with _$CityListParam {
  const factory CityListParam({
    @Default(1) int page,
    @Default(15) int pageSize,
  }) = _CityListParam;
}
```

```dart [city_repository.dart]
import 'package:app_core/app_core.dart';
import '../entities/city_entity.dart';
import '../params/city_list_param.dart';

abstract interface class CityRepository {
  // ------- Retrieval -------

  AsyncResult<List<CityEntity>> getCityList(CityListParam param);

  // ------- Mutation -------
}
```

```dart [city_use_case.dart]
import 'package:app_core/app_core.dart';

import '../entities/city_entity.dart';
import '../params/city_list_param.dart';
import '../repositories/city_repository.dart';

class CityListUseCase extends UseCase<List<CityEntity>, CityListParam> {
  final CityRepository _repository;

  const CityListUseCase({required CityRepository cityRepository})
    : _repository = cityRepository;

  @override
  AsyncResult<List<CityEntity>> call(CityListParam param) {
    return _repository.getCityList(param);
  }
}
```

:::

## Data Layer

::: code-group

```dart [city_dto.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/city_entity.dart';

part 'city_dto.freezed.dart';
part 'city_dto.g.dart';

@freezed
abstract class CityDto with _$CityDto {
  const CityDto._();

  const factory CityDto({
    required int id,
    required String name,
    required String state,
    required String country,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
  }) = _CityDto;

  factory CityDto.fromJson(Map<String, Object?> json) =>
      _$CityDtoFromJson(json);

  CityEntity toEntity() {
    return CityEntity(
      id: id,
      name: name,
      state: state,
      country: country,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

```dart [city_list_request.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/params/city_list_param.dart';

part 'city_list_request.freezed.dart';
part 'city_list_request.g.dart';

@freezed
abstract class CityListRequest with _$CityListRequest {
  const CityListRequest._();

  const factory CityListRequest({required int page, required int pageSize}) =
      _CityListRequest;

  factory CityListRequest.fromJson(Map<String, Object?> json) =>
      _$CityListRequestFromJson(json);

  factory CityListRequest.fromParam(CityListParam param) {
    return CityListRequest(page: param.page, pageSize: param.pageSize);
  }
}
```

```dart [city_list_response.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../dtos/city_dto.dart';

part 'city_list_response.freezed.dart';
part 'city_list_response.g.dart';

@freezed
abstract class CityListResponse with _$CityListResponse {
  const factory CityListResponse({
    required String status,
    required String message,
    Map<String, dynamic>? meta,
    @JsonKey(fromJson: _fromJson) List<CityDto>? data,
    String? code,
    List<String>? errors,
  }) = _CityListResponse;

  factory CityListResponse.fromJson(Map<String, dynamic> json) =>
      _$CityListResponseFromJson(json);
}

List<CityDto>? _fromJson(Object? json) {
  if (json is List) {
    return json
        .map((item) => CityDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  return null;
}
```

```dart [city_remote_data_source.dart]
import '../dtos/city_dto.dart';
import '../requests/city_list_request.dart';

abstract interface class CityRemoteDataSource {
  // ------- Retrieval -------

  Future<List<CityDto>> getCityList(CityListRequest request);

  // ------- Mutation -------
}
```

```dart [city_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/location_exception.dart';
import '../dtos/city_dto.dart';
import '../requests/city_list_request.dart';
import '../responses/city_list_response.dart';
import 'city_remote_data_source.dart';

class CityRemoteDataSourceImpl implements CityRemoteDataSource {
  final ApiClient _apiClient;

  const CityRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  @override
  Future<List<CityDto>> getCityList(CityListRequest request) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/cities',
      queryParameters: request.toJson(),
    );

    if (response.statusCode == 200) {
      final cityListResponse = CityListResponse.fromJson(response.body);
      if (cityListResponse.data != null) {
        return cityListResponse.data!;
      }

      throw const CoreException.serverError();
    }

    throw LocationException.fromApiResponse(response);
  }

  // ------- Mutation -------
}
```

```dart [city_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/entities/city_entity.dart';
import '../../domain/params/city_list_param.dart';
import '../../domain/repositories/city_repository.dart';
import '../datasources/city_remote_data_source.dart';
import '../requests/city_list_request.dart';

class CityRepositoryImpl
    with RepositoryExceptionHandler
    implements CityRepository {
  final AppLogger _log;
  final CityRemoteDataSource _remoteDataSource;

  const CityRepositoryImpl({
    required AppLogger appLogger,
    required CityRemoteDataSource cityRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = cityRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  @override
  AsyncResult<List<CityEntity>> getCityList(CityListParam param) async {
    try {
      final request = CityListRequest.fromParam(param);
      final dtos = await _remoteDataSource.getCityList(request);
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Result.success(entities);
    } catch (e, st) {
      return handleException('cityList', e, st);
    }
  }

  // ------- Mutation -------
}
```

:::

## Logic Layer

::: code-group

```dart [city_list_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/city_entity.dart';
import '../../domain/params/city_list_param.dart';

part 'city_list_state.freezed.dart';

@freezed
abstract class CityListState with _$CityListState {
  const factory CityListState({
    @Default([]) List<CityEntity> list,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoading,
    Failure? failure,
    @Default(CityListParam()) CityListParam param,
  }) = _CityListState;
}
```

```dart [city_list_cubit.dart]
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/usecases/city_list_use_case.dart';
import 'city_list_state.dart';

class CityListCubit extends Cubit<CityListState> {
  final CityListUseCase _useCase;

  CityListCubit({required CityListUseCase cityListUseCase})
    : _useCase = cityListUseCase,
      super(const CityListState());

  Future<void> init() async {
    await refresh();
  }

  Future<void> refresh() async {
    await _getData(page: 1);
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.hasReachedMax) return;
    await _getData(page: state.param.page + 1);
  }

  Future<void> _getData({required int page}) async {
    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
        list: page == 1 ? [] : state.list,
      ),
    );

    final selectedParam = state.param.copyWith(page: page);
    final result = await _useCase(selectedParam);

    emit(
      result.when(
        success: (data) => state.copyWith(
          list: [...state.list, ...data],
          hasReachedMax: data.length < state.param.pageSize,
          isLoading: false,
          param: selectedParam,
        ),
        failure: (failure) =>
            state.copyWith(isLoading: false, failure: failure),
      ),
    );
  }
}
```

:::

## UI Layer

::: code-group

```dart [city_list_view.dart]
import 'package:flutter/material.dart';
import '../../../../../generated/location_localizations.dart';

class CityListView extends StatelessWidget {
  final Widget content;
  const CityListView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final l10n = LocationLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cityListTitle)),
      body: content,
    );
  }
}
```

```dart [city_list_item.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/city_entity.dart';

class CityListItem extends StatelessWidget {
  final CityEntity city;
  final int number;
  final VoidCallback? onTap;
  const CityListItem({
    super.key,
    required this.city,
    required this.number,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: AppLeadingIndex(number: number),
      title: city.name,
      subtitle: city.country,
      onTap: onTap,
      includeChevron: true,
    );
  }
}
```

```dart [city_list_item_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CityListItemSkeleton extends StatelessWidget {
  const CityListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppListTileSkeleton();
  }
}
```


```dart [city_list_content.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/city_entity.dart';
import 'parts/city_list_item.dart';

class CityListContent extends StatefulWidget {
  final Future<void> Function() onPullRefresh;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final List<CityEntity> list;
  final void Function(CityEntity item) onItemTap;

  const CityListContent({
    super.key,
    required this.list,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onPullRefresh,
    required this.onItemTap,
  });

  @override
  State<CityListContent> createState() => _CityListContentState();
}

class _CityListContentState extends State<CityListContent> {
  static const _thresholdLoadMore = 0.9; // 90% of the scroll extent

  late final ScrollController _scrollController;

  void _onScroll() {
    if (_isReachThreshold) {
      widget.onLoadMore();
    }
  }

  bool get _isReachThreshold {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * _thresholdLoadMore) && maxScroll > 0;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: widget.onPullRefresh,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: widget.list.length,
        padding: const EdgeInsets.only(bottom: 80),
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = widget.list[index];
          final tile = CityListItem(
            city: item,
            number: index + 1,
            onTap: () => widget.onItemTap.call(item),
          );
          if (index == widget.list.length - 1) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [tile, if (widget.isLoadingMore) const AppLoading()],
            );
          }
          return tile;
        },
      ),
    );
  }
}
```

```dart [city_list_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'parts/city_list_item_skeleton.dart';

class CityListSkeleton extends StatelessWidget {
  final int itemCount;
  const CityListSkeleton({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => const CityListItemSkeleton(),
      itemCount: itemCount,
      padding: const EdgeInsets.all(AppSpacing.screen),
      separatorBuilder: (context, index) => AppGap.md,
    );
  }
}
```

```dart [city_list_error_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/location_localizations.dart';

class CityListErrorFeedback extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const CityListErrorFeedback({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = LocationLocalizations.of(context)!;
    return AppErrorFeedback(
      title: l10n.cityListErrorTitle,
      message: message,
      retryText: appL10n.refresh,
      onRetry: onRetry,
    );
  }
}
```

```dart [city_list_empty_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/location_localizations.dart';

class CityListEmptyFeedback extends StatelessWidget {
  final VoidCallback onRefresh;
  const CityListEmptyFeedback({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = LocationLocalizations.of(context)!;
    return AppEmptyFeedback(
      title: l10n.cityListEmptyTitle,
      message: l10n.cityListEmptyMessage,
      onRefresh: onRefresh,
      refreshText: appL10n.refresh,
    );
  }
}
```

:::

## Barrel

::: code-group

```dart [city_feature.dart]
// data
export 'data/datasources/city_remote_data_source.dart';
export 'data/datasources/city_remote_data_source_impl.dart';
export 'data/repositories/city_repository_impl.dart';
// domain
export 'domain/entities/city_entity.dart';
export 'domain/repositories/city_repository.dart';
export 'domain/usecases/city_list_use_case.dart';
// logic
export 'logic/list/city_list_cubit.dart';
export 'logic/list/city_list_state.dart';
// ui
export 'ui/list/views/city_list_view.dart';
export 'ui/list/widgets/city_list_content.dart';
export 'ui/list/widgets/city_list_empty_feedback.dart';
export 'ui/list/widgets/city_list_error_feedback.dart';
export 'ui/list/widgets/city_list_skeleton.dart';
```

```dart [location.dart]
export 'src/features/city/city_feature.dart';
export 'src/generated/location_localizations.dart';
export 'src/shared/domain/errors/location_failure.dart';
export 'src/shared/ui/extensions/location_failure_x.dart';
```

:::