# Retrieval Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| R    | Retrieval                     | travel       | destination | popular       | getPopularDestination()  |


## Shared

::: code-group

```dart [travel_failure.dart]
import 'package:app_core/app_core.dart';

enum TravelFailure implements Failure { travelNotFound, destinationNotFound }
```

```dart [travel_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/travel_localizations.dart';
import '../../domain/errors/travel_failure.dart';

extension TravelFailureX on TravelFailure {
  String localize(BuildContext context) {
    final l10n = TravelLocalizations.of(context)!;
    return switch (this) {
      TravelFailure.travelNotFound => l10n.failureTravelNotFound,
      TravelFailure.destinationNotFound => l10n.failureDestinationNotFound,
    };
  }
}
```

```dart [travel_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/travel_failure.dart';

part 'travel_exception.freezed.dart';

@freezed
sealed class TravelException with _$TravelException implements AppException {
  const TravelException._();

  const factory TravelException.travelNotFound({String? msg, StackTrace? st}) =
      _TravelNotFound;
  const factory TravelException.destinationNotFound({
    String? msg,
    StackTrace? st,
  }) = _DestinationNotFound;

  @override
  String get message => when(
    travelNotFound: (msg, _) => msg ?? 'Travel not found',
    destinationNotFound: (msg, _) => msg ?? 'Destination not found',
  );

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() => when(
    travelNotFound: (_, _) => TravelFailure.travelNotFound,
    destinationNotFound: (_, _) => TravelFailure.destinationNotFound,
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

```arb [travel_en.arb]
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
  "destinationPopularTitle": "Destination Popular",
  "destinationPopularEmptyTitle": "No Destination Found",
  "destinationPopularEmptyMessage": "No destination found at the moment",
  "destinationPopularErrorTitle": "Failed to Load Destination Popular"
}
```

```arb [travel_id.arb]
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
  "destinationPopularTitle": "Destinasi Populer",
  "destinationPopularEmptyTitle": "Tidak Ada Destinasi Ditemukan",
  "destinationPopularEmptyMessage": "Tidak ada destinasi yang ditemukan saat ini",
  "destinationPopularErrorTitle": "Gagal Memuat Destinasi Populer"
}
```

:::

## Domain Layer

::: code-group

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


```dart [destination_repository.dart]
import 'package:app_core/app_core.dart';
import '../entities/destination_entity.dart';

abstract interface class DestinationRepository {
  // ------- Retrieval -------

  AsyncResult<List<DestinationEntity>> getDestinationPopular();

  // ------- Mutation -------
}
```

```dart [destination_use_case.dart]
import 'package:app_core/app_core.dart';

import '../entities/destination_entity.dart';
import '../repositories/destination_repository.dart';

class DestinationPopularUseCase
    extends NoParamUseCase<List<DestinationEntity>> {
  final DestinationRepository _repository;

  const DestinationPopularUseCase({
    required DestinationRepository destinationRepository,
  }) : _repository = destinationRepository;

  @override
  AsyncResult<List<DestinationEntity>> call() =>
      _repository.getDestinationPopular();
}
```

:::

## Data Layer

::: code-group

```dart [destination_dto.dart]
import 'package:app_core/app_core.dart';
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
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
  }) = _DestinationDto;

  factory DestinationDto.fromJson(Map<String, Object?> json) =>
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

```dart [destination_popular_response.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../dtos/destination_dto.dart';

part 'destination_popular_response.freezed.dart';
part 'destination_popular_response.g.dart';

@freezed
abstract class DestinationPopularResponse with _$DestinationPopularResponse {
  const factory DestinationPopularResponse({
    required String status,
    required String message,
    @JsonKey(fromJson: _destinationListFromJson) List<DestinationDto>? data,
    String? code,
    List<String>? errors,
  }) = _DestinationPopularResponse;

  factory DestinationPopularResponse.fromJson(Map<String, dynamic> json) =>
      _$DestinationPopularResponseFromJson(json);
}

List<DestinationDto>? _destinationListFromJson(Object? json) {
  if (json is List) {
    return json
        .map((item) => DestinationDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  return null;
}
```

