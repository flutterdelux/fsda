# Mutation Sequence (M) - Inbox / Inbox / Mark All Read

![sequence](/images/sequences/m.png)

```text
title Mutation Sequence (M) - Inbox / Inbox / Mark All Read

actor User
participant InboxPage
participant InboxMarkAllReadCubit
participant InboxMarkAllReadUseCase
participant InboxRepository
participant InboxRemoteDataSource
participant ApiClient

entryspacing 0.5
InboxPage->InboxPage: Compose UI + Logic
activate InboxPage
InboxPage->InboxMarkAllReadCubit: Create InboxMarkAllReadCubit
activate InboxMarkAllReadCubit
InboxMarkAllReadCubit->InboxMarkAllReadCubit: Emit initial state
InboxMarkAllReadCubit-->InboxPage: InboxMarkAllReadCubit.initial()
InboxPage-->User: Inbox page is visible

User->InboxPage: Tap item "Mark all as read"
InboxPage->InboxPage: onTapMarkAllRead()
InboxPage->InboxMarkAllReadCubit: markAllInboxRead()
InboxMarkAllReadCubit->InboxMarkAllReadCubit: Emit loading state
InboxMarkAllReadCubit-->InboxPage: InboxMarkAllReadState.loading()
InboxPage->InboxPage: Show loading overlay

InboxMarkAllReadCubit->InboxMarkAllReadUseCase: call()
activate InboxMarkAllReadUseCase
InboxMarkAllReadUseCase->InboxRepository: markAllInboxRead()
activate InboxRepository
InboxRepository->InboxRemoteDataSource: markAllRead()
activate InboxRemoteDataSource
InboxRemoteDataSource->ApiClient: PATCH /inboxes/mark-all-read
activate ApiClient
ApiClient-->InboxRemoteDataSource: ApiResponse
deactivate ApiClient

alt success
  InboxRemoteDataSource-->InboxRepository: Complete without payload
  deactivate InboxRemoteDataSource
  InboxRepository-->InboxMarkAllReadUseCase: Result.success()
  deactivate InboxRepository
  InboxMarkAllReadUseCase-->InboxMarkAllReadCubit: Forward Result
  deactivate InboxMarkAllReadUseCase
  InboxMarkAllReadCubit->InboxMarkAllReadCubit: Emit success state
  InboxMarkAllReadCubit-->InboxPage: InboxMarkAllReadState.success()
  deactivate InboxMarkAllReadCubit
  InboxPage->InboxPage: showSuccessSnackBar()
else failure
  activate InboxRepository
  activate InboxRemoteDataSource
  activate InboxMarkAllReadUseCase
  activate InboxMarkAllReadCubit
  InboxRemoteDataSource->InboxRemoteDataSource: InboxException.fromApiResponse
  InboxRemoteDataSource-->InboxRepository: Throw Exception
  deactivate InboxRemoteDataSource
  InboxRepository->InboxRepository: handleException()
  InboxRepository-->InboxMarkAllReadUseCase: Result.failure()
  deactivate InboxRepository
  InboxMarkAllReadUseCase-->InboxMarkAllReadCubit: Forward Result
  deactivate InboxMarkAllReadUseCase
  InboxMarkAllReadCubit->InboxMarkAllReadCubit: Emit failure state
  InboxMarkAllReadCubit-->InboxPage: InboxMarkAllReadState.failure()
  deactivate InboxMarkAllReadCubit
  InboxPage->InboxPage: showErrorSnackBar()
end

deactivate InboxPage
```
