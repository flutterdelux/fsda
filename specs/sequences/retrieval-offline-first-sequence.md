# Retrieval + Offline First Sequence (Rof) - Note / Note / List

![sequence](/images/sequences/r-of.png)

```text
title Retrieval + Offline First Sequence (Rof) - Note / Note / List

actor User
participant NoteListPage
participant NoteListCubit
participant NoteListUseCase
participant NoteRepository
participant NetworkInfo
participant NoteRemoteDataSource
participant ApiClient
participant NoteLocalDataSource
participant DatabaseClient

entryspacing 0.5
NoteListPage->NoteListPage: Compose UI + Logic
activate NoteListPage
NoteListPage->NoteListCubit: Create NoteListCubit
activate NoteListCubit
NoteListCubit-->NoteListPage: NoteListState.initial()
NoteListPage-->User: Note list page is visible

NoteListPage->NoteListCubit: getNoteList()
NoteListCubit->NoteListCubit: Emit loading state
NoteListCubit-->NoteListPage: NoteListState.loading()

NoteListCubit->NoteListUseCase: call()
activate NoteListUseCase
NoteListUseCase->NoteRepository: getNoteList()
activate NoteRepository
NoteRepository->NetworkInfo: hasInternetAccess
activate NetworkInfo
NetworkInfo-->NoteRepository: isOnline
deactivate NetworkInfo

alt isOnline == true
    NoteRepository->NoteRemoteDataSource: getNoteList()
    activate NoteRemoteDataSource
    NoteRemoteDataSource->ApiClient: GET /notes
    activate ApiClient
    ApiClient-->NoteRemoteDataSource: ApiResponse
    deactivate ApiClient

    alt remote success
        NoteRemoteDataSource->NoteRemoteDataSource: NoteListResponse.fromJson(response.body)
        NoteRemoteDataSource->NoteRemoteDataSource: data.map(NoteDto.fromJson).toList()
        NoteRemoteDataSource-->NoteRepository: List<NoteDto>
        deactivate NoteRemoteDataSource
        NoteRepository->NoteLocalDataSource: cacheNoteList(data)
        activate NoteLocalDataSource
        NoteLocalDataSource->NoteLocalDataSource: data.map((note) => note.toJson()).toList()
        NoteLocalDataSource->DatabaseClient: insertMany('notes', jsonList)
        activate DatabaseClient
        DatabaseClient-->NoteLocalDataSource: Complete without payload
        deactivate DatabaseClient
        NoteLocalDataSource-->NoteRepository: cached
        deactivate NoteLocalDataSource
    else remote/cache failure
        activate NoteRemoteDataSource
        NoteRemoteDataSource-->NoteRepository: Throw Exception
        deactivate NoteRemoteDataSource
    end
end

NoteRepository->NoteLocalDataSource: getNoteList()
activate NoteLocalDataSource
NoteLocalDataSource->DatabaseClient: findAll('notes')
activate DatabaseClient
DatabaseClient-->NoteLocalDataSource: rows
deactivate DatabaseClient

alt success
    NoteLocalDataSource-->NoteRepository: List<NoteDto>
    deactivate NoteLocalDataSource
    NoteRepository->NoteRepository: dto.toEntity()
    NoteRepository-->NoteListUseCase: Result.success(List<NoteEntity>)
    deactivate NoteRepository
    NoteListUseCase-->NoteListCubit: Forward Result
    deactivate NoteListUseCase
    NoteListCubit->NoteListCubit: Emit loaded state
    NoteListCubit-->NoteListPage: NoteListState.loaded(data)
    deactivate NoteListCubit
    NoteListPage->NoteListPage: Show NoteListContent
else failure
    activate NoteRepository
    activate NoteLocalDataSource
    activate NoteListUseCase
    activate NoteListCubit
    NoteLocalDataSource-->NoteRepository: Throw CoreException.cacheError
    deactivate NoteLocalDataSource
    NoteRepository->NoteRepository: handleException()
    NoteRepository-->NoteListUseCase: Result.failure(failure)
    deactivate NoteRepository
    NoteListUseCase-->NoteListCubit: Forward Result
    deactivate NoteListUseCase
    NoteListCubit->NoteListCubit: Emit failure state
    NoteListCubit-->NoteListPage: NoteListState.failure(failure)
    deactivate NoteListCubit
    NoteListPage->NoteListPage: Show NoteListErrorFeedback
end

deactivate NoteListPage
```
