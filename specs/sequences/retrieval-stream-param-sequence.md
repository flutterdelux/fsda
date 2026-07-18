# Retrieval + Stream + Param Sequence (Rsp) - Subscription / Payment / Status

![sequence](/images/sequences/r-sp.png)

```text
title Retrieval + Stream + Param Sequence (Rsp) - Subscription / Payment / Status

actor User
participant PaymentStatusPage
participant PaymentStatusCubit
participant PaymentStatusUseCase
participant PaymentRepository
participant PaymentRemoteDataSource
participant ApiClient

entryspacing 0.5
PaymentStatusPage->PaymentStatusPage: Compose UI + Logic
activate PaymentStatusPage
PaymentStatusPage->PaymentStatusCubit: Create PaymentStatusCubit(id)
activate PaymentStatusCubit
PaymentStatusCubit->PaymentStatusCubit: Emit initial state
PaymentStatusCubit-->PaymentStatusPage: PaymentStatusState.initial()
PaymentStatusPage-->User: Payment status page is visible

PaymentStatusPage->PaymentStatusCubit: watchPaymentStatus()
PaymentStatusCubit->PaymentStatusCubit: Emit loading state
PaymentStatusCubit-->PaymentStatusPage: PaymentStatusState.loading()

PaymentStatusCubit->PaymentStatusUseCase: call(PaymentStatusParam(id))
activate PaymentStatusUseCase
PaymentStatusUseCase->PaymentRepository: watchPaymentStatus(param)
activate PaymentRepository
PaymentRepository->PaymentRepository: PaymentStatusRequest.fromParam(param)
PaymentRepository->PaymentRemoteDataSource: watchPaymentStatus(request)
activate PaymentRemoteDataSource
PaymentRemoteDataSource->ApiClient: STREAM '/payments/{id}/status/stream'
activate ApiClient

loop Every stream event
    alt success
        ApiClient-->PaymentRemoteDataSource: Map<String, dynamic>
        PaymentRemoteDataSource-->PaymentRepository: PaymentDto
        deactivate PaymentRemoteDataSource
        PaymentRepository->PaymentRepository: dto.toEntity()
        PaymentRepository-->PaymentStatusUseCase: Result.success(PaymentEntity)
        deactivate PaymentRepository
        PaymentStatusUseCase-->PaymentStatusCubit: Forward Result
        deactivate PaymentStatusUseCase
        PaymentStatusCubit->PaymentStatusCubit: Emit loaded state
        PaymentStatusCubit-->PaymentStatusPage: PaymentStatusState.loaded(data)
        deactivate PaymentStatusCubit
    else failure
        activate PaymentRepository
        activate PaymentRemoteDataSource
        activate PaymentStatusUseCase
        activate PaymentStatusCubit
        ApiClient-->PaymentRemoteDataSource: Throw Exception
        deactivate ApiClient
        PaymentRemoteDataSource-->PaymentRepository: Throw SubscriptionException
        deactivate PaymentRemoteDataSource
        PaymentRepository->PaymentRepository: handleException()
        PaymentRepository-->PaymentStatusUseCase: Result.failure(failure)
        deactivate PaymentRepository
        PaymentStatusUseCase-->PaymentStatusCubit: Forward Result
        deactivate PaymentStatusUseCase
        PaymentStatusCubit->PaymentStatusCubit: Emit failure state
        PaymentStatusCubit-->PaymentStatusPage: PaymentStatusState.failure(failure)
        deactivate PaymentStatusCubit
    end
end

deactivate PaymentStatusPage
```
