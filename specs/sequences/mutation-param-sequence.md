# Mutation + Param Sequence

![sequence](/images/sequences/m-p.png)

```text
title Mutation + Param Sequence (Mp) - Finance / Wallet / Delete

actor User
participant WalletPage
participant WalletDeleteCubit
participant WalletDeleteUseCase
participant WalletRepository
participant WalletRemoteDataSource
participant ApiClient

entryspacing 0.5
WalletPage->WalletPage: Compose UI + Logic
activate WalletPage
WalletPage->WalletDeleteCubit: Create WalletDeleteCubit
activate WalletDeleteCubit
WalletDeleteCubit->WalletDeleteCubit: Emit initial state
WalletDeleteCubit-->WalletPage: WalletDeleteState.initial()
WalletPage-->User: Wallet page is visible

User->WalletPage: Tap item "Delete wallet"
WalletPage->WalletPage: Show WalletDeleteDialog
User->WalletPage: Confirm delete
WalletPage->WalletDeleteCubit: deleteWallet(WalletDeleteParam(id))
WalletDeleteCubit->WalletDeleteCubit: Emit loading state
WalletDeleteCubit-->WalletPage: WalletDeleteState.loading()
WalletPage->WalletPage: Show loading overlay

WalletDeleteCubit->WalletDeleteUseCase: call(param)
activate WalletDeleteUseCase
WalletDeleteUseCase->WalletRepository: deleteWallet(param)
activate WalletRepository
WalletRepository->WalletRepository: WalletDeleteRequest.fromParam(param)
WalletRepository->WalletRemoteDataSource: deleteWallet(request)
activate WalletRemoteDataSource
WalletRemoteDataSource->ApiClient: DELETE /wallets/{request.id}
activate ApiClient
ApiClient-->WalletRemoteDataSource: ApiResponse
deactivate ApiClient

alt success
  WalletRemoteDataSource-->WalletRepository: Complete without payload
  deactivate WalletRemoteDataSource
  WalletRepository-->WalletDeleteUseCase: Result.success(null)
  deactivate WalletRepository
  WalletDeleteUseCase-->WalletDeleteCubit: Forward Result
  deactivate WalletDeleteUseCase
  WalletDeleteCubit->WalletDeleteCubit: Emit success state
  WalletDeleteCubit-->WalletPage: WalletDeleteState.success()
  deactivate WalletDeleteCubit
  WalletPage->WalletPage: showSuccessSnackBar()
else failure
  activate WalletRepository
  activate WalletRemoteDataSource
  activate WalletDeleteUseCase
  activate WalletDeleteCubit
  WalletRemoteDataSource->WalletRemoteDataSource: FinanceException.fromApiResponse()
  WalletRemoteDataSource-->WalletRepository: Throw Exception
  deactivate WalletRemoteDataSource
  WalletRepository->WalletRepository: handleException()
  WalletRepository-->WalletDeleteUseCase: Result.failure(failure)
  deactivate WalletRepository
  WalletDeleteUseCase-->WalletDeleteCubit: Forward Result
  deactivate WalletDeleteUseCase
  WalletDeleteCubit->WalletDeleteCubit: Emit failure state
  WalletDeleteCubit-->WalletPage: WalletDeleteState.failure(failure)
  deactivate WalletDeleteCubit
  WalletPage->WalletPage: showErrorSnackBar()
end

deactivate WalletPage
```