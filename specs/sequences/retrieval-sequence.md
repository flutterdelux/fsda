# Retrieval Sequence (R) - Travel / Destination / Popular

![sequence](/images/sequences/r.png)

```text
title Retrieval Sequence (R) - Travel / Destination / Popular

actor User
participant DestinationPopularPage
participant DestinationPopularCubit
participant DestinationPopularUseCase
participant DestinationRepository
participant DestinationRemoteDataSource
participant ApiClient

entryspacing 0.5
DestinationPopularPage->DestinationPopularPage: Compose UI + Logic
activate DestinationPopularPage
DestinationPopularPage->DestinationPopularCubit: Create DestinationPopularCubit
activate DestinationPopularCubit
DestinationPopularCubit->DestinationPopularCubit: Emit initial state
DestinationPopularCubit-->DestinationPopularPage: DestinationPopularState.initial()
DestinationPopularPage-->User: Popular section is visible

DestinationPopularPage->DestinationPopularCubit: getPopularDestinationList()
DestinationPopularCubit->DestinationPopularCubit: Emit loading state
DestinationPopularCubit-->DestinationPopularPage: DestinationPopularState.loading()

DestinationPopularCubit->DestinationPopularUseCase: call()
activate DestinationPopularUseCase
DestinationPopularUseCase->DestinationRepository: getPopularDestinationList()
activate DestinationRepository
DestinationRepository->DestinationRemoteDataSource: getPopularDestinationList()
activate DestinationRemoteDataSource
DestinationRemoteDataSource->ApiClient: GET /destinations/popular
activate ApiClient
ApiClient-->DestinationRemoteDataSource: ApiResponse
deactivate ApiClient

alt success
    DestinationRemoteDataSource->DestinationRemoteDataSource: DestinationPopularResponse.fromJson(response.body)
    DestinationRemoteDataSource-->DestinationRepository: List<DestinationDto>
    deactivate DestinationRemoteDataSource
    DestinationRepository->DestinationRepository: map dto.toEntity()
    DestinationRepository-->DestinationPopularUseCase: Result.success(List<DestinationEntity>)
    deactivate DestinationRepository
    DestinationPopularUseCase-->DestinationPopularCubit: Forward Result
    deactivate DestinationPopularUseCase
    
    alt non-empty data
        DestinationPopularCubit->DestinationPopularCubit: Emit loaded state
        DestinationPopularCubit-->DestinationPopularPage: DestinationPopularState.loaded(data)
        DestinationPopularPage->DestinationPopularPage: Show DestinationPopularContent
    else empty data
        DestinationPopularCubit->DestinationPopularCubit: Emit loaded state with empty list
        DestinationPopularCubit-->DestinationPopularPage: DestinationPopularState.loaded([])
        DestinationPopularPage->DestinationPopularPage: Show DestinationPopularEmptyFeedback
    end
    deactivate DestinationPopularCubit
    
else failure
    activate DestinationRepository
    activate DestinationRemoteDataSource
    activate DestinationPopularUseCase
    activate DestinationPopularCubit
    DestinationRemoteDataSource->DestinationRemoteDataSource: throw TravelException.fromApiResponse()
    DestinationRemoteDataSource-->DestinationRepository: Throw Exception
    deactivate DestinationRemoteDataSource
    DestinationRepository->DestinationRepository: handleException()
    DestinationRepository-->DestinationPopularUseCase: Result.failure(failure)
    deactivate DestinationRepository
    DestinationPopularUseCase-->DestinationPopularCubit: Forward Result
    deactivate DestinationPopularUseCase
    DestinationPopularCubit->DestinationPopularCubit: Emit failure state
    DestinationPopularCubit-->DestinationPopularPage: DestinationPopularState.failure(failure)
    deactivate DestinationPopularCubit
    DestinationPopularPage->DestinationPopularPage: Show DestinationPopularErrorFeedback
end

deactivate DestinationPopularPage
```