```dart [destination_remote_data_source.dart]
import '../dtos/destination_dto.dart';

abstract interface class DestinationRemoteDataSource {
  // ------- Retrieval -------

  Future<List<DestinationDto>> getDestinationPopular();

  // ------- Mutation -------
}
```

```dart [destination_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/travel_exception.dart';
import '../dtos/destination_dto.dart';
import '../responses/destination_popular_response.dart';
import 'destination_remote_data_source.dart';

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  final ApiClient _apiClient;

  const DestinationRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  @override
  Future<List<DestinationDto>> getDestinationPopular() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/destinations/popular',
    );
    if (response.statusCode == 200) {
      final destinationPopularResponse = DestinationPopularResponse.fromJson(
        response.body,
      );
      if (destinationPopularResponse.data != null) {
        return destinationPopularResponse.data!;
      }

      throw const CoreException.serverError();
    }

    throw TravelException.fromApiResponse(response, st: StackTrace.current);
  }

  // ------- Mutation -------
}
```

```dart [destination_repository_impl.dart]
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
  AsyncResult<List<DestinationEntity>> getDestinationPopular() async {
    try {
      final dtos = await _remoteDataSource.getDestinationPopular();
      return Result.success(dtos.map((e) => e.toEntity()).toList());
    } catch (e, st) {
      return handleException('getDestinationPopular', e, st);
    }
  }

  // ------- Mutation -------
}
```

:::

## Logic Layer

::: code-group

```dart [destination_popular_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/destination_entity.dart';

part 'destination_popular_state.freezed.dart';

@freezed
sealed class DestinationPopularState with _$DestinationPopularState {
  const factory DestinationPopularState.initial() = _Initial;
  const factory DestinationPopularState.loading() = _Loading;
  const factory DestinationPopularState.loaded({
    required List<DestinationEntity> data,
  }) = _Loaded;
  const factory DestinationPopularState.failure({required Failure failure}) =
      _Failure;
}
```

```dart [destination_popular_cubit.dart]
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/usecases/destination_popular_use_case.dart';
import 'destination_popular_state.dart';

class DestinationPopularCubit extends Cubit<DestinationPopularState> {
  final DestinationPopularUseCase _useCase;

  DestinationPopularCubit({
    required DestinationPopularUseCase destinationPopularUseCase,
  }) : _useCase = destinationPopularUseCase,
       super(const DestinationPopularState.initial());

  Future<void> getDestinationPopular() async {
    emit(const DestinationPopularState.loading());

    final result = await _useCase();

    emit(
      result.when(
        success: (data) => DestinationPopularState.loaded(data: data),
        failure: (failure) => DestinationPopularState.failure(failure: failure),
      ),
    );
  }
}
```

:::

## UI Layer

::: code-group

