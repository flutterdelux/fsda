# Mutation + Return Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Mr   | Mutation + Return             | queue        | queue       | take          | takeQueue()              |


## Shared

::: code-group

```dart [queue_failure.dart]
import 'package:app_core/app_core.dart';

enum QueueFailure implements Failure { queueNotFound }
```

```dart [queue_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/queue_localizations.dart';
import '../../domain/errors/queue_failure.dart';

extension QueueFailureX on QueueFailure {
  String localize(BuildContext context) {
    final l10n = QueueLocalizations.of(context)!;
    return switch (this) {
      QueueFailure.queueNotFound => l10n.failureQueueNotFound,
    };
  }
}
```

```dart [queue_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/queue_failure.dart';

part 'queue_exception.freezed.dart';

@freezed
sealed class QueueException with _$QueueException implements AppException {
  const QueueException._();

  const factory QueueException.queueNotFound({String? msg, StackTrace? st}) =
      _QueueNotFound;

  @override
  String get message => when(queueNotFound: (msg, _) => msg ?? 'Queue not found');

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() => when(queueNotFound: (_, _) => QueueFailure.queueNotFound);

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

```arb [queue_en.arb]
{
  "@@locale": "en",
  "@queueAlt": {
    "description": "========================= Queue ========================="
  },
  "queueAlt": "Queue",
  "failureQueueNotFound": "Queue not found",
  "queueTakeTitle": "Queue Take",
  "queueTakeErrorTitle": "Failed to Load Queue",
  "queueTakeAction": "Take Queue",
  "queueTakeInitialMessage": "You have not taken a queue yet. Please take a queue to proceed.",
  "queueStatusLabel": "Status",
  "queueStatusWaiting": "Waiting",
  "queueStatusCalled": "Called",
  "queueStatusCompleted": "Completed"
}
```

```arb [queue_id.arb]
{
  "@@locale": "id",
  "@queueAlt": {
    "description": "========================= Queue ========================="
  },
  "queueAlt": "Queue",
  "failureQueueNotFound": "Antrian tidak ditemukan",
  "queueTakeTitle": "Ambil Antrian",
  "queueTakeErrorTitle": "Gagal Memuat Antrian",
  "queueTakeAction": "Ambil Antrian",
  "queueTakeInitialMessage": "Anda belum mengambil antrian. Silakan ambil antrian untuk melanjutkan.",
  "queueStatusLabel": "Status",
  "queueStatusWaiting": "Menunggu",
  "queueStatusCalled": "Dipanggil",
  "queueStatusCompleted": "Selesai"
}
```

:::

## Domain Layer

::: code-group

```dart [queue_status.dart]
enum QueueStatus { waiting, called, completed }
```

```dart [queue_entity.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/queue_status.dart';

part 'queue_entity.freezed.dart';

@freezed
abstract class QueueEntity with _$QueueEntity {
  const factory QueueEntity({
    required int id,
    required String queueNumber,
    required QueueStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QueueEntity;
}
```


```dart [queue_repository.dart]
import 'package:app_core/app_core.dart';
import '../entities/queue_entity.dart';

abstract interface class QueueRepository {
  // ------- Retrieval -------

  // ------- Mutation -------

  AsyncResult<QueueEntity> takeQueue();
}
```

```dart [queue_take_use_case.dart]
import 'package:app_core/app_core.dart';

import '../entities/queue_entity.dart';
import '../repositories/queue_repository.dart';

class QueueTakeUseCase extends NoParamUseCase<QueueEntity> {
  final QueueRepository _repository;

  const QueueTakeUseCase({required QueueRepository queueRepository})
    : _repository = queueRepository;

  @override
  AsyncResult<QueueEntity> call() => _repository.takeQueue();
}
```

:::

## Data Layer

::: code-group

```dart [queue_status_converter.dart]
import 'package:json_annotation/json_annotation.dart';

import '../../domain/enums/queue_status.dart';

class QueueStatusConverter extends JsonConverter<QueueStatus, String> {
  const QueueStatusConverter();

  @override
  QueueStatus fromJson(String json) {
    return switch (json) {
      'waiting' => QueueStatus.waiting,
      'called' => QueueStatus.called,
      'completed' => QueueStatus.completed,
      _ => throw ArgumentError('Unknown QueueStatus: $json'),
    };
  }

  @override
  String toJson(QueueStatus object) {
    return switch (object) {
      QueueStatus.waiting => 'waiting',
      QueueStatus.called => 'called',
      QueueStatus.completed => 'completed',
    };
  }
}
```

```dart [queue_dto.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/queue_entity.dart';
import '../../domain/enums/queue_status.dart';
import '../converters/queue_status_converter.dart';

part 'queue_dto.freezed.dart';
part 'queue_dto.g.dart';

@freezed
abstract class QueueDto with _$QueueDto {
  const QueueDto._();

  const factory QueueDto({
    required int id,
    required String queueNumber,
    @QueueStatusConverter() required QueueStatus status,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
  }) = _QueueDto;

  factory QueueDto.fromJson(Map<String, dynamic> json) =>
      _$QueueDtoFromJson(json);

  QueueEntity toEntity() {
    return QueueEntity(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      queueNumber: queueNumber,
      status: status,
    );
  }
}
```

```dart [queue_take_response.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../dtos/queue_dto.dart';

part 'queue_take_response.freezed.dart';
part 'queue_take_response.g.dart';

@freezed
abstract class QueueTakeResponse with _$QueueTakeResponse {
  const factory QueueTakeResponse({
    required String status,
    required String message,
    @JsonKey(fromJson: _queueFromJson) QueueDto? data,
    String? code,
    List<String>? errors,
  }) = _QueueTakeResponse;

  factory QueueTakeResponse.fromJson(Map<String, dynamic> json) =>
      _$QueueTakeResponseFromJson(json);
}

QueueDto? _queueFromJson(Object? json) {
  if (json is Map) {
    return QueueDto.fromJson(json as Map<String, dynamic>);
  }
  return null;
}
```

```dart [queue_remote_data_source.dart]
import '../dtos/queue_dto.dart';

abstract interface class QueueRemoteDataSource {
  // ------- Retrieval -------

  // ------- Mutation -------

  Future<QueueDto> takeQueue();
}
```

```dart [queue_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/queue_exception.dart';
import '../dtos/queue_dto.dart';
import '../responses/queue_take_response.dart';
import 'queue_remote_data_source.dart';

class QueueRemoteDataSourceImpl implements QueueRemoteDataSource {
  final ApiClient _apiClient;

  const QueueRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  // ------- Mutation -------

  @override
  Future<QueueDto> takeQueue() async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/queues/take',
    );

    if (response.statusCode == 200) {
      final queueTakeResponse = QueueTakeResponse.fromJson(response.body);
      if (queueTakeResponse.data != null) {
        return queueTakeResponse.data!;
      }
      throw const CoreException.serverError();
    }

    throw QueueException.fromApiResponse(response);
  }
}
```

```dart [queue_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/entities/queue_entity.dart';
import '../../domain/repositories/queue_repository.dart';
import '../datasources/queue_remote_data_source.dart';

class QueueRepositoryImpl
    with RepositoryExceptionHandler
    implements QueueRepository {
  final AppLogger _log;
  final QueueRemoteDataSource _remoteDataSource;

  const QueueRepositoryImpl({
    required AppLogger appLogger,
    required QueueRemoteDataSource queueRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = queueRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  // ------- Mutation -------

  @override
  AsyncResult<QueueEntity> takeQueue() async {
    try {
      final dto = await _remoteDataSource.takeQueue();
      final entity = dto.toEntity();
      return Result.success(entity);
    } catch (e, st) {
      return handleException('takeQueue', e, st);
    }
  }
}
```

:::

## Logic Layer

::: code-group

```dart [queue_take_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/queue_entity.dart';

part 'queue_take_state.freezed.dart';

@freezed
sealed class QueueTakeState with _$QueueTakeState {
  const factory QueueTakeState.initial() = _Initial;
  const factory QueueTakeState.loading() = _Loading;
  const factory QueueTakeState.success({required QueueEntity data}) = _Success;
  const factory QueueTakeState.failure({required Failure failure}) = _Failure;
}
```

```dart [queue_take_cubit.dart]
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/usecases/queue_take_use_case.dart';
import 'queue_take_state.dart';

class QueueTakeCubit extends Cubit<QueueTakeState> {
  final QueueTakeUseCase _useCase;

  QueueTakeCubit({required QueueTakeUseCase queueTakeUseCase})
    : _useCase = queueTakeUseCase,
      super(const QueueTakeState.initial());

  Future<void> takeQueue() async {
    emit(const QueueTakeState.loading());

    final result = await _useCase();

    emit(
      result.when(
        success: (data) => QueueTakeState.success(data: data),
        failure: (failure) => QueueTakeState.failure(failure: failure),
      ),
    );
  }
}
```

:::

## UI Layer

::: code-group

```dart [queue_status_x.dart]
import 'package:flutter/material.dart';

import '../../../../../generated/queue_localizations.dart';
import '../../../domain/enums/queue_status.dart';

extension QueueStatusX on QueueStatus {
  String localize(BuildContext context) {
    final l10n = QueueLocalizations.of(context)!;
    return switch (this) {
      QueueStatus.waiting => l10n.queueStatusWaiting,
      QueueStatus.called => l10n.queueStatusCalled,
      QueueStatus.completed => l10n.queueStatusCompleted,
    };
  }

  Color get color {
    return switch (this) {
      QueueStatus.waiting => Colors.orange,
      QueueStatus.called => Colors.blue,
      QueueStatus.completed => Colors.green,
    };
  }
}
```

```dart [queue_take_view.dart]
import 'package:flutter/material.dart';
import '../../../../../generated/queue_localizations.dart';

class QueueTakeView extends StatelessWidget {
  final Widget content;
  const QueueTakeView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final l10n = QueueLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.queueTakeTitle)),
      body: content,
    );
  }
}
```

```dart [queue_take_content.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/queue_localizations.dart';
import '../../../domain/entities/queue_entity.dart';
import '../../shared/extensions/queue_status_x.dart';

class QueueTakeContent extends StatelessWidget {
  final QueueEntity queue;
  final VoidCallback? onTakeQueue;
  const QueueTakeContent({super.key, required this.queue, this.onTakeQueue});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = QueueLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(queue.queueNumber, style: textTheme.displayLarge),
          AppGap.md,
          Text('${l10n.queueStatusLabel}:', style: textTheme.bodyMedium),
          AppGap.sm,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            decoration: BoxDecoration(
              color: queue.status.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Text(
              queue.status.localize(context),
              style: textTheme.titleMedium,
            ),
          ),
          AppGap.lg,
          FilledButton(
            onPressed: onTakeQueue,
            child: Text(l10n.queueTakeAction),
          ),
        ],
      ),
    );
  }
}
```

```dart [queue_take_error_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/queue_localizations.dart';

class QueueTakeErrorFeedback extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const QueueTakeErrorFeedback({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = QueueLocalizations.of(context)!;
    return AppErrorFeedback(
      title: l10n.queueTakeErrorTitle,
      message: message,
      onRetry: onRetry,
      retryText: appL10n.retry,
    );
  }
}
```

```dart [queue_take_initial_feedback.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/queue_localizations.dart';

class QueueTakeInitialFeedback extends StatelessWidget {
  final VoidCallback? onTakeQueue;
  const QueueTakeInitialFeedback({super.key, this.onTakeQueue});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = QueueLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.queueTakeInitialMessage,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppGap.lg,
            FilledButton(
              onPressed: onTakeQueue,
              child: Text(l10n.queueTakeAction),
            ),
          ],
        ),
      ),
    );
  }
}
```

```dart [queue_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class QueueTakeSkeleton extends StatelessWidget {
  const QueueTakeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppShimmer(width: 140, height: 40, radius: 8),
          AppGap.md,
          AppShimmer(width: 100, height: 16),
          AppGap.sm,
          AppShimmer(width: 120, height: 36, radius: AppRadius.button),
        ],
      ),
    );
  }
}
```

:::

## Barrel

::: code-group

```dart [queue_feature.dart]
// data
export 'data/datasources/queue_remote_data_source.dart';
export 'data/datasources/queue_remote_data_source_impl.dart';
export 'data/repositories/queue_repository_impl.dart';
// domain
export 'domain/entities/queue_entity.dart';
export 'domain/repositories/queue_repository.dart';
export 'domain/usecases/queue_take_use_case.dart';
// logic
export 'logic/take/queue_take_cubit.dart';
export 'logic/take/queue_take_state.dart';
// ui
export 'ui/take/views/queue_take_view.dart';
export 'ui/take/widgets/queue_take_content.dart';
export 'ui/take/widgets/queue_take_error_feedback.dart';
export 'ui/take/widgets/queue_take_initial_feedback.dart';
export 'ui/take/widgets/queue_take_skeleton.dart';
```

```dart [queue.dart]
export 'src/features/queue/queue_feature.dart';
export 'src/generated/queue_localizations.dart';
export 'src/shared/domain/errors/queue_failure.dart';
export 'src/shared/ui/extensions/queue_failure_x.dart';
```

:::