# Retrieval + Stream Sequence (Rs) - Attendance / Attendance / List

![sequence](/images/sequences/r-s.png)

```text
title Retrieval + Stream Sequence (Rs) - Attendance / Attendance / List

actor User
participant AttendanceListPage
participant AttendanceListCubit
participant AttendanceListUseCase
participant AttendanceRepository
participant AttendanceRemoteDataSource
participant ApiClient

entryspacing 0.5
AttendanceListPage->AttendanceListPage: Compose UI + Logic
activate AttendanceListPage
AttendanceListPage->AttendanceListCubit: Create AttendanceListCubit
activate AttendanceListCubit
AttendanceListCubit->AttendanceListCubit: Emit initial state
AttendanceListCubit-->AttendanceListPage: AttendanceListState.initial()
AttendanceListPage-->User: Attendance page is visible

AttendanceListPage->AttendanceListCubit: watchAttendances()
AttendanceListCubit->AttendanceListCubit: Emit loading state
AttendanceListCubit-->AttendanceListPage: AttendanceListState.loading()

AttendanceListCubit->AttendanceListUseCase: call()
activate AttendanceListUseCase
AttendanceListUseCase->AttendanceRepository: watchAttendanceList()
activate AttendanceRepository
AttendanceRepository->AttendanceRemoteDataSource: watchAttendanceList()
activate AttendanceRemoteDataSource
AttendanceRemoteDataSource->ApiClient: stream<List>('/attendances/stream')
activate ApiClient

loop Every stream event
    alt success
        ApiClient-->AttendanceRemoteDataSource: List<Map<String, dynamic>>
        AttendanceRemoteDataSource-->AttendanceRepository: List<AttendanceDto>
        deactivate AttendanceRemoteDataSource
        AttendanceRepository->AttendanceRepository: map dto.toEntity()
        AttendanceRepository-->AttendanceListUseCase: Result.success(List<AttendanceEntity>)
        deactivate AttendanceRepository
        AttendanceListUseCase-->AttendanceListCubit: Forward Result
        deactivate AttendanceListUseCase
        AttendanceListCubit->AttendanceListCubit: Emit loaded state
        AttendanceListCubit-->AttendanceListPage: AttendanceListState.loaded(data)
        deactivate AttendanceListCubit
    else failure
        activate AttendanceRepository
        activate AttendanceRemoteDataSource
        activate AttendanceListUseCase
        activate AttendanceListCubit
        ApiClient-->AttendanceRemoteDataSource: Throw Exception
        deactivate ApiClient
        AttendanceRemoteDataSource-->AttendanceRepository: Throw Exception
        deactivate AttendanceRemoteDataSource
        AttendanceRepository->AttendanceRepository: handleException()
        AttendanceRepository-->AttendanceListUseCase: Result.failure(failure)
        deactivate AttendanceRepository
        AttendanceListUseCase-->AttendanceListCubit: Forward Result
        deactivate AttendanceListUseCase
        AttendanceListCubit->AttendanceListCubit: Emit failure state
        AttendanceListCubit-->AttendanceListPage: AttendanceListState.failure(failure)
        deactivate AttendanceListCubit
    end
end

deactivate AttendanceListPage
```