```dart [destination_popular_item.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/destination_entity.dart';

class DestinationPopularItem extends StatelessWidget {
  static const aspectRatio = 10 / 16;
  static const borderRadius = BorderRadius.all(Radius.circular(16));

  final DestinationEntity destination;
  final VoidCallback onTap;
  const DestinationPopularItem({
    super.key,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.antiAlias,
          fit: StackFit.expand,
          alignment: Alignment.bottomLeft,
          children: [
            AppNetworkImage(
              url: destination.imageUrl,
              fit: BoxFit.cover,
              borderRadius: borderRadius,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: DestinationPopularItem.borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination.name,
                    style: textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  AppGap.xs,
                  Text(
                    destination.description,
                    style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

```dart [destination_popular_item_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'destination_popular_item.dart';

class DestinationPopularItemSkeleton extends StatelessWidget {
  const DestinationPopularItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: DestinationPopularItem.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: const Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Skeleton for title (titleMedium)
                  AppShimmer(width: 120, height: 18, radius: 4),

                  // Provide a small gap specifically for the skeleton to avoid sticking
                  SizedBox(height: 6),

                  // Skeleton for Subtitle
                  AppShimmer(width: 85, height: 10, radius: 2),                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

```dart [destination_popular_content.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/destination_entity.dart';
import 'parts/destination_popular_item.dart';

class DestinationPopularContent extends StatelessWidget {
  static const height = 280.0;

  final List<DestinationEntity> list;
  final void Function(DestinationEntity item) onItemTap;
  const DestinationPopularContent({
    super.key,
    required this.list,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (context, index) => AppGap.md,
        itemBuilder: (context, index) {
          final destination = list[index];
          return DestinationPopularItem(
            destination: destination,
            onTap: () => onItemTap(destination),
          );
        },
      ),
    );
  }
}
```

```dart [destination_popular_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'destination_popular_content.dart';
import 'parts/destination_popular_item_skeleton.dart';

class DestinationPopularSkeleton extends StatelessWidget {
  final int itemCount;
  const DestinationPopularSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DestinationPopularContent.height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (context, index) => AppGap.md,
        itemBuilder: (context, index) {
          return const DestinationPopularItemSkeleton();
        },
      ),
    );
  }
}
```

```dart [destination_popular_error_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/travel_localizations.dart';

class DestinationPopularErrorFeedback extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const DestinationPopularErrorFeedback({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = TravelLocalizations.of(context)!;
    return AppErrorFeedback(
      title: l10n.destinationPopularErrorTitle,
      message: message,
      retryText: appL10n.refresh,
      onRetry: onRetry,
    );
  }
}
```

```dart [destination_popular_empty_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/travel_localizations.dart';

class DestinationPopularEmptyFeedback extends StatelessWidget {
  final VoidCallback onRefresh;
  const DestinationPopularEmptyFeedback({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = TravelLocalizations.of(context)!;
    return AppErrorFeedback(
      title: l10n.destinationPopularEmptyTitle,
      message: l10n.destinationPopularEmptyMessage,
      retryText: appL10n.refresh,
      onRetry: onRefresh,
    );
  }
}
```

```dart [destination_popular_section.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/travel_localizations.dart';

class DestinationPopularSection extends StatelessWidget {
  final Widget content;
  final VoidCallback? onSeeAllPressed;
  const DestinationPopularSection({
    super.key,
    required this.content,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = TravelLocalizations.of(context)!;
    return AppSection(
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        child: AppSectionHeader(
          titleText: l10n.destinationPopularTitle,
          actionText: appL10n.seeAll,
          onActionPressed: onSeeAllPressed,
        ),
      ),
      content: content,
    );
  }
}
```

:::

## Barrel

::: code-group

```dart [destination_feature.dart]
// data
export 'data/datasources/destination_remote_data_source.dart';
export 'data/datasources/destination_remote_data_source_impl.dart';
export 'data/repositories/destination_repository_impl.dart';
// domain
export 'domain/entities/destination_entity.dart';
export 'domain/repositories/destination_repository.dart';
export 'domain/usecases/destination_popular_use_case.dart';
// logic
export 'logic/popular/destination_popular_cubit.dart';
export 'logic/popular/destination_popular_state.dart';
// ui
export 'ui/popular/widgets/destination_popular_content.dart';
export 'ui/popular/widgets/destination_popular_empty_feedback.dart';
export 'ui/popular/widgets/destination_popular_error_feedback.dart';
export 'ui/popular/widgets/destination_popular_section.dart';
export 'ui/popular/widgets/destination_popular_skeleton.dart';
```

```dart [travel.dart]
export 'src/features/destination/destination_feature.dart';
export 'src/generated/travel_localizations.dart';
export 'src/shared/domain/errors/travel_failure.dart';
export 'src/shared/ui/extensions/travel_failure_x.dart';
```

:::