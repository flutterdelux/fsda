# Mutation + Param Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Mp   | Mutation + Param              | finance      | wallet      | delete        | deleteWallet()           |


## Shared

::: code-group

```dart [finance_failure.dart]
import 'package:app_core/app_core.dart';

enum FinanceFailure implements Failure { financeNotFound, walletNotFound }
```

```dart [finance_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/finance_localizations.dart';
import '../../domain/errors/finance_failure.dart';

extension FinanceFailureX on FinanceFailure {
  String localize(BuildContext context) {
    final l10n = FinanceLocalizations.of(context)!;
    return switch (this) {
      FinanceFailure.financeNotFound => l10n.failureFinanceNotFound,
      FinanceFailure.walletNotFound => l10n.failureWalletNotFound,

    };
  }
}
```

```dart [finance_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/finance_failure.dart';

part 'finance_exception.freezed.dart';

@freezed
sealed class FinanceException with _$FinanceException implements AppException {
  const FinanceException._();

  const factory FinanceException.financeNotFound({
    String? msg,
    StackTrace? st,
  }) = _FinanceNotFound;
  const factory FinanceException.walletNotFound({String? msg, StackTrace? st}) =
      _WalletNotFound;

  @override
  String get message => when(
    financeNotFound: (msg, _) => msg ?? 'Finance not found',
    walletNotFound: (msg, _) => msg ?? 'Wallet not found',
  );

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() => when(
    financeNotFound: (_, _) => FinanceFailure.financeNotFound,
    walletNotFound: (_, _) => FinanceFailure.walletNotFound,
  );

  static AppException fromApiResponse(ApiResponse response, {StackTrace? st}) {
    return CoreException.fromException(response.body.toString(), st: st);
  }

  static AppException fromException(
    Object e, {
    StackTrace? st,
    bool isLocal = false,
  }) {
    if (e is AppException) {
      return e;
    }

    return CoreException.fromException(e, st: st, isLocal: isLocal);
  }
}
```

:::

## L10n

::: code-group

```arb [finance_en.arb]
{
  "@@locale": "en",
  "@failureFinanceNotFound": {
    "description": "========================= Failure ========================="
  },
  "failureFinanceNotFound": "Finance not found",
  "failureWalletNotFound": "Wallet not found",
  "@walletAlt": {
    "description": "========================= Wallet ========================="
  },
  "walletAlt": "Wallet",
  "walletDeletePopupMenuItem": "Delete Wallet",
  "walletDeleteSuccess": "Delete Wallet successfully",
  "walletDeleteOverlayMessage": "Delete Wallet...",
  "walletDeleteDialogTitle": "Delete Wallet",
  "walletDeleteDialogMessage": "Are you sure you want to Delete this Wallet?",
  "walletDeleteDialogConfirm": "Yes",
  "walletDeleteDialogCancel": "Cancel"
}
```

```arb [finance_id.arb]
{
  "@@locale": "id",
  "@failureFinanceNotFound": {
    "description": "========================= Failure ========================="
  },
  "failureFinanceNotFound": "Finance tidak ditemukan",
  "failureWalletNotFound": "Wallet tidak ditemukan",
  "@walletAlt": {
    "description": "========================= Wallet ========================="
  },
  "walletAlt": "Wallet",
  "walletDeletePopupMenuItem": "Hapus Dompet",
  "walletDeleteSuccess": "Berhasil menghapus Dompet",
  "walletDeleteOverlayMessage": "Menghapus Dompet...",
  "walletDeleteDialogTitle": "Hapus Dompet",
  "walletDeleteDialogMessage": "Apakah Anda yakin ingin menghapus Dompet ini?",
  "walletDeleteDialogConfirm": "Ya",
  "walletDeleteDialogCancel": "Batal"
}
```

:::

## Domain Layer

::: code-group

```dart [wallet_delete_param.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_delete_param.freezed.dart';

@freezed
abstract class WalletDeleteParam with _$WalletDeleteParam {
  const factory WalletDeleteParam({required int id}) = _WalletDeleteParam;
}
```

```dart [wallet_repository.dart]
import 'package:app_core/app_core.dart';
import '../params/wallet_delete_param.dart';

abstract interface class WalletRepository {
  // ------- Retrieval -------

  // ------- Mutation -------

  AsyncResult<void> deleteWallet(WalletDeleteParam param);
}
```

```dart [wallet_delete_use_case.dart]
import 'package:app_core/app_core.dart';

import '../params/wallet_delete_param.dart';
import '../repositories/wallet_repository.dart';

class WalletDeleteUseCase extends UseCase<void, WalletDeleteParam> {
  final WalletRepository _repository;

  const WalletDeleteUseCase({required WalletRepository walletRepository})
    : _repository = walletRepository;

  @override
  AsyncResult<void> call(WalletDeleteParam param) {
    return _repository.deleteWallet(param);
  }
}
```

:::

## Data Layer

::: code-group

```dart [wallet_delete_request.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/params/wallet_delete_param.dart';

part 'wallet_delete_request.freezed.dart';

@freezed
abstract class WalletDeleteRequest with _$WalletDeleteRequest {
  const WalletDeleteRequest._();

  const factory WalletDeleteRequest({required int id}) = _WalletDeleteRequest;

  factory WalletDeleteRequest.fromParam(WalletDeleteParam param) {
    return WalletDeleteRequest(id: param.id);
  }
}
```

