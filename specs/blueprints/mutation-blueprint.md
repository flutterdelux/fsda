# Mutation Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| M    | Mutation                      | inbox        | inbox       | mark_all_read | markAllInboxRead()       |

## Shared

::: code-group

```dart [inbox_failure.dart]
import 'package:app_core/app_core.dart';

enum InboxFailure implements Failure { inboxNotFound }
```

```dart [inbox_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/inbox_localizations.dart';
import '../../domain/errors/inbox_failure.dart';

extension InboxFailureX on InboxFailure {
  String localize(BuildContext context) {
    final l10n = InboxLocalizations.of(context)!;
    return switch (this) {
      InboxFailure.inboxNotFound => l10n.failureInboxNotFound,
    };
  }
}
```

```dart [inbox_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/inbox_failure.dart';

part 'inbox_exception.freezed.dart';

@freezed
sealed class InboxException with _$InboxException implements AppException {
  const InboxException._();

  const factory InboxException.inboxNotFound({String? msg, StackTrace? st}) =
      _InboxNotFound;

  @override
  String get message => when(inboxNotFound: (msg, _) => msg ?? 'Inbox not found');

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() => when(inboxNotFound: (_, _) => InboxFailure.inboxNotFound);

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

```arb [inbox_en.arb]
{
  "@@locale": "en",
  "@inboxAlt": {
    "description": "========================= Inbox ========================="
  },
  "inboxAlt": "Inbox",
  "failureInboxNotFound": "Inbox not found",
  "inboxMarkAllReadPopupMenuItem": "Mark All Read Inbox",
  "inboxMarkAllReadSuccess": "Mark All Read Inbox successfully",
  "inboxMarkAllReadOverlayMessage": "Mark All Read Inbox..."
}
```

```arb [inbox_id.arb]
{
  "@@locale": "id",
  "@inboxAlt": {
    "description": "========================= Inbox ========================="
  },
  "inboxAlt": "Inbox",
  "failureInboxNotFound": "Inbox tidak ditemukan",
  "inboxMarkAllReadPopupMenuItem": "Tandai Semua Sebagai Dibaca",
  "inboxMarkAllReadSuccess": "Tandai Semua Sebagai Dibaca berhasil",
  "inboxMarkAllReadOverlayMessage": "Menandai Semua Sebagai Dibaca..."
}
```

:::

## Domain Layer

::: code-group

```dart [inbox_repository.dart]
import 'package:app_core/app_core.dart';

abstract interface class InboxRepository {
  // ------- Retrieval -------

  // ------- Mutation -------

  AsyncResult<void> markAllInboxRead();
}
```

```dart [inbox_use_case.dart]
import 'package:app_core/app_core.dart';

import '../repositories/inbox_repository.dart';

class InboxMarkAllReadUseCase extends NoParamUseCase<void> {
  final InboxRepository _repository;

  const InboxMarkAllReadUseCase({required InboxRepository inboxRepository})
    : _repository = inboxRepository;

  @override
  AsyncResult<void> call() => _repository.markAllInboxRead();
}
```

:::

## Data Layer

::: code-group

```dart [inbox_remote_data_source.dart]
abstract interface class InboxRemoteDataSource {
  // ------- Retrieval -------

  // ------- Mutation -------

  Future<void> markAllInboxRead();
}
```

```dart [inbox_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/inbox_exception.dart';
import 'inbox_remote_data_source.dart';

class InboxRemoteDataSourceImpl implements InboxRemoteDataSource {
  final ApiClient _apiClient;

  const InboxRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  // ------- Mutation -------

  @override
  Future<void> markAllInboxRead() async {
    final response = await _apiClient.patch<Map>('/inboxes/mark-all-read');
    if (response.statusCode == 200) return;
    throw InboxException.fromApiResponse(response);
  }
}
```

```dart [inbox_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/repositories/inbox_repository.dart';
import '../datasources/inbox_remote_data_source.dart';

class InboxRepositoryImpl
    with RepositoryExceptionHandler
    implements InboxRepository {
  final AppLogger _log;
  final InboxRemoteDataSource _remoteDataSource;

  const InboxRepositoryImpl({
    required AppLogger appLogger,
    required InboxRemoteDataSource inboxRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = inboxRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  // ------- Mutation -------

  @override
  AsyncResult<void> markAllInboxRead() async {
    try {
      await _remoteDataSource.markAllInboxRead();
      return const Result.success(null);
    } catch (e, st) {
      return handleException('markAllInboxRead', e, st);
    }
  }
}
```

:::

## Logic Layer

::: code-group

```dart [inbox_mark_all_read_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbox_mark_all_read_state.freezed.dart';

@freezed
sealed class InboxMarkAllReadState with _$InboxMarkAllReadState {
  const factory InboxMarkAllReadState.initial() = _Initial;
  const factory InboxMarkAllReadState.loading() = _Loading;
  const factory InboxMarkAllReadState.success() = _Success;
  const factory InboxMarkAllReadState.failure({required Failure failure}) =
      _Failure;
}
```

```dart [inbox_mark_all_read_cubit.dart]
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/usecases/inbox_mark_all_read_use_case.dart';
import 'inbox_mark_all_read_state.dart';

class InboxMarkAllReadCubit extends Cubit<InboxMarkAllReadState> {
  final InboxMarkAllReadUseCase _useCase;

  InboxMarkAllReadCubit({
    required InboxMarkAllReadUseCase inboxMarkAllReadUseCase,
  }) : _useCase = inboxMarkAllReadUseCase,
       super(const InboxMarkAllReadState.initial());

  Future<void> markAllInboxRead() async {
    emit(const InboxMarkAllReadState.loading());

    final result = await _useCase();

    emit(
      result.when(
        success: (_) => const InboxMarkAllReadState.success(),
        failure: (failure) => InboxMarkAllReadState.failure(failure: failure),
      ),
    );
  }
}
```

:::

## UI Layer

::: code-group

```dart [inbox_mark_all_read_popup_menu_item.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/inbox_localizations.dart';

class InboxMarkAllReadPopupMenuItem extends PopupMenuItem {
  static const valueKey = 'inbox_mark_all_read';

  const InboxMarkAllReadPopupMenuItem({super.key, super.onTap})
    : super(value: valueKey, child: const _Child());
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    final l10n = InboxLocalizations.of(context)!;
    return Row(
      children: [
        const Icon(Icons.checklist_rounded, size: 20),
        AppGap.sm,
        Text(l10n.inboxMarkAllReadPopupMenuItem),
      ],
    );
  }
}
```

:::

## Barrel

::: code-group

```dart [inbox_feature.dart]
// data
export 'data/datasources/inbox_remote_data_source.dart';
export 'data/datasources/inbox_remote_data_source_impl.dart';
export 'data/repositories/inbox_repository_impl.dart';
// domain
export 'domain/repositories/inbox_repository.dart';
export 'domain/usecases/inbox_mark_all_read_use_case.dart';
// logic
export 'logic/mark_all_read/inbox_mark_all_read_cubit.dart';
export 'logic/mark_all_read/inbox_mark_all_read_state.dart';
// ui
export 'ui/mark_all_read/widgets/inbox_mark_all_read_popup_menu_item.dart';
```

```dart [inbox.dart]
export 'src/features/inbox/inbox_feature.dart';
export 'src/generated/inbox_localizations.dart';
export 'src/shared/domain/errors/inbox_failure.dart';
export 'src/shared/ui/extensions/inbox_failure_x.dart';
```

:::