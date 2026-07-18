# Mutation + Return + Param Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Mrp  | Mutation + Return + Param     | task         | task        | create        | createTask()             |


## Shared

::: code-group

```dart [task_failure.dart]
import 'package:app_core/app_core.dart';

enum TaskFailure implements Failure { taskNotFound }
```

```dart [task_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/task_localizations.dart';
import '../../domain/errors/task_failure.dart';

extension TaskFailureX on TaskFailure {
  String localize(BuildContext context) {
    final l10n = TaskLocalizations.of(context)!;
    return switch (this) {
      TaskFailure.taskNotFound => l10n.failureTaskNotFound,
    };
  }
}
```

```dart [task_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/task_failure.dart';

part 'task_exception.freezed.dart';

@freezed
sealed class TaskException with _$TaskException implements AppException {
  const TaskException._();

  const factory TaskException.taskNotFound({String? msg, StackTrace? st}) =
      _TaskNotFound;

  @override
  String get message => when(taskNotFound: (msg, _) => msg ?? 'Task not found');

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() => when(taskNotFound: (_, _) => TaskFailure.taskNotFound);

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

```arb [task_en.arb]
{
  "@@locale": "en",
  "@taskAlt": {
    "description": "========================= Task ========================="
  },
  "taskAlt": "Task",
  "failureTaskNotFound": "Task not found",
  "failureTaskFormInvalid": "Please fill in all required fields correctly",
  "taskCreateTitle": "Create Task",
  "taskCreateAction": "Create",
  "taskCreateSuccess": "Task created successfully",
  "taskFieldTitleLabel": "Title",
  "taskFieldTitleHint": "Enter title...",
  "taskFieldTitleInvalidEmpty": "Title cannot be empty",
  "taskFieldDescriptionLabel": "Description",
  "taskFieldDescriptionHint": "Enter description...",
  "taskFieldDescriptionInvalidEmpty": "Description cannot be empty"
}
```

```arb [task_id.arb]
{
  "@@locale": "id",
  "@taskAlt": {
    "description": "========================= Task ========================="
  },
  "taskAlt": "Task",
  "failureTaskNotFound": "Tugas tidak ditemukan",
  "failureTaskFormInvalid": "Harap isi semua input yang diperlukan dengan benar",
  "taskCreateTitle": "Buat Tugas",
  "taskCreateAction": "Buat",
  "taskCreateSuccess": "Tugas berhasil dibuat",
  "taskFieldTitleLabel": "Judul",
  "taskFieldTitleHint": "Masukkan judul...",
  "taskFieldTitleInvalidEmpty": "Judul tidak boleh kosong",
  "taskFieldDescriptionLabel": "Deskripsi",
  "taskFieldDescriptionHint": "Masukkan deskripsi...",
  "taskFieldDescriptionInvalidEmpty": "Deskripsi tidak boleh kosong"
}
```

:::

## Domain Layer

::: code-group

```dart [task_entity.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';

@freezed
abstract class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required int id,
    required String title,
    required String description,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaskEntity;
}
```

```dart [task_create_param.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_create_param.freezed.dart';

@freezed
abstract class TaskCreateParam with _$TaskCreateParam {
  const factory TaskCreateParam({
    required String title,
    required String description,
  }) = _TaskCreateParam;
}
```

```dart [task_repository.dart]
import 'package:app_core/app_core.dart';
import '../entities/task_entity.dart';
import '../params/task_create_param.dart';

abstract interface class TaskRepository {
  // ------- Retrieval -------

  // ------- Mutation -------

  AsyncResult<TaskEntity> createTask(TaskCreateParam param);
}
```

```dart [task_use_case.dart]
import 'package:app_core/app_core.dart';

import '../entities/task_entity.dart';
import '../params/task_create_param.dart';
import '../repositories/task_repository.dart';

class TaskCreateUseCase extends UseCase<TaskEntity, TaskCreateParam> {
  final TaskRepository _repository;

  const TaskCreateUseCase({required TaskRepository taskRepository})
    : _repository = taskRepository;

  @override
  AsyncResult<TaskEntity> call(TaskCreateParam param) {
    return _repository.createTask(param);
  }
}
```

:::

## Data Layer

::: code-group

```dart [task_dto.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/task_entity.dart';

part 'task_dto.freezed.dart';
part 'task_dto.g.dart';

@freezed
abstract class TaskDto with _$TaskDto {
  const TaskDto._();

  const factory TaskDto({
    required int id,
    required String title,
    required String description,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, Object?> json) =>
      _$TaskDtoFromJson(json);

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

```dart [task_create_request.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/params/task_create_param.dart';

part 'task_create_request.freezed.dart';
part 'task_create_request.g.dart';

@freezed
abstract class TaskCreateRequest with _$TaskCreateRequest {
  const TaskCreateRequest._();

  const factory TaskCreateRequest({
    required String title,
    required String description,
  }) = _TaskCreateRequest;

  factory TaskCreateRequest.fromJson(Map<String, Object?> json) =>
      _$TaskCreateRequestFromJson(json);

  factory TaskCreateRequest.fromParam(TaskCreateParam param) {
    return TaskCreateRequest(
      title: param.title,
      description: param.description,
    );
  }
}
```

```dart [task_create_response.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../dtos/task_dto.dart';

part 'task_create_response.freezed.dart';
part 'task_create_response.g.dart';

@freezed
abstract class TaskCreateResponse with _$TaskCreateResponse {
  const factory TaskCreateResponse({
    required String status,
    required String message,
    @JsonKey(fromJson: _taskFromJson) TaskDto? data,
    String? code,
    List<String>? errors,
  }) = _TaskCreateResponse;

  factory TaskCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskCreateResponseFromJson(json);
}

TaskDto? _taskFromJson(Object? json) {
  if (json is Map) {
    return TaskDto.fromJson(json as Map<String, dynamic>);
  }
  return null;
}
```

```dart [task_remote_data_source.dart]
import '../dtos/task_dto.dart';
import '../requests/task_create_request.dart';

abstract interface class TaskRemoteDataSource {
  // ------- Retrieval -------

  // ------- Mutation -------

  Future<TaskDto> createTask(TaskCreateRequest request);
}
```

```dart [task_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/task_exception.dart';
import '../dtos/task_dto.dart';
import '../requests/task_create_request.dart';
import '../responses/task_create_response.dart';
import 'task_remote_data_source.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient _apiClient;

  const TaskRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  // ------- Mutation -------

  @override
  Future<TaskDto> createTask(TaskCreateRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/tasks',
      body: request.toJson(),
    );
    if (response.statusCode == 200) {
      final taskCreateResponse = TaskCreateResponse.fromJson(response.body);
      if (taskCreateResponse.data != null) {
        return taskCreateResponse.data!;
      }

      throw const CoreException.serverError();
    }

    throw TaskException.fromApiResponse(response, st: StackTrace.current);
  }
}
```

```dart [task_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/params/task_create_param.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../requests/task_create_request.dart';

class TaskRepositoryImpl
    with RepositoryExceptionHandler
    implements TaskRepository {
  final AppLogger _log;
  final TaskRemoteDataSource _remoteDataSource;

  const TaskRepositoryImpl({
    required AppLogger appLogger,
    required TaskRemoteDataSource taskRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = taskRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  // ------- Mutation -------

  @override
  AsyncResult<TaskEntity> createTask(TaskCreateParam param) async {
    try {
      final request = TaskCreateRequest.fromParam(param);
      final dto = await _remoteDataSource.createTask(request);
      return Result.success(dto.toEntity());
    } catch (e, st) {
      return handleException('createTask', e, st);
    }
  }
}
```

:::

## Logic Layer

::: code-group

```dart [task_create_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/task_entity.dart';

part 'task_create_state.freezed.dart';

@freezed
sealed class TaskCreateState with _$TaskCreateState {
  const factory TaskCreateState.initial() = _Initial;
  const factory TaskCreateState.loading() = _Loading;
  const factory TaskCreateState.success({required TaskEntity data}) = _Success;
  const factory TaskCreateState.failure({required Failure failure}) = _Failure;
}
```

```dart [task_create_cubit.dart]
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/params/task_create_param.dart';
import '../../domain/usecases/task_create_use_case.dart';
import 'task_create_state.dart';

class TaskCreateCubit extends Cubit<TaskCreateState> {
  final TaskCreateUseCase _useCase;

  TaskCreateCubit({required TaskCreateUseCase useCase})
    : _useCase = useCase,
      super(const TaskCreateState.initial());

  Future<void> createTask(TaskCreateParam param) async {
    emit(const TaskCreateState.loading());

    final result = await _useCase(param);

    emit(
      result.when(
        success: (data) => TaskCreateState.success(data: data),
        failure: (failure) => TaskCreateState.failure(failure: failure),
      ),
    );
  }
}
```

```dart [task_create_form_state.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/params/task_create_param.dart';

part 'task_create_form_state.freezed.dart';

@freezed
abstract class TaskCreateFormState with _$TaskCreateFormState {
  const factory TaskCreateFormState({
    TaskCreateParam? param,
    String? invalidMessage,
  }) = _TaskCreateFormState;
}
```

```dart [task_create_form_cubit.dart]
import 'package:bloc/bloc.dart';

import '../../domain/params/task_create_param.dart';
import 'task_create_form_state.dart';

class TaskCreateFormCubit extends Cubit<TaskCreateFormState> {
  TaskCreateFormCubit() : super(const TaskCreateFormState());

  void update(TaskCreateParam? param, String? invalidMessage) {
    emit(state.copyWith(param: param, invalidMessage: invalidMessage));
  }
}
```

:::

## UI Layer

::: code-group

```dart [task_title_field.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/task_localizations.dart';

class TaskTitleField extends StatelessWidget {
  final TextEditingController controller;
  const TaskTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = TaskLocalizations.of(context)!;
    return AppSection(
      header: AppSectionHeader(titleText: l10n.taskFieldTitleLabel),
      content: AppTextField(
        controller: controller,
        hintText: l10n.taskFieldTitleHint,
      ),
    );
  }
}
```

```dart [task_description_field.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/task_localizations.dart';

class TaskDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  const TaskDescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = TaskLocalizations.of(context)!;
    return AppSection(
      header: AppSectionHeader(titleText: l10n.taskFieldDescriptionLabel),
      content: AppTextField(
        controller: controller,
        hintText: l10n.taskFieldDescriptionHint,
        minLines: 5,
        maxLines: 5,
        textInputAction: TextInputAction.newline,
      ),
    );
  }
}
```

```dart [task_create_view.dart]

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/task_localizations.dart';

class TaskCreateView extends StatelessWidget {
  /// Use `TaskCreateForm`
  final Widget form;

  /// Use `TaskCreateButton`
  final Widget submitButton;

  const TaskCreateView({
    super.key,
    required this.form,
    required this.submitButton,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = TaskLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.taskCreateTitle)),
      body: form,
      bottomNavigationBar: AppBottomContainer(child: submitButton),
    );
  }
}
```

```dart [task_create_form.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/task_localizations.dart';
import '../../../domain/params/task_create_param.dart';
import '../../shared/widgets/task_description_field.dart';
import '../../shared/widgets/task_title_field.dart';

class TaskCreateForm extends StatefulWidget {
  final void Function(
    BuildContext context,
    TaskCreateParam? param,
    String? invalidMessage,
  )
  onListen;
  const TaskCreateForm({super.key, required this.onListen});

  @override
  State<TaskCreateForm> createState() => _TaskCreateFormState();
}

class _TaskCreateFormState extends State<TaskCreateForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  void _onInputChanged() {
    final l10n = TaskLocalizations.of(context)!;

    final title = _titleController.text;
    if (title.isEmpty) {
      widget.onListen(context, null, l10n.taskFieldTitleInvalidEmpty);
      return;
    }

    final description = _descriptionController.text;
    if (description.isEmpty) {
      widget.onListen(context, null, l10n.taskFieldDescriptionInvalidEmpty);
      return;
    }

    final param = TaskCreateParam(title: title, description: description);
    widget.onListen(context, param, null);
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController()..addListener(_onInputChanged);
    _descriptionController = TextEditingController()
      ..addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _titleController
      ..removeListener(_onInputChanged)
      ..dispose();
    _descriptionController
      ..removeListener(_onInputChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        TaskTitleField(controller: _titleController),
        AppGap.lg,
        TaskDescriptionField(controller: _descriptionController),
      ],
    );
  }
}
```

```dart [task_create_button.dart]

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/task_localizations.dart';

class TaskCreateButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  const TaskCreateButton({super.key, required this.isLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = TaskLocalizations.of(context)!;
    return AppSubmitFilledButton(
      text: l10n.taskCreateAction,
      isLoading: isLoading,
      onPressed: isLoading ? null : onPressed,
    );
  }
}
```

:::

## Barrel

::: code-group

```dart [task_feature.dart]
// data
export 'data/datasources/task_remote_data_source.dart';
export 'data/datasources/task_remote_data_source_impl.dart';
export 'data/repositories/task_repository_impl.dart';
// domain
export 'domain/params/task_create_param.dart';
export 'domain/repositories/task_repository.dart';
export 'domain/usecases/task_create_use_case.dart';
// logic
export 'logic/create/task_create_cubit.dart';
export 'logic/create/task_create_form_cubit.dart';
export 'logic/create/task_create_form_state.dart';
export 'logic/create/task_create_state.dart';
// ui
export 'ui/create/views/task_create_view.dart';
export 'ui/create/widgets/task_create_button.dart';
export 'ui/create/widgets/task_create_form.dart';
export 'ui/shared/widgets/task_description_field.dart';
export 'ui/shared/widgets/task_title_field.dart';
```

```dart [task.dart]
export 'src/features/task/task_feature.dart';
export 'src/generated/task_localizations.dart';
export 'src/shared/domain/errors/task_failure.dart';
export 'src/shared/ui/extensions/task_failure_x.dart';
```

:::