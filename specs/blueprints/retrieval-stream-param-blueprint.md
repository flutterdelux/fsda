# Retrieval + Stream + Param Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rsp  | Retrieval + Stream + Param    | subscription | payment     | status        | watchPaymentStatus()     |

## Shared

::: code-group

```dart [subscription_failure.dart]
import 'package:app_core/app_core.dart';

enum SubscriptionFailure implements Failure { subscriptionNotFound, paymentNotFound }
```

```dart [subscription_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/subscription_localizations.dart';
import '../../domain/errors/subscription_failure.dart';

extension SubscriptionFailureX on SubscriptionFailure {
  String localize(BuildContext context) {
    final l10n = SubscriptionLocalizations.of(context)!;
    return switch (this) {
      SubscriptionFailure.subscriptionNotFound =>
        l10n.failureSubscriptionNotFound,
      SubscriptionFailure.paymentNotFound => l10n.failurePaymentNotFound,
    };
  }
}
```

```dart [subscription_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/subscription_failure.dart';

part 'subscription_exception.freezed.dart';

@freezed
sealed class SubscriptionException
    with _$SubscriptionException
    implements AppException {
  const SubscriptionException._();

  const factory SubscriptionException.subscriptionNotFound({
    String? msg,
    StackTrace? st,
  }) = _SubscriptionNotFound;
  const factory SubscriptionException.paymentNotFound({
    String? msg,
    StackTrace? st,
  }) = _PaymentNotFound;

  @override
  String get message => when(
    subscriptionNotFound: (msg, _) => msg ?? 'Subscription not found',
    paymentNotFound: (msg, _) => msg ?? 'Payment not found',
  );

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() => when(
    subscriptionNotFound: (_, _) => SubscriptionFailure.subscriptionNotFound,
    paymentNotFound: (_, _) => SubscriptionFailure.paymentNotFound,
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

```arb [subscription_en.arb]
{
  "@@locale": "en",
  "@failureSubscriptionNotFound": {
    "description": "========================= Failure ========================="
  },
  "failureSubscriptionNotFound": "Subscription not found",
  "failurePaymentNotFound": "Payment not found",
  "@paymentAlt": {
    "description": "========================= Payment ========================="
  },
  "paymentAlt": "Payment",
  "paymentIdLabel": "Payment ID",
  "paymentCreatedAtLabel": "Created At",
  "paymentStatusTitle": "Your Payment Status",
  "paymentStatusUnpaidLabel": "Unpaid",
  "paymentStatusUnpaidMessage": "Please complete the payment process within the specified time frame to avoid cancellation",
  "paymentStatusPaidLabel": "Paid",
  "paymentStatusPaidMessage": "Your payment has been confirmed",
  "paymentStatusExpiredLabel": "Expired",
  "paymentStatusExpiredMessage": "Your payment has expired",
  "paymentStatusErrorTitle": "Failed to Load Payment Status",
  "paymentStatusActionBackToDashboard": "Back to Dashboard",
  "paymentStatusActionPayNow": "Pay Now"
}
```

```arb [subscription_id.arb]
{
  "@@locale": "id",
  "@failureSubscriptionNotFound": {
    "description": "========================= Failure ========================="
  },
  "failureSubscriptionNotFound": "Subscription tidak ditemukan",
  "failurePaymentNotFound": "Payment tidak ditemukan",
  "@paymentAlt": {
    "description": "========================= Payment ========================="
  },
  "paymentAlt": "Payment",
  "paymentIdLabel": "ID Pembayaran",
  "paymentCreatedAtLabel": "Dibuat Pada",
  "paymentStatusTitle": "Status Pembayaran Anda",
  "paymentStatusUnpaidLabel": "Belum Dibayar",
  "paymentStatusUnpaidMessage": "Silakan selesaikan proses pembayaran dalam jangka waktu yang ditentukan untuk menghindari pembatalan",
  "paymentStatusPaidLabel": "Sudah Dibayar",
  "paymentStatusPaidMessage": "Pembayaran Anda telah dikonfirmasi",
  "paymentStatusExpiredLabel": "Kadaluwarsa",
  "paymentStatusExpiredMessage": "Pembayaran Anda telah kadaluwarsa",
  "paymentStatusErrorTitle": "Gagal Memuat Status Pembayaran",
  "paymentStatusActionBackToDashboard": "Kembali ke Dashboard",
  "paymentStatusActionPayNow": "Bayar Sekarang"
}
```

:::

## Domain Layer

::: code-group

```dart [payment_status.dart]
enum PaymentStatus { unpaid, paid, expired }
```

```dart [payment_entity.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/payment_status.dart';

part 'payment_entity.freezed.dart';

@freezed
abstract class PaymentEntity with _$PaymentEntity {
  const factory PaymentEntity({
    required String id,
    required String userId,
    required double amount,
    required String currency,
    required PaymentStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PaymentEntity;
}
```

```dart [payment_status_param.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_status_param.freezed.dart';

@freezed
abstract class PaymentStatusParam with _$PaymentStatusParam {
  const factory PaymentStatusParam({required String id}) = _PaymentStatusParam;
}
```

```dart [payment_repository.dart]
import 'package:app_core/app_core.dart';
import '../entities/payment_entity.dart';
import '../params/payment_status_param.dart';

abstract interface class PaymentRepository {
  // ------- Retrieval -------

  StreamResult<PaymentEntity> watchPaymentStatus(PaymentStatusParam param);

  // ------- Mutation -------
}
```

```dart [payment_use_case.dart]
import 'package:app_core/app_core.dart';

import '../entities/payment_entity.dart';
import '../params/payment_status_param.dart';
import '../repositories/payment_repository.dart';

class PaymentStatusUseCase
    extends StreamUseCase<PaymentEntity, PaymentStatusParam> {
  final PaymentRepository _repository;

  const PaymentStatusUseCase({required PaymentRepository paymentRepository})
    : _repository = paymentRepository;

  @override
  StreamResult<PaymentEntity> call(PaymentStatusParam param) {
    return _repository.watchPaymentStatus(param);
  }
}
```

:::

## Data Layer

::: code-group

```dart [payment_status_converter.dart]
import 'package:json_annotation/json_annotation.dart';

import '../../domain/enums/payment_status.dart';

class PaymentStatusConverter extends JsonConverter<PaymentStatus, String> {
  const PaymentStatusConverter();

  @override
  PaymentStatus fromJson(String json) {
    return switch (json) {
      'unpaid' => PaymentStatus.unpaid,
      'paid' => PaymentStatus.paid,
      'expired' => PaymentStatus.expired,
      _ => PaymentStatus.unpaid,
    };
  }

  @override
  String toJson(PaymentStatus object) {
    return switch (object) {
      PaymentStatus.unpaid => 'unpaid',
      PaymentStatus.paid => 'paid',
      PaymentStatus.expired => 'expired',
    };
  }
}
```

```dart [payment_dto.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/enums/payment_status.dart';
import '../converters/payment_status_converter.dart';

part 'payment_dto.freezed.dart';
part 'payment_dto.g.dart';

@freezed
abstract class PaymentDto with _$PaymentDto {
  const PaymentDto._();

  const factory PaymentDto({
    required String id,
    required String userId,
    required double amount,
    required String currency,
    @PaymentStatusConverter() required PaymentStatus status,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
  }) = _PaymentDto;

  factory PaymentDto.fromJson(Map<String, Object?> json) =>
      _$PaymentDtoFromJson(json);

  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      userId: userId,
      amount: amount,
      currency: currency,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

```dart [payment_status_request.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/params/payment_status_param.dart';

part 'payment_status_request.freezed.dart';
part 'payment_status_request.g.dart';

@freezed
abstract class PaymentStatusRequest with _$PaymentStatusRequest {
  const PaymentStatusRequest._();

  const factory PaymentStatusRequest({required String id}) =
      _PaymentStatusRequest;

  factory PaymentStatusRequest.fromJson(Map<String, Object?> json) =>
      _$PaymentStatusRequestFromJson(json);

  factory PaymentStatusRequest.fromParam(PaymentStatusParam param) {
    return PaymentStatusRequest(id: param.id);
  }
}
```

```dart [payment_remote_data_source.dart]
import '../dtos/payment_dto.dart';
import '../requests/payment_status_request.dart';

abstract interface class PaymentRemoteDataSource {
  // ------- Retrieval -------

  Stream<PaymentDto> watchPaymentStatus(
    PaymentStatusRequest paymentStatusRequest,
  );

  // ------- Mutation -------
}
```

```dart [payment_remote_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/subscription_exception.dart';
import '../dtos/payment_dto.dart';
import '../requests/payment_status_request.dart';
import 'payment_remote_data_source.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient _apiClient;

  const PaymentRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  @override
  Stream<PaymentDto> watchPaymentStatus(
    PaymentStatusRequest paymentStatusRequest,
  ) async* {
    final path = '/payments/${paymentStatusRequest.id}/status/stream';
    try {
      await for (final data in _apiClient.stream<Map<String, dynamic>>(path)) {
        yield PaymentDto.fromJson(data);
      }
    } catch (e, st) {
      if (e is AppException) {
        if (e.message.contains('status code') && e.message.contains('404')) {
          throw SubscriptionException.paymentNotFound(msg: e.message, st: st);
        }
      }
      throw SubscriptionException.fromException(e, st: st);
    }
  }

  // ------- Mutation -------
}
```

```dart [payment_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/params/payment_status_param.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';
import '../requests/payment_status_request.dart';

class PaymentRepositoryImpl
    with RepositoryExceptionHandler
    implements PaymentRepository {
  final AppLogger _log;
  final PaymentRemoteDataSource _remoteDataSource;

  const PaymentRepositoryImpl({
    required AppLogger appLogger,
    required PaymentRemoteDataSource paymentRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = paymentRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  @override
  StreamResult<PaymentEntity> watchPaymentStatus(
    PaymentStatusParam param,
  ) async* {
    try {
      final request = PaymentStatusRequest.fromParam(param);
      final stream = _remoteDataSource.watchPaymentStatus(request);

      await for (final dto in stream) {
        final entity = dto.toEntity();
        yield Result.success(entity);
      }
    } catch (e, st) {
      yield handleException('watchPaymentStatus', e, st);
    }
  }

  // ------- Mutation -------
}
```

:::

## Logic Layer

::: code-group

```dart [payment_status_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/payment_entity.dart';

part 'payment_status_state.freezed.dart';

@freezed
sealed class PaymentStatusState with _$PaymentStatusState {
  const factory PaymentStatusState.initial() = _Initial;
  const factory PaymentStatusState.loading() = _Loading;
  const factory PaymentStatusState.loaded({required PaymentEntity data}) =
      _Loaded;
  const factory PaymentStatusState.failure({required Failure failure}) =
      _Failure;
}
```

```dart [payment_status_cubit.dart]
import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/params/payment_status_param.dart';
import '../../domain/usecases/payment_status_use_case.dart';
import 'payment_status_state.dart';

class PaymentStatusCubit extends Cubit<PaymentStatusState> {
  final PaymentStatusUseCase _useCase;
  final String _id;

  StreamSubscription<Result<PaymentEntity>>? _subscription;

  PaymentStatusCubit({
    required PaymentStatusUseCase paymentStatusUseCase,
    required String id,
  }) : _useCase = paymentStatusUseCase,
       _id = id,
       super(const PaymentStatusState.initial());

  void watchPaymentStatus() {
    emit(const PaymentStatusState.loading());

    _subscription?.cancel();
    final param = PaymentStatusParam(id: _id);
    _subscription = _useCase(param).listen(_onData, onError: _onError);
  }

  void _onData(Result<PaymentEntity> result) {
    emit(
      result.when(
        success: (data) => PaymentStatusState.loaded(data: data),
        failure: (failure) => PaymentStatusState.failure(failure: failure),
      ),
    );
  }

  void _onError(dynamic e) {
    emit(
      PaymentStatusState.failure(
        failure: CoreException.fromException(
          e.toString(),
          st: StackTrace.current,
        ).toFailure(),
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

:::

## UI Layer

::: code-group

```dart [payment_status_x.dart]
import 'package:flutter/material.dart';

import '../../../../../generated/subscription_localizations.dart';
import '../../../domain/enums/payment_status.dart';

extension PaymentStatusX on PaymentStatus {
  String localizeLabel(BuildContext context) {
    final l10n = SubscriptionLocalizations.of(context)!;
    return switch (this) {
      PaymentStatus.unpaid => l10n.paymentStatusUnpaidLabel,
      PaymentStatus.paid => l10n.paymentStatusPaidLabel,
      PaymentStatus.expired => l10n.paymentStatusExpiredLabel,
    };
  }

  String localizeMessage(BuildContext context) {
    final l10n = SubscriptionLocalizations.of(context)!;
    return switch (this) {
      PaymentStatus.unpaid => l10n.paymentStatusUnpaidMessage,
      PaymentStatus.paid => l10n.paymentStatusPaidMessage,
      PaymentStatus.expired => l10n.paymentStatusExpiredMessage,
    };
  }

  Color getColor(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (isDark) {
      return switch (this) {
        PaymentStatus.unpaid => Colors.amberAccent,
        PaymentStatus.paid => Colors.greenAccent,
        PaymentStatus.expired => Colors.redAccent,
      };
    }

    return switch (this) {
      PaymentStatus.unpaid => Colors.amber.shade900,
      PaymentStatus.paid => Colors.green.shade900,
      PaymentStatus.expired => Colors.red.shade900,
    };
  }

  IconData get icon {
    return switch (this) {
      PaymentStatus.unpaid => Icons.schedule_rounded,
      PaymentStatus.paid => Icons.check_circle_outline_rounded,
      PaymentStatus.expired => Icons.error_outline_rounded,
    };
  }
}
```

```dart [payment_status_view.dart]
import 'package:flutter/material.dart';
import '../../../../../generated/subscription_localizations.dart';

class PaymentStatusView extends StatelessWidget {
  final Widget content;
  const PaymentStatusView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final l10n = SubscriptionLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentStatusTitle)),
      body: content,
    );
  }
}
```

```dart [payment_status_content.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../generated/subscription_localizations.dart';
import '../../../domain/entities/payment_entity.dart';
import '../../../domain/enums/payment_status.dart';
import '../../shared/extension/payment_status_x.dart';

class PaymentStatusContent extends StatelessWidget {
  final PaymentEntity payment;
  final VoidCallback? onBackToDashboard;
  final VoidCallback? onPayNow;
  const PaymentStatusContent({
    super.key,
    required this.payment,
    this.onBackToDashboard,
    this.onPayNow,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = SubscriptionLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final status = payment.status;
    final color = status.getColor(context);

    return Align(
      alignment: const Alignment(0, -0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 120,
            backgroundColor: color.withValues(alpha: .05),
            child: CircleAvatar(
              radius: 90,
              backgroundColor: color.withValues(alpha: .15),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: color.withValues(alpha: 0.7),
                child: Icon(status.icon, color: Colors.white, size: 80),
              ),
            ),
          ),
          AppGap.lg,
          Text(status.localizeLabel(context), style: textTheme.titleLarge),
          AppGap.sm,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              payment.status.localizeMessage(context),
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),

          AppGap.xl,

          AppCard(
            margin: const EdgeInsetsGeometry.symmetric(
              horizontal: AppSpacing.xl,
            ),
            children: [
              AppInfoTile(title: l10n.paymentIdLabel, data: payment.id),
              AppInfoTile(
                title: l10n.paymentCreatedAtLabel,
                data: DateFormat.yMMMd().add_jm().format(payment.createdAt),
              ),
            ],
          ),

          AppGap.lg,

          switch (status) {
            PaymentStatus.unpaid => FilledButton(
              onPressed: onPayNow,
              child: Text(l10n.paymentStatusActionPayNow),
            ),
            _ => FilledButton(
              onPressed: onBackToDashboard,
              child: Text(l10n.paymentStatusActionBackToDashboard),
            ),
          },
        ],
      ),
    );
  }
}
```

```dart [payment_status_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PaymentStatusSkeleton extends StatelessWidget {
  const PaymentStatusSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Icon Placeholder
          AppShimmer.circle(size: 240),

          AppGap.lg,

          // 2. Status Label Placeholder
          const AppShimmer(width: 140, height: 24, radius: 6),

          AppGap.sm,

          // 3. Status Message Placeholder
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: AppShimmer(width: 220, height: 16, radius: 4),
          ),

          AppGap.xl,

          // 4. AppCard Placeholder for InfoTiles (ID, Created At)
          const AppCard(
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            children: [
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmer(width: 80, height: 16, radius: 4),
                    AppShimmer(width: 120, height: 16, radius: 4),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmer(width: 100, height: 16, radius: 4),
                    AppShimmer(width: 140, height: 16, radius: 4),
                  ],
                ),
              ),
            ],
          ),

          AppGap.lg,

          // 5. Button Placeholder
          const AppShimmer(width: 200, height: 54, radius: 12),
        ],
      ),
    );
  }
}
```

```dart [payment_status_error_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/subscription_localizations.dart';

class PaymentStatusErrorFeedback extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const PaymentStatusErrorFeedback({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = SubscriptionLocalizations.of(context)!;
    return AppErrorFeedback(
      title: l10n.paymentStatusErrorTitle,
      message: message,
      onRetry: onRetry,
      retryText: appL10n.retry,
    );
  }
}
```

:::

## Barrel

::: code-group

```dart [payment_feature.dart]
// data
export 'data/datasources/payment_remote_data_source.dart';
export 'data/datasources/payment_remote_data_source_impl.dart';
export 'data/repositories/payment_repository_impl.dart';
// domain
export 'domain/entities/payment_entity.dart';
export 'domain/repositories/payment_repository.dart';
export 'domain/usecases/payment_status_use_case.dart';
// logic
export 'logic/status/payment_status_cubit.dart';
export 'logic/status/payment_status_state.dart';
// ui
export 'ui/status/views/payment_status_view.dart';
export 'ui/status/widgets/payment_status_content.dart';
export 'ui/status/widgets/payment_status_error_feedback.dart';
export 'ui/status/widgets/payment_status_skeleton.dart';
```

```dart [subscription.dart]
export 'src/features/payment/payment_feature.dart';
export 'src/generated/subscription_localizations.dart';
export 'src/shared/domain/errors/subscription_failure.dart';
export 'src/shared/ui/extensions/subscription_failure_x.dart';
```

:::