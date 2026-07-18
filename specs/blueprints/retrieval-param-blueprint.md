# Retrieval + Param Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rp   | Retrieval + Param             | product      | product     | detail        | getProductDetail()       |


## Shared

::: code-group

```dart [product_failure.dart]
import 'package:app_core/app_core.dart';

enum ProductFailure implements Failure { productNotFound }
```

```dart [product_failure_x.dart]
import 'package:flutter/material.dart';

import '../../../generated/product_localizations.dart';
import '../../domain/errors/product_failure.dart';

extension ProductFailureX on ProductFailure {
  String localize(BuildContext context) {
    final l10n = ProductLocalizations.of(context)!;
    return switch (this) {
      ProductFailure.productNotFound => l10n.failureProductNotFound,
    };
  }
}
```

```dart [product_exception.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/errors/product_failure.dart';

part 'product_exception.freezed.dart';

@freezed
sealed class ProductException with _$ProductException implements AppException {
  const ProductException._();

  const factory ProductException.productNotFound({
    String? msg,
    StackTrace? st,
  }) = _ProductNotFound;

  @override
  String get message =>
      when(productNotFound: (msg, _) => msg ?? 'Product not found');

  @override
  StackTrace? get stackTrace => st;

  @override
  Failure toFailure() =>
      when(productNotFound: (_, _) => ProductFailure.productNotFound);

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

```dart [product_en.arb]
{
  "@@locale": "en",
  "@productAlt": {
    "description": "========================= Product ========================="
  },
  "productAlt": "Product",
  "failureProductNotFound": "Product not found",
  "productDetailTitle": "Product Detail",
  "productDetailErrorTitle": "Failed to Load Product"
}
```

```dart [product_id.arb]
{
  "@@locale": "id",
  "@productAlt": {
    "description": "========================= Product ========================="
  },
  "productAlt": "Product",
  "failureProductNotFound": "Product tidak ditemukan",
  "productDetailTitle": "Detail Produk",
  "productDetailErrorTitle": "Gagal Memuat Produk"
}
```

:::

## Domain Layer

::: code-group

```dart [product_entity.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

@freezed
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    required int id,
    required String name,
    required double price,
    required String description,
    required int stock,
    required String imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProductEntity;
}
```

```dart [product_detail_param.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_detail_param.freezed.dart';

@freezed
abstract class ProductDetailParam with _$ProductDetailParam {
  const factory ProductDetailParam({required int id}) = _ProductDetailParam;
}
```

```dart [product_repository.dart]
import 'package:app_core/app_core.dart';
import '../entities/product_entity.dart';
import '../params/product_detail_param.dart';

abstract interface class ProductRepository {
  // ------- Retrieval -------

  AsyncResult<ProductEntity> getProductDetail(ProductDetailParam param);

  // ------- Mutation -------
}
```

```dart [product_use_case.dart]
import 'package:app_core/app_core.dart';

import '../entities/product_entity.dart';
import '../params/product_detail_param.dart';
import '../repositories/product_repository.dart';

class ProductDetailUseCase extends UseCase<ProductEntity, ProductDetailParam> {
  final ProductRepository _repository;

  const ProductDetailUseCase({required ProductRepository productRepository})
    : _repository = productRepository;

  @override
  AsyncResult<ProductEntity> call(ProductDetailParam param) =>
      _repository.getProductDetail(param);
}
```

:::

## Data Layer

::: code-group

```dart [product_dto.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_entity.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

@freezed
abstract class ProductDto with _$ProductDto {
  const ProductDto._();

  const factory ProductDto({
    required int id,
    required String name,
    required double price,
    required String description,
    required int stock,
    required String imageUrl,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, Object?> json) =>
      _$ProductDtoFromJson(json);

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      price: price,
      description: description,
      stock: stock,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

```dart [product_detail_request.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/params/product_detail_param.dart';

part 'product_detail_request.freezed.dart';
part 'product_detail_request.g.dart';

@freezed
abstract class ProductDetailRequest with _$ProductDetailRequest {
  const ProductDetailRequest._();

  const factory ProductDetailRequest({required int id}) = _ProductDetailRequest;

  factory ProductDetailRequest.fromJson(Map<String, Object?> json) =>
      _$ProductDetailRequestFromJson(json);

  factory ProductDetailRequest.fromParam(ProductDetailParam param) {
    return ProductDetailRequest(id: param.id);
  }
}
```

```dart [product_detail_response.dart]
import 'package:freezed_annotation/freezed_annotation.dart';

import '../dtos/product_dto.dart';

part 'product_detail_response.freezed.dart';
part 'product_detail_response.g.dart';

@freezed
abstract class ProductDetailResponse with _$ProductDetailResponse {
  const ProductDetailResponse._();

  const factory ProductDetailResponse({
    required String status,
    required String message,
    @JsonKey(fromJson: _productFromJson) ProductDto? data,
    String? code,
    List<String>? errors,
  }) = _ProductDetailResponse;

  factory ProductDetailResponse.fromJson(Map<String, Object?> json) =>
      _$ProductDetailResponseFromJson(json);
}

ProductDto? _productFromJson(Object? json) {
  if (json is Map) {
    return ProductDto.fromJson(json as Map<String, dynamic>);
  }
  return null;
}
```

```dart [product_data_source.dart]
import '../dtos/product_dto.dart';
import '../requests/product_detail_request.dart';

abstract interface class ProductRemoteDataSource {
  // ------- Retrieval -------

  Future<ProductDto> getProductDetail(ProductDetailRequest request);

  // ------- Mutation -------
}
```

```dart [product_data_source_impl.dart]
import 'package:app_core/app_core.dart';

import '../../../../shared/data/errors/product_exception.dart';
import '../dtos/product_dto.dart';
import '../requests/product_detail_request.dart';
import '../responses/product_detail_response.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient _apiClient;

  const ProductRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // ------- Retrieval -------

  @override
  Future<ProductDto> getProductDetail(ProductDetailRequest request) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/products/${request.id}',
    );

    if (response.statusCode == 200) {
      final productDetailResponse = ProductDetailResponse.fromJson(
        response.body,
      );
      if (productDetailResponse.data != null) {
        return productDetailResponse.data!;
      }

      throw CoreException.serverError(
        msg: 'ProductDetail data is null',
        st: StackTrace.current,
      );
    }

    throw ProductException.fromApiResponse(response, st: StackTrace.current);
  }

  // ------- Mutation -------
}
```


```dart [product_repository_impl.dart]
import 'package:app_core/app_core.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/params/product_detail_param.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../requests/product_detail_request.dart';

class ProductRepositoryImpl
    with RepositoryExceptionHandler
    implements ProductRepository {
  final AppLogger _log;
  final ProductRemoteDataSource _remoteDataSource;

  const ProductRepositoryImpl({
    required AppLogger appLogger,
    required ProductRemoteDataSource productRemoteDataSource,
  }) : _log = appLogger,
       _remoteDataSource = productRemoteDataSource;

  @override
  AppLogger get log => _log;

  // ------- Retrieval -------

  @override
  AsyncResult<ProductEntity> getProductDetail(ProductDetailParam param) async {
    try {
      final request = ProductDetailRequest.fromParam(param);
      final productDto = await _remoteDataSource.getProductDetail(request);
      return Result.success(productDto.toEntity());
    } catch (e, st) {
      return handleException('productDetail', e, st);
    }
  }

  // ------- Mutation -------
}
```


:::

## Logic Layer

::: code-group

```dart [product_detail_state.dart]
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_entity.dart';

part 'product_detail_state.freezed.dart';

@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.initial() = _Initial;
  const factory ProductDetailState.loading() = _Loading;
  const factory ProductDetailState.loaded({
    required ProductEntity data,
  }) = _Loaded;
  const factory ProductDetailState.failure({required Failure failure}) =
      _Failure;
}
```

```dart [product_detail_cubit.dart]
import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';

import '../../domain/params/product_detail_param.dart';
import '../../domain/usecases/product_detail_use_case.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductDetailUseCase _useCase;
  final int _id;

  ProductDetailCubit({
    required ProductDetailUseCase productDetailUseCase,
    required int id,
  }) : _useCase = productDetailUseCase,
       _id = id,
       super(const ProductDetailState.initial());

  Future<void> getProductDetail() async {
    emit(const ProductDetailState.loading());

    final param = ProductDetailParam(id: _id);
    final result = await _useCase(param);

    emit(
      result.when(
        success: (data) => ProductDetailState.loaded(data: data),
        failure: (failure) => ProductDetailState.failure(failure: failure),
      ),
    );
  }
}
```

:::

## UI Layer

::: code-group

```dart [product_detail_view.dart]
import 'package:flutter/material.dart';
import '../../../../../generated/product_localizations.dart';

class ProductDetailView extends StatelessWidget {
  final Widget content;
  const ProductDetailView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final l10n = ProductLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.productDetailTitle)),
      body: content,
    );
  }
}
```

```dart [product_detail_content.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/product_entity.dart';

class ProductDetailContent extends StatelessWidget {
  final ProductEntity product;
  final Future<void> Function() onPullRefresh;
  const ProductDetailContent({
    super.key,
    required this.product,
    required this.onPullRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return RefreshIndicator.adaptive(
      onRefresh: onPullRefresh,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: AppNetworkImage(
              url: product.imageUrl,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          AppGap.md,
          Row(
            children: [
              Expanded(child: Text(product.name, style: textTheme.titleLarge)),
              Text(
                '\$${product.price}',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          AppGap.md,
          Text(product.description, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
```

```dart [product_detail_skeleton.dart]
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        const AspectRatio(aspectRatio: 1, child: AppShimmer(radius: 16)),
        AppGap.md,
        const Row(
          children: [
            Expanded(child: AppShimmer(height: 24, radius: 6)),
            AppGap.md,
            AppShimmer(width: 72, height: 20, radius: 6),
          ],
        ),
        AppGap.md,
        const AppShimmer(height: 16),
        AppGap.sm,
        const AppShimmer(height: 16),
        AppGap.sm,
        const AppShimmer(width: 220, height: 16),
      ],
    );
  }
}
```

```dart [product_detail_error_feedback.dart]
import 'package:app_l10n/app_l10n.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/product_localizations.dart';

class ProductDetailErrorFeedback extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ProductDetailErrorFeedback({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppLocalizations.of(context)!;
    final l10n = ProductLocalizations.of(context)!;
    return AppErrorFeedback(
      title: l10n.productDetailErrorTitle,
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

```dart [product_feature.dart]
// data
export 'data/datasources/product_remote_data_source.dart';
export 'data/datasources/product_remote_data_source_impl.dart';
export 'data/repositories/product_repository_impl.dart';
// domain
export 'domain/entities/product_entity.dart';
export 'domain/repositories/product_repository.dart';
export 'domain/usecases/product_detail_use_case.dart';
// logic
export 'logic/detail/product_detail_cubit.dart';
export 'logic/detail/product_detail_state.dart';
// ui
export 'ui/detail/views/product_detail_view.dart';
export 'ui/detail/widgets/product_detail_content.dart';
export 'ui/detail/widgets/product_detail_error_feedback.dart';
export 'ui/detail/widgets/product_detail_skeleton.dart';
```

```dart [product.dart]
export 'src/features/product/product_feature.dart';
export 'src/generated/product_localizations.dart';
export 'src/shared/domain/errors/product_failure.dart';
export 'src/shared/ui/extensions/product_failure_x.dart';
```

:::