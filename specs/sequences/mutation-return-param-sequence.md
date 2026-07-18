# Mutation + Return + Param Sequence

![sequence](/images/sequences/m-rp.png)

```text
title Mutation + Return + Param Sequence (Mrp) - Task / Task / Create

actor User
participant TaskCreatePage
participant TaskCreateFormCubit
participant TaskCreateCubit
participant TaskCreateUseCase
participant TaskRepository
participant TaskRemoteDataSource
participant ApiClient

entryspacing 0.5
TaskCreatePage->TaskCreatePage: Compose UI + Logic
activate TaskCreatePage
TaskCreatePage->TaskCreateFormCubit: Create TaskCreateFormCubit
activate TaskCreateFormCubit
TaskCreateFormCubit->TaskCreateFormCubit: Emit initial state
TaskCreateFormCubit-->TaskCreatePage: TaskCreateFormState(null, null)
TaskCreatePage->TaskCreateCubit: Create TaskCreateCubit
activate TaskCreateCubit
TaskCreateCubit->TaskCreateCubit: Emit initial state
TaskCreateCubit-->TaskCreatePage: TaskCreateState.initial()
TaskCreatePage-->User: Task create page is visible

User->TaskCreatePage: Fill title and description
TaskCreatePage->TaskCreateFormCubit: update(TaskCreateParam, invalidMessage)
User->TaskCreatePage: Tap button "Create Task"
TaskCreatePage->TaskCreateFormCubit: Get TaskCreateParam
TaskCreateFormCubit-->TaskCreatePage: TaskCreateParam
deactivate TaskCreateFormCubit
TaskCreatePage->TaskCreateCubit: createTask(TaskCreateParam)
TaskCreateCubit->TaskCreateCubit: Emit loading state
TaskCreateCubit-->TaskCreatePage: TaskCreateState.loading()

TaskCreateCubit->TaskCreateUseCase: call(param)
activate TaskCreateUseCase
TaskCreateUseCase->TaskRepository: createTask(param)
activate TaskRepository
TaskRepository->TaskRepository: TaskCreateRequest.fromParam(param)
TaskRepository->TaskRemoteDataSource: createTask(request)
activate TaskRemoteDataSource
TaskRemoteDataSource->ApiClient: POST /tasks body: request.toJson()
activate ApiClient
ApiClient-->TaskRemoteDataSource: ApiResponse
deactivate ApiClient

alt success
    TaskRemoteDataSource->TaskRemoteDataSource: TaskCreateResponse.fromJson(response.body)
    TaskRemoteDataSource->TaskRemoteDataSource: TaskDto.fromJson(TaskCreateResponse.data)
    TaskRemoteDataSource-->TaskRepository: TaskDto
    deactivate TaskRemoteDataSource
    TaskRepository->TaskRepository: dto.toEntity()
    TaskRepository-->TaskCreateUseCase: Result.success(TaskEntity)
    deactivate TaskRepository
    TaskCreateUseCase-->TaskCreateCubit: Forward Result
    deactivate TaskCreateUseCase
    TaskCreateCubit->TaskCreateCubit: Emit success state
    TaskCreateCubit-->TaskCreatePage: TaskCreateState.success(data)
    deactivate TaskCreateCubit
    TaskCreatePage->TaskCreatePage: showSuccessSnackBar()
else failure
    activate TaskRepository
    activate TaskRemoteDataSource
    activate TaskCreateUseCase
    activate TaskCreateCubit
    TaskRemoteDataSource->TaskRemoteDataSource: Throw TaskException.fromApiResponse()
    TaskRemoteDataSource-->TaskRepository: Throw Exception
    deactivate TaskRemoteDataSource
    TaskRepository->TaskRepository: handleException()
    TaskRepository-->TaskCreateUseCase: Result.failure(failure)
    deactivate TaskRepository
    TaskCreateUseCase-->TaskCreateCubit: Forward Result
    deactivate TaskCreateUseCase
    TaskCreateCubit->TaskCreateCubit: Emit failure state
    TaskCreateCubit-->TaskCreatePage: TaskCreateState.failure(failure)
    deactivate TaskCreateCubit
    TaskCreatePage->TaskCreatePage: showErrorSnackBar()
end

deactivate TaskCreatePage
```