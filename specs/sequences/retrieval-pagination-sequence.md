# Retrieval + Pagination Sequence (Rpag) - Location / City / List

![sequence](/images/sequences/r-pag.png)

```text
title Retrieval + Pagination Sequence (Rpag) - Location / City / List

actor User
participant CityListPage
participant CityListCubit
participant CityListUseCase
participant CityRepository
participant CityRemoteDataSource
participant ApiClient

entryspacing 0.5
CityListPage->CityListPage: Compose UI + Logic
activate CityListPage
CityListPage->CityListCubit: Create CityListCubit
activate CityListCubit
CityListCubit-->CityListPage: CityListState.initial()
CityListPage-->User: City list page is visible

CityListPage->CityListCubit: init()
CityListCubit->CityListCubit: _getData(page: 1)
CityListCubit-->CityListPage: state(isLoading: true, list: [])

CityListCubit->CityListUseCase: call(CityListParam(page: 1, pageSize))
activate CityListUseCase
CityListUseCase->CityRepository: getCityList(param)
activate CityRepository
CityRepository->CityRepository: CityListRequest.fromParam(param)
CityRepository->CityRemoteDataSource: getCityList(request)
activate CityRemoteDataSource
CityRemoteDataSource->ApiClient: GET /cities?{page,pageSize}
activate ApiClient
ApiClient-->CityRemoteDataSource: ApiResponse
deactivate ApiClient

alt success
    CityRemoteDataSource->CityRemoteDataSource: CityListResponse.fromJson(response.body)
    CityRemoteDataSource-->CityRepository: List<CityDto>
    deactivate CityRemoteDataSource
    CityRepository->CityRepository: map dto.toEntity()
    CityRepository-->CityListUseCase: Result.success(List<CityEntity>)
    deactivate CityRepository
    CityListUseCase-->CityListCubit: Forward Result
    deactivate CityListUseCase
    CityListCubit->CityListCubit: Append list and update hasReachedMax
    CityListCubit-->CityListPage: state(isLoading: false, list, hasReachedMax)
    deactivate CityListCubit
    CityListPage->CityListPage: Show CityListContent
else failure
    activate CityRepository
    activate CityRemoteDataSource
    activate CityListUseCase
    activate CityListCubit
    CityRemoteDataSource->CityRemoteDataSource: throw TravelException.fromApiResponse()
    CityRemoteDataSource-->CityRepository: Throw Exception
    deactivate CityRemoteDataSource
    CityRepository->CityRepository: handleException()
    CityRepository-->CityListUseCase: Result.failure(failure)
    deactivate CityRepository
    CityListUseCase-->CityListCubit: Forward Result
    deactivate CityListUseCase
    CityListCubit->CityListCubit: Keep current list and set failure
    CityListCubit-->CityListPage: state(isLoading: false, failure)
    deactivate CityListCubit
    CityListPage->CityListPage: Show CityListErrorFeedback
end

User->CityListPage: Scroll near bottom
CityListPage->CityListCubit: loadMore()
activate CityListCubit
CityListCubit->CityListCubit: _getData(page: state.param.page + 1)
deactivate CityListCubit
deactivate CityListPage
```