```dart [wallet_remote_data_source.dart]
import '../requests/wallet_delete_request.dart';

abstract interface class WalletRemoteDataSource {
  // ------- Retrieval -------

  // ------- Mutation -------

  Future<void> deleteWallet(WalletDeleteRequest request);
}
```

```dart [wallet_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/finance_exception.dart';
import '../requests/wallet_delete_request.dart';
import 'wallet_remote_data_source.dart';

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiClient _apiClient;

  const WalletRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  // ------- Mutation -------

  @override
  Future<void> deleteWallet(WalletDeleteRequest request) async {
    final response = await _apiClient.delete<Map>('/wallets/${request.id}');
    if (response.statusCode == 200) return;
    throw FinanceException.fromApiResponse(response);
  }
}
```

```dart [finance_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/params/wallet_delete_param.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';
import '../requests/wallet_delete_request.dart';

class WalletRepositoryImpl
    with RepositoryExceptionHandler
    implements WalletRepository {
  final AppLogger _log;
  final WalletRemoteDataSource _remoteDataSource;

  const WalletRepositoryImpl({
    required AppLogger appLogger,
    required WalletRemoteDataSource walletRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = walletRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  // ------- Mutation -------

  @override
  AsyncResult<void> deleteWallet(WalletDeleteParam param) async {
    final request = WalletDeleteRequest.fromParam(param);

    try {
      await _remoteDataSource.deleteWallet(request);
      return const Result.success(null);
    } catch (e, st) {
      return handleException('deleteWallet', e, st);
    }
  }
}
```

:::

## Logic Layer

::: code-group

```dart [wallet_delete_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_delete_state.freezed.dart';

@freezed
sealed class WalletDeleteState with _$WalletDeleteState {
  const factory WalletDeleteState.initial() = _Initial;
  const factory WalletDeleteState.loading() = _Loading;
  const factory WalletDeleteState.success() = _Success;
  const factory WalletDeleteState.failure({required Failure failure}) =
      _Failure;
}
```

```dart [wallet_delete_cubit.dart]
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/params/wallet_delete_param.dart';
import '../../domain/usecases/wallet_delete_use_case.dart';
import 'wallet_delete_state.dart';

class WalletDeleteCubit extends Cubit<WalletDeleteState> {
  final WalletDeleteUseCase _useCase;

  WalletDeleteCubit({required WalletDeleteUseCase walletDeleteUseCase})
    : _useCase = walletDeleteUseCase,
      super(const WalletDeleteState.initial());

  Future<void> deleteWallet(WalletDeleteParam param) async {
    emit(const WalletDeleteState.loading());

    final result = await _useCase(param);

    emit(
      result.when(
        success: (_) => const WalletDeleteState.success(),
        failure: (failure) => WalletDeleteState.failure(failure: failure),
      ),
    );
  }
}
```

:::

## UI Layer

::: code-group

```dart [wallet_delete_popup_menu_item.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/finance_localizations.dart';

class WalletDeletePopupMenuItem extends PopupMenuItem {
  static const valueKey = 'wallet_delete';

  const WalletDeletePopupMenuItem({super.key, super.onTap})
    : super(value: valueKey, child: const _Child());
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    final l10n = FinanceLocalizations.of(context)!;
    return Row(
      children: [
        const Icon(Icons.delete, size: 20),
        AppGap.sm,
        Text(l10n.walletDeletePopupMenuItem),
      ],
    );
  }
}
```

```dart [wallet_delete_dialog.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/finance_localizations.dart';

class WalletDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const WalletDeleteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final l10n = FinanceLocalizations.of(context)!;
    return AppConfirmationDialog(
      title: l10n.walletDeleteDialogTitle,
      message: l10n.walletDeleteDialogMessage,
      cancelText: l10n.walletDeleteDialogCancel,
      confirmText: l10n.walletDeleteDialogConfirm,
      onConfirm: onConfirm,
      isDestructive: true,
    );
  }

  Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (context) => this);
  }
}
```

:::

## Barrel

::: code-group

```dart [wallet_feature.dart]
// data
export 'data/datasources/wallet_remote_data_source.dart';
export 'data/datasources/wallet_remote_data_source_impl.dart';
export 'data/repositories/wallet_repository_impl.dart';
// domain
export 'domain/params/wallet_delete_param.dart';
export 'domain/repositories/wallet_repository.dart';
export 'domain/usecases/wallet_delete_use_case.dart';
// logic
export 'logic/delete/wallet_delete_cubit.dart';
export 'logic/delete/wallet_delete_state.dart';
// ui
export 'ui/delete/widgets/wallet_delete_dialog.dart';
export 'ui/delete/widgets/wallet_delete_popup_menu_item.dart';
```

```dart [finance.dart]
export 'src/features/wallet/wallet_feature.dart';
export 'src/generated/finance_localizations.dart';
export 'src/shared/domain/errors/finance_failure.dart';
export 'src/shared/ui/extensions/finance_failure_x.dart';
```

:::