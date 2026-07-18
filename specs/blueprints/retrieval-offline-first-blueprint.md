# Retrieval + Offline First Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rof  | Retrieval + Offline First     | note         | note        | list          | getNoteList()            |


## Shared

::: code-group

```dart [note_failure.dart]
import 'package:app_core/app_core.dart';

enum NoteFailure implements Failure { noteNotFound }
```

```dart [note_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/note_localizations.dart';
import '../../domain/errors/note_failure.dart';

extension NoteFailureX on NoteFailure {
  String localize(BuildContext context) {
    final l10n = NoteLocalizations.of(context)!;
    return switch (this) {
      NoteFailure.noteNotFound => l10n.failureNoteNotFound,
    };
  }
}
```

```dart [note_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/note_failure.dart';

part 'note_exception.freezed.dart';

@freezed
sealed class NoteException with _$NoteException implements AppException {
  const NoteException._();

  const factory NoteException.noteNotFound({String? msg, StackTrace? st}) =
      _NoteNotFound;

  @override
  String get message => when(noteNotFound: (msg, _) => msg ?? 'Note not found');

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() => when(noteNotFound: (_, _) => NoteFailure.noteNotFound);

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

```arb [note_en.arb]
{
  "@@locale": "en",
  "@noteAlt": {
    "description": "========================= Note ========================="
  },
  "noteAlt": "Note",
  "failureNoteNotFound": "Note not found",
  "noteListTitle": "Note List",
  "noteListEmptyTitle": "No Note Found",
  "noteListEmptyMessage": "No note found at the moment",
  "noteListErrorTitle": "Failed to Load Note List"
}
```

```arb [note_id.arb]
{
  "@@locale": "id",
  "@noteAlt": {
    "description": "========================= Note ========================="
  },
  "noteAlt": "Note",
  "failureNoteNotFound": "Catatan tidak ditemukan",
  "noteListTitle": "Daftar Catatan",
  "noteListEmptyTitle": "Tidak Ada Catatan",
  "noteListEmptyMessage": "Tidak ada catatan saat ini",
  "noteListErrorTitle": "Gagal Memuat Daftar Catatan"
}
```

:::

## Domain Layer

::: code-group

```dart [note_entity.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_entity.freezed.dart';

@freezed
abstract class NoteEntity with _$NoteEntity {
  const factory NoteEntity({
    required int id,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NoteEntity;
}
```

```dart [note_repository.dart]
import 'package:app_core/app_core.dart';
import '../entities/note_entity.dart';

abstract interface class NoteRepository {
  // ------- Retrieval -------

  AsyncResult<List<NoteEntity>> getNoteList();

  // ------- Mutation -------
}
```

```dart [note_use_case.dart]
import 'package:app_core/app_core.dart';

import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class NoteListUseCase extends NoParamUseCase<List<NoteEntity>> {
  final NoteRepository _repository;

  const NoteListUseCase({required NoteRepository noteRepository})
    : _repository = noteRepository;

  @override
  AsyncResult<List<NoteEntity>> call() => _repository.getNoteList();
}
```

:::

## Data Layer

::: code-group

```dart [note_dto.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/note_entity.dart';

part 'note_dto.freezed.dart';
part 'note_dto.g.dart';

@freezed
abstract class NoteDto with _$NoteDto {
  const NoteDto._();

  const factory NoteDto({
    required int id,
    required String title,
    required String content,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
  }) = _NoteDto;

  factory NoteDto.fromJson(Map<String, Object?> json) =>
      _$NoteDtoFromJson(json);

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```


```dart [note_list_response.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../dtos/note_dto.dart';

part 'note_list_response.freezed.dart';
part 'note_list_response.g.dart';

@freezed
abstract class NoteListResponse with _$NoteListResponse {
  const factory NoteListResponse({
    required String status,
    required String message,
    Map<String, dynamic>? meta,
    @JsonKey(fromJson: _noteListFromJson) List<NoteDto>? data,
    String? code,
    List<String>? errors,
  }) = _NoteListResponse;

  factory NoteListResponse.fromJson(Map<String, dynamic> json) =>
      _$NoteListResponseFromJson(json);
}

List<NoteDto>? _noteListFromJson(Object? json) {
  if (json is List) {
    return json
        .map((item) => NoteDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  return null;
}
```

```dart [note_remote_data_source.dart]
import '../dtos/note_dto.dart';

abstract interface class NoteRemoteDataSource {
  // ------- Retrieval -------

  Future<List<NoteDto>> getNoteList();

  // ------- Mutation -------
}
```

```dart [note_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/note_exception.dart';
import '../dtos/note_dto.dart';
import '../responses/note_list_response.dart';
import 'note_remote_data_source.dart';

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final ApiClient _apiClient;

  const NoteRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  @override
  Future<List<NoteDto>> getNoteList() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/notes');
    if (response.statusCode == 200) {
      final noteListResponse = NoteListResponse.fromJson(response.body);
      if (noteListResponse.data != null) {
        return noteListResponse.data!;
      }
      throw const NoteException.noteNotFound();
    }
  
    throw NoteException.fromApiResponse(response);
  }

  // ------- Mutation -------
}
```

```dart [note_local_data_source.dart]
import '../dtos/note_dto.dart';

abstract interface class NoteLocalDataSource {
  // ------- Retrieval -------

  Future<List<NoteDto>> getNoteList();
  Future<void> cacheNoteList(List<NoteDto> data);

  // ------- Mutation -------
}
```

```dart [note_local_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../dtos/note_dto.dart';
import 'note_local_data_source.dart';

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final DatabaseClient _client;

  const NoteLocalDataSourceImpl({required DatabaseClient client})
    : _client = client;

  // ------- Retrieval -------

  @override
  Future<List<NoteDto>> getNoteList() async {
    try {
      final rows = await _client.findAll('notes');
      return rows.map((row) => NoteDto.fromJson(row)).toList();
    } catch (e, st) {
      throw CoreException.cacheError(
        msg: 'Failed to load notes from local cache: $e',
        st: st,
      );
    }
  }

  @override
  Future<void> cacheNoteList(List<NoteDto> data) async {
    try {
      await _client.insertMany(
        'notes',
        data.map((item) => item.toJson()).toList(),
      );
    } catch (e, st) {
      throw CoreException.cacheError(
        msg: 'Failed to cache notes to local storage: $e',
        st: st,
      );
    }
  }

  // ------- Mutation -------
}
```

```dart [note_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_data_source.dart';
import '../datasources/note_remote_data_source.dart';

class NoteRepositoryImpl
    with RepositoryExceptionHandler
    implements NoteRepository {
  final AppLogger _log;
  final NetworkInfo _networkInfo;
  final NoteLocalDataSource _localDataSource;
  final NoteRemoteDataSource _remoteDataSource;

  const NoteRepositoryImpl({
    required AppLogger appLogger,
    required NetworkInfo networkInfo,
    required NoteLocalDataSource noteLocalDataSource,
    required NoteRemoteDataSource noteRemoteDataSource,
  }) : _log = appLogger,
       _networkInfo = networkInfo,
       _localDataSource = noteLocalDataSource,
       _remoteDataSource = noteRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  @override
  AsyncResult<List<NoteEntity>> getNoteList() async {
    final isOnline = await _networkInfo.hasInternetAccess;

    if (isOnline) {
      try {
        final noteDtos = await _remoteDataSource.getNoteList();
        await _localDataSource.cacheNoteList(noteDtos);
      } catch (e, st) {
        log.warning(
          'getNoteList refresh cache failed',
          error: e,
          stackTrace: st,
        );
      }
    }

    try {
      final cachedNoteList = await _localDataSource.getNoteList();

      return Result.success(
        cachedNoteList.map((dto) => dto.toEntity()).toList(),
      );
    } catch (e, st) {
      return handleException('getNoteList', e, st);
    }
  }

  // ------- Mutation -------
}
```

:::

## Logic Layer

::: code-group

```dart [note_list_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/note_entity.dart';

part 'note_list_state.freezed.dart';

@freezed
sealed class NoteListState with _$NoteListState {
  const factory NoteListState.initial() = _Initial;
  const factory NoteListState.loading() = _Loading;
  const factory NoteListState.loaded({required List<NoteEntity> data}) =
      _Loaded;
  const factory NoteListState.failure({required Failure failure}) = _Failure;
}
```

```dart [note_list_cubit.dart]
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/usecases/note_list_use_case.dart';
import 'note_list_state.dart';

class NoteListCubit extends Cubit<NoteListState> {
  final NoteListUseCase _useCase;

  NoteListCubit({required NoteListUseCase useCase})
    : _useCase = useCase,
      super(const NoteListState.initial());

  Future<void> getNoteList() async {
    emit(const NoteListState.loading());

    final result = await _useCase();

    emit(
      result.when(
        success: (data) => NoteListState.loaded(data: data),
        failure: (failure) => NoteListState.failure(failure: failure),
      ),
    );
  }
}
```

:::

## UI Layer

::: code-group

```dart [note_list_view.dart]
import 'package:flutter/material.dart';
import '../../../../../generated/note_localizations.dart';

class NoteListView extends StatelessWidget {
  final Widget content;
  const NoteListView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final l10n = NoteLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.noteListTitle)),
      body: content,
    );
  }
}
```

```dart [note_list_item.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/note_entity.dart';

class NoteListItem extends StatelessWidget {
  final int index;
  final NoteEntity note;
  final void Function() onTap;
  const NoteListItem({
    super.key,
    required this.index,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: AppLeadingIndex(number: index + 1),
      title: note.title,
      subtitle: note.content,
      includeChevron: true,
      onTap: onTap,
    );
  }
}
```

```dart [note_list_item_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NoteListItemSkeleton extends StatelessWidget {
  const NoteListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppListTileSkeleton();
  }
}
```

```dart [note_list_content.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/note_entity.dart';
import 'parts/note_list_item.dart';

class NoteListContent extends StatelessWidget {
  final List<NoteEntity> list;
  final void Function(NoteEntity item) onItemTap;
  const NoteListContent({
    super.key,
    required this.list,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(0, 0, 0, AppSpacing.screen + padding.bottom),
      itemCount: list.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final note = list[index];
        return NoteListItem(
          index: index,
          note: note,
          onTap: () => onItemTap(note),
        );
      },
    );
  }
}
```

```dart [note_list_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'parts/note_list_item_skeleton.dart';

class NoteListSkeleton extends StatelessWidget {
  final int itemCount;
  const NoteListSkeleton({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(0, 0, 0, AppSpacing.screen + padding.bottom),
      itemBuilder: (context, index) {
        return const NoteListItemSkeleton();
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: itemCount,
    );
  }
}
```

```dart [note_list_error_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/note_localizations.dart';

class NoteListErrorFeedback extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const NoteListErrorFeedback({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = NoteLocalizations.of(context)!;
    return AppErrorFeedback(
      title: l10n.noteListErrorTitle,
      message: message,
      retryText: appL10n.refresh,
      onRetry: onRetry,
    );
  }
}
```

```dart [note_list_empty_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/note_localizations.dart';

class NoteListEmptyFeedback extends StatelessWidget {
  final VoidCallback onRefresh;
  const NoteListEmptyFeedback({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = NoteLocalizations.of(context)!;
    return AppEmptyFeedback(
      title: l10n.noteListEmptyTitle,
      message: l10n.noteListEmptyMessage,
      onRefresh: onRefresh,
      refreshText: appL10n.refresh,
    );
  }
}
```


:::

## Barrel

::: code-group

```dart [note_feature.dart]
// data
export 'data/datasources/note_local_data_source.dart';
export 'data/datasources/note_local_data_source_impl.dart';
export 'data/datasources/note_remote_data_source.dart';
export 'data/datasources/note_remote_data_source_impl.dart';
export 'data/repositories/note_repository_impl.dart';
// domain
export 'domain/entities/note_entity.dart';
export 'domain/repositories/note_repository.dart';
export 'domain/usecases/note_list_use_case.dart';
// logic
export 'logic/list/note_list_cubit.dart';
export 'logic/list/note_list_state.dart';
// ui
export 'ui/list/views/note_list_view.dart';
export 'ui/list/widgets/note_list_content.dart';
export 'ui/list/widgets/note_list_empty_feedback.dart';
export 'ui/list/widgets/note_list_error_feedback.dart';
export 'ui/list/widgets/note_list_skeleton.dart';
```

```dart [note.dart]
export 'src/features/note/note_feature.dart';
export 'src/generated/note_localizations.dart';
export 'src/shared/domain/errors/note_failure.dart';
export 'src/shared/ui/extensions/note_failure_x.dart';
```

:::