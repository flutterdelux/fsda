# Mutation + Return Sequence (Mr) - Queue / Queue / Take

![sequence](/images/sequences/m-r.png)

```text
title Mutation + Return Sequence (Mr) - Queue / Queue / Take

actor User
participant QueuePage
participant QueueTakeCubit
participant QueueTakeUseCase
participant QueueRepository
participant QueueRemoteDataSource
participant ApiClient

entryspacing 0.5
QueuePage->QueuePage: Compose UI + Logic
activate QueuePage
QueuePage->QueueTakeCubit: Create QueueTakeCubit
activate QueueTakeCubit
QueueTakeCubit->QueueTakeCubit: Emit initial state
QueueTakeCubit-->QueuePage: QueueTakeState.initial()
QueuePage-->User: Queue page is visible

User->QueuePage: Tap button "Take Queue"
QueuePage->QueueTakeCubit: takeQueue()
QueueTakeCubit->QueueTakeCubit: Emit loading state
QueueTakeCubit-->QueuePage: QueueTakeState.loading()

QueueTakeCubit->QueueTakeUseCase: call()
activate QueueTakeUseCase
QueueTakeUseCase->QueueRepository: takeQueue()
activate QueueRepository
QueueRepository->QueueRemoteDataSource: takeQueue()
activate QueueRemoteDataSource
QueueRemoteDataSource->ApiClient: POST /queues/take
activate ApiClient
ApiClient-->QueueRemoteDataSource: ApiResponse
deactivate ApiClient

alt success
  QueueRemoteDataSource->QueueRemoteDataSource: QueueTakeResponse.fromJson(response.body)
  QueueRemoteDataSource->QueueRemoteDataSource: QueueDto.fromJson(QueueTakeResponse.data)
  QueueRemoteDataSource-->QueueRepository: QueueDto
  deactivate QueueRemoteDataSource
  QueueRepository->QueueRepository: dto.toEntity()
  QueueRepository-->QueueTakeUseCase: Result.success(QueueEntity)
  deactivate QueueRepository
  QueueTakeUseCase-->QueueTakeCubit: Forward Result
  deactivate QueueTakeUseCase
  QueueTakeCubit->QueueTakeCubit: Emit success state with data
  QueueTakeCubit-->QueuePage: QueueTakeState.success(data)
  deactivate QueueTakeCubit
  QueuePage->QueuePage: Show QueueTakeContent
else failure
  activate QueueRepository
  activate QueueRemoteDataSource
  activate QueueTakeUseCase
  activate QueueTakeCubit
  QueueRemoteDataSource->QueueRemoteDataSource: QueueException.fromApiResponse()
  QueueRemoteDataSource-->QueueRepository: Throw Exception
  deactivate QueueRemoteDataSource
  QueueRepository->QueueRepository: handleException('takeQueue', e, st)
  QueueRepository-->QueueTakeUseCase: Result.failure(failure)
  deactivate QueueRepository
  QueueTakeUseCase-->QueueTakeCubit: Forward Result
  deactivate QueueTakeUseCase
  QueueTakeCubit->QueueTakeCubit: Emit failure state
  QueueTakeCubit-->QueuePage: QueueTakeState.failure(failure)
  deactivate QueueTakeCubit
  QueuePage->QueuePage: Show QueueTakeErrorFeedback
end

deactivate QueuePage
```
