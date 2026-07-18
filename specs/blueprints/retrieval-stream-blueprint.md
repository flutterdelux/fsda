# Retrieval + Stream Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rs   | Retrieval + Stream            | attendance   | attendance  | list          | watchAttendanceList()    |


## Shared

::: code-group

```dart [attendance_failure.dart]
import 'package:app_core/app_core.dart';

enum AttendanceFailure implements Failure { attendanceNotFound }
```

```dart [attendance_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/attendance_localizations.dart';
import '../../domain/errors/attendance_failure.dart';

extension AttendanceFailureX on AttendanceFailure {
  String localize(BuildContext context) {
    final l10n = AttendanceLocalizations.of(context)!;
    return switch (this) {
      AttendanceFailure.attendanceNotFound => l10n.failureAttendanceNotFound,
    };
  }
}
```

```dart [attendance_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/attendance_failure.dart';

part 'attendance_exception.freezed.dart';

@freezed
sealed class AttendanceException
    with _$AttendanceException
    implements AppException {
  const AttendanceException._();

  const factory AttendanceException.attendanceNotFound({
    String? msg,
    StackTrace? st,
  }) = _AttendanceNotFound;

  @override
  String get message =>
      when(attendanceNotFound: (msg, _) => msg ?? 'Attendance not found');

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() =>
      when(attendanceNotFound: (_, _) => AttendanceFailure.attendanceNotFound);

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

```arb [attendance_en.arb]
{
  "@@locale": "en",
  "@attendanceAlt": {
    "description": "========================= Attendance ========================="
  },
  "attendanceAlt": "Attendance",
  "failureAttendanceNotFound": "Attendance not found",
  "attendanceListTitle": "Attendance List",
  "attendanceListEmptyTitle": "No Attendance Found",
  "attendanceListEmptyMessage": "No attendance found at the moment",
  "attendanceListErrorTitle": "Failed to Load Attendance List",
  "attendanceTypeClockIn": "Clock In",
  "attendanceTypeClockOut": "Clock Out"
}
```

```arb [attendance_id.arb]
{
  "@@locale": "id",
  "@attendanceAlt": {
    "description": "========================= Attendance ========================="
  },
  "attendanceAlt": "Attendance",
  "failureAttendanceNotFound": "Kehadiran tidak ditemukan",
  "attendanceListTitle": "Daftar Kehadiran",
  "attendanceListEmptyTitle": "Tidak ada kehadiran ditemukan",
  "attendanceListEmptyMessage": "Tidak ada kehadiran yang ditemukan saat ini",
  "attendanceListErrorTitle": "Gagal memuat daftar kehadiran",
  "attendanceTypeClockIn": "Masuk",
  "attendanceTypeClockOut": "Keluar"
}
```

:::

## Domain Layer

::: code-group

```dart [attendance_type.dart]
enum AttendanceType { clockIn, clockOut }
```

```dart [attendance_entity.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/attendance_type.dart';

part 'attendance_entity.freezed.dart';

@freezed
abstract class AttendanceEntity with _$AttendanceEntity {
  const factory AttendanceEntity({
    required int id,
    required String userId,
    required AttendanceType type,
    required DateTime clockAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AttendanceEntity;
}
```

```dart [attendance_repository.dart]
import 'package:app_core/app_core.dart';
import '../entities/attendance_entity.dart';

abstract interface class AttendanceRepository {
  // ------- Retrieval -------

  StreamResult<List<AttendanceEntity>> watchAttendanceList();

  // ------- Mutation -------
}
```

```dart [attendance_use_case.dart]
import 'package:app_core/app_core.dart';

import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class AttendanceListUseCase
    extends NoParamStreamUseCase<List<AttendanceEntity>> {
  final AttendanceRepository _repository;

  const AttendanceListUseCase({
    required AttendanceRepository attendanceRepository,
  }) : _repository = attendanceRepository;

  @override
  StreamResult<List<AttendanceEntity>> call() =>
      _repository.watchAttendanceList();
}
```

:::

## Data Layer

::: code-group

```dart [attendance_type_converter.dart]
import 'package:json_annotation/json_annotation.dart';

import '../../domain/enums/attendance_type.dart';

class AttendanceTypeConverter extends JsonConverter<AttendanceType, String> {
  const AttendanceTypeConverter();

  @override
  AttendanceType fromJson(String json) {
    return switch (json) {
      'clock_in' => AttendanceType.clockIn,
      'clock_out' => AttendanceType.clockOut,
      _ => throw ArgumentError('Invalid attendance type: $json'),
    };
  }

  @override
  String toJson(AttendanceType object) {
    return switch (object) {
      AttendanceType.clockIn => 'clock_in',
      AttendanceType.clockOut => 'clock_out',
    };
  }
}
```

```dart [attendance_dto.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/attendance_entity.dart';
import '../../domain/enums/attendance_type.dart';
import '../converters/attendance_type_converter.dart';

part 'attendance_dto.freezed.dart';
part 'attendance_dto.g.dart';

@freezed
abstract class AttendanceDto with _$AttendanceDto {
  const AttendanceDto._();

  const factory AttendanceDto({
    required int id,
    required String userId,
    @AttendanceTypeConverter() required AttendanceType type,
    @UtcDateTimeConverter() required DateTime clockAt,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
  }) = _AttendanceDto;

  factory AttendanceDto.fromJson(Map<String, Object?> json) =>
      _$AttendanceDtoFromJson(json);

  AttendanceEntity toEntity() {
    return AttendanceEntity(
      id: id,
      userId: userId,
      type: type,
      clockAt: clockAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

```dart [attendance_remote_data_source.dart]
import '../dtos/attendance_dto.dart';

abstract interface class AttendanceRemoteDataSource {
  // ------- Retrieval -------

  Stream<List<AttendanceDto>> watchAttendanceList();

  // ------- Mutation -------
}
```

```dart [attendance_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../dtos/attendance_dto.dart';
import 'attendance_remote_data_source.dart';

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final ApiClient _apiClient;

  const AttendanceRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  @override
  Stream<List<AttendanceDto>> watchAttendanceList() {
    return _apiClient.stream<List>('/attendances/stream').map((data) {
      return data
          .map((e) => AttendanceDto.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  // ------- Mutation -------
}
```

```dart [attendance_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_data_source.dart';

class AttendanceRepositoryImpl
    with RepositoryExceptionHandler
    implements AttendanceRepository {
  final AppLogger _log;
  final AttendanceRemoteDataSource _remoteDataSource;

  const AttendanceRepositoryImpl({
    required AppLogger appLogger,
    required AttendanceRemoteDataSource attendanceRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = attendanceRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  @override
  StreamResult<List<AttendanceEntity>> watchAttendanceList() async* {
    try {
      final stream = _remoteDataSource.watchAttendanceList();

      await for (final dtos in stream) {
        final entities = dtos.map((dto) => dto.toEntity()).toList();
        yield Result.success(entities);
      }
    } catch (e, st) {
      yield handleException('watchAttendanceList', e, st);
    }
  }

  // ------- Mutation -------
}
```

:::

## Logic Layer

::: code-group

```dart [attendance_list_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/attendance_entity.dart';

part 'attendance_list_state.freezed.dart';

@freezed
sealed class AttendanceListState with _$AttendanceListState {
  const factory AttendanceListState.initial() = _Initial;
  const factory AttendanceListState.loading() = _Loading;
  const factory AttendanceListState.loaded({
    required List<AttendanceEntity> data,
  }) = _Loaded;
  const factory AttendanceListState.failure({required Failure failure}) =
      _Failure;
}
```

```dart [attendance_list_cubit.dart]
import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/entities/attendance_entity.dart';
import '../../domain/usecases/attendance_list_use_case.dart';
import 'attendance_list_state.dart';

class AttendanceListCubit extends Cubit<AttendanceListState> {
  final AttendanceListUseCase _useCase;

  StreamSubscription<Result<List<AttendanceEntity>>>? _subscription;

  AttendanceListCubit({required AttendanceListUseCase attendanceListUseCase})
    : _useCase = attendanceListUseCase,
      super(const AttendanceListState.initial());

  void watchAttendanceList() {
    emit(const AttendanceListState.loading());

    _subscription?.cancel();
    _subscription = _useCase().listen(
      (result) {
        emit(
          result.when(
            success: (data) => AttendanceListState.loaded(data: data),
            failure: (failure) => AttendanceListState.failure(failure: failure),
          ),
        );
      },
      onError: (e) {
        emit(
          AttendanceListState.failure(
            failure: CoreException.fromException(
              e.toString(),
              st: StackTrace.current,
            ).toFailure(),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

:::

## UI Layer

::: code-group

```dart [attendance_type_x.dart]
import 'package:flutter/material.dart';

import '../../../../../generated/attendance_localizations.dart';
import '../../../domain/enums/attendance_type.dart';

extension AttendanceTypeX on AttendanceType {
  String localize(BuildContext context) {
    final l10n = AttendanceLocalizations.of(context)!;
    return switch (this) {
      AttendanceType.clockIn => l10n.attendanceTypeClockIn,
      AttendanceType.clockOut => l10n.attendanceTypeClockOut,
    };
  }

  IconData get icon {
    return switch (this) {
      AttendanceType.clockIn => Icons.login,
      AttendanceType.clockOut => Icons.logout,
    };
  }
}
```

```dart [attendance_list_view.dart]
import 'package:flutter/material.dart';
import '../../../../../generated/attendance_localizations.dart';

class AttendanceListView extends StatelessWidget {
  final Widget content;
  const AttendanceListView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final l10n = AttendanceLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.attendanceListTitle)),
      body: content,
    );
  }
}
```

```dart [attendance_list_item.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/attendance_entity.dart';
import '../../../shared/extensions/attendance_type_x.dart';

class AttendanceListItem extends StatelessWidget {
  final int index;
  final AttendanceEntity attendance;
  final void Function() onTap;
  const AttendanceListItem({
    super.key,
    required this.index,
    required this.attendance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: AppLeadingIcon(icon: attendance.type.icon),
      title: attendance.userId,
      subtitle: attendance.clockAt.toString(),
      includeChevron: true,
      onTap: onTap,
    );
  }
}
```

```dart [attendance_list_item_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AttendanceListItemSkeleton extends StatelessWidget {
  const AttendanceListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppListTileSkeleton();
  }
}
```

```dart [attendance_list_content.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/attendance_entity.dart';
import 'parts/attendance_list_item.dart';

class AttendanceListContent extends StatelessWidget {
  final List<AttendanceEntity> list;
  final void Function(AttendanceEntity item) onItemTap;
  const AttendanceListContent({
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
        final attendance = list[index];
        return AttendanceListItem(
          index: index,
          attendance: attendance,
          onTap: () => onItemTap(attendance),
        );
      },
    );
  }
}
```

```dart [attendance_list_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'parts/attendance_list_item_skeleton.dart';

class AttendanceListSkeleton extends StatelessWidget {
  final int itemCount;
  const AttendanceListSkeleton({super.key, this.itemCount = 10});

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
        return const AttendanceListItemSkeleton();
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: itemCount,
    );
  }
}
```

```dart [attendance_list_error_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/attendance_localizations.dart';

class AttendanceListErrorFeedback extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const AttendanceListErrorFeedback({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = AttendanceLocalizations.of(context)!;
    return AppErrorFeedback(
      title: l10n.attendanceListErrorTitle,
      message: message,
      retryText: appL10n.refresh,
      onRetry: onRetry,
    );
  }
}
```

```dart [attendance_list_empty_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/attendance_localizations.dart';

class AttendanceListEmptyFeedback extends StatelessWidget {
  final VoidCallback onRefresh;
  const AttendanceListEmptyFeedback({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = AttendanceLocalizations.of(context)!;
    return AppEmptyFeedback(
      title: l10n.attendanceListEmptyTitle,
      message: l10n.attendanceListEmptyMessage,
      onRefresh: onRefresh,
      refreshText: appL10n.refresh,
    );
  }
}
```

:::

## Barrel

::: code-group

```dart [attendance_feature.dart]
// data
export 'data/datasources/attendance_remote_data_source.dart';
export 'data/datasources/attendance_remote_data_source_impl.dart';
export 'data/repositories/attendance_repository_impl.dart';
// domain
export 'domain/entities/attendance_entity.dart';
export 'domain/repositories/attendance_repository.dart';
export 'domain/usecases/attendance_list_use_case.dart';
// logic
export 'logic/list/attendance_list_cubit.dart';
export 'logic/list/attendance_list_state.dart';
// ui
export 'ui/list/views/attendance_list_view.dart';
export 'ui/list/widgets/attendance_list_content.dart';
export 'ui/list/widgets/attendance_list_empty_feedback.dart';
export 'ui/list/widgets/attendance_list_error_feedback.dart';
export 'ui/list/widgets/attendance_list_skeleton.dart';
```

```dart [attendance.dart]
export 'src/features/attendance/attendance_feature.dart';
export 'src/generated/attendance_localizations.dart';
export 'src/shared/domain/errors/attendance_failure.dart';
export 'src/shared/ui/extensions/attendance_failure_x.dart';
```

:::