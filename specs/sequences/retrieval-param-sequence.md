# Retrieval + Param Sequence (Rp) - Product / Product / Detail

![sequence](/images/sequences/r-p.png)

```text
title Retrieval + Param Sequence (Rp) - Product / Product / Detail

actor User
participant ProductDetailPage
participant ProductDetailCubit
participant ProductDetailUseCase
participant ProductRepository
participant ProductRemoteDataSource
participant ApiClient

entryspacing 0.5
ProductDetailPage->ProductDetailPage: Compose UI + Logic
activate ProductDetailPage
ProductDetailPage->ProductDetailCubit: Create ProductDetailCubit(id)
activate ProductDetailCubit
ProductDetailCubit-->ProductDetailPage: ProductDetailState.initial()
ProductDetailPage-->User: Product detail page is visible

ProductDetailPage->ProductDetailCubit: getProductDetail()
ProductDetailCubit->ProductDetailCubit: Emit loading state
ProductDetailCubit-->ProductDetailPage: ProductDetailState.loading()

ProductDetailCubit->ProductDetailUseCase: call(ProductDetailParam(id))
activate ProductDetailUseCase
ProductDetailUseCase->ProductRepository: getProductDetail(param)
activate ProductRepository
ProductRepository->ProductRepository: ProductDetailRequest(param.id)
ProductRepository->ProductRemoteDataSource: getProductDetail(request)
activate ProductRemoteDataSource
ProductRemoteDataSource->ApiClient: GET /products/{request.id}
activate ApiClient
ApiClient-->ProductRemoteDataSource: ApiResponse
deactivate ApiClient

alt success
    ProductRemoteDataSource->ProductRemoteDataSource: ProductDetailResponse.fromJson(response.body)
    ProductRemoteDataSource-->ProductRepository: ProductDto
    deactivate ProductRemoteDataSource
    ProductRepository->ProductRepository: dto.toEntity()
    ProductRepository-->ProductDetailUseCase: Result.success(ProductEntity)
    deactivate ProductRepository
    ProductDetailUseCase-->ProductDetailCubit: Forward Result
    deactivate ProductDetailUseCase
    ProductDetailCubit->ProductDetailCubit: Emit loaded state
    ProductDetailCubit-->ProductDetailPage: ProductDetailState.loaded(data)
    deactivate ProductDetailCubit
    ProductDetailPage->ProductDetailPage: Show ProductDetailContent
else failure
    activate ProductRepository
    activate ProductRemoteDataSource
    activate ProductDetailUseCase
    activate ProductDetailCubit
    ProductRemoteDataSource->ProductRemoteDataSource: throw ProductException.fromAPiResponse()
    ProductRemoteDataSource-->ProductRepository: Throw Exception
    deactivate ProductRemoteDataSource
    ProductRepository->ProductRepository: handleException()
    ProductRepository-->ProductDetailUseCase: Result.failure(failure)
    deactivate ProductRepository
    ProductDetailUseCase-->ProductDetailCubit: Forward Result
    deactivate ProductDetailUseCase
    ProductDetailCubit->ProductDetailCubit: Emit failure state
    ProductDetailCubit-->ProductDetailPage: ProductDetailState.failure(failure)
    deactivate ProductDetailCubit
    ProductDetailPage->ProductDetailPage: Show ProductDetailError
end

deactivate ProductDetailPage
```
