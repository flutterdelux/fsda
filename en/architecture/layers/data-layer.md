# Data Layer

Data is the implementation of domain contracts.

Data is responsible for retrieving, storing, and modifying data from various sources.

Examples in this document are simplified to focus on architecture. Current Flutter baseline technical details are documented in [Development Workflow](../../guides/development-workflow.md).

&nbsp;

## Responsibilities

Data is responsible for:

* API
* Database
* Cache
* DTO
* Request
* Response
* Converter
* Repository Implementation

&nbsp;

## Data Structure

```text
data/
├── converters/
├── datasources/
├── dtos/
├── repositories/
├── requests/
└── responses/
```

&nbsp;

## Datasource

Datasource is responsible for interacting with data sources.

Example:

```dart
abstract interface class ProductRemoteDataSource {
  Future<ProductDto> getProductDetail(ProductDetailRequest request);
}
```

&nbsp;

## DTO

DTO is raw data representation.

Example:

```dart
final class ProductDto {
  final int id;
  final String name;
  final double price;

  const ProductDto({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ProductDto.fromMap(Map<String, Object?> map) {
    return ProductDto(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      price: price,
    );
  }
}
```

DTO is Data-layer implementation detail.

Entity is contract that may leave Data layer toward upper layers.

&nbsp;

## Request

Request is used for datasource communication. Inputs for mutation and retrieval should be wrapped as request objects. Usually request is used for remote datasource communication (such as API). For local datasource, DTO object can often be used directly.

Example:

```dart
final class ProductDetailRequest {
  final int id;

  const ProductDetailRequest({required this.id});

  factory ProductDetailRequest.fromParam(ProductDetailParam param) {
    return ProductDetailRequest(id: param.id);
  }
}
```

&nbsp;

## Response

Response wraps data source output. Like Request, Response is usually used in remote datasource communication. API return objects are usually wrapped by an ApiResponse contract, then body is mapped into a dedicated Response object.

Response acts as API response predictor. If API shape changes, update Response mapping so it stays adaptable to actual API shape and DTO form.

Example:

```dart
final class ProductDetailResponse {
  final String status;
  final String message;
  final ProductDto? data;
  final String? code;
  final List<String>? errors;

  const ProductDetailResponse({
    required this.status,
    required this.message,
    this.data,
    this.code,
    this.errors,
  });
}
```

&nbsp;

## Converter

Because Domain enums must not know technical implementation, converters are used to map enums into datasource-friendly forms, such as String or int.

Example:

```dart
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

&nbsp;

## Repository Implementation

Repository implementation connects Domain contracts with datasource implementations. It is also where datasource errors are handled.

Repository implementation is the stopping point for Param, so Param should be mapped into datasource request/dto shape. DTO from datasource is also stopped here and mapped into Entity before returning to Domain.

Example:

```dart
class ProductRepositoryImpl
    with RepositoryExceptionHandler
    implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final AppLogger _log;

  const ProductRepositoryImpl({
    required ProductRemoteDataSource productRemoteDataSource,
    required AppLogger appLogger,
  }) : _remoteDataSource = productRemoteDataSource,
       _log = appLogger;

  @override
  AppLogger get log => _log;

  @override
  AsyncResult<ProductEntity> getProductDetail(ProductDetailParam param) async {
    try {
      final request = ProductDetailRequest.fromParam(param);
      final productDto = await _remoteDataSource.getProductDetail(request);
      return Result.success(productDto.toEntity());
    } catch (e, st) {
      return handleException('getProduct', e, st);
    }
  }
}
```

## Exception

Exception represents technical failure in Data layer.

Exception is used to wrap source-level errors before translation into Failure.

Example error sources:

- API Error
- Network Error
- Timeout
- Database Error
- Cache Error
- Serialization Error

Example:

```dart
sealed class ProductException implements Exception {
  const ProductException();

  factory ProductException.productNotFound() =
      ProductExceptionProductNotFound;

  factory ProductException.productUnavailable() =
      ProductExceptionProductUnavailable;
}
```

Exception must not escape Data layer.

Repository implementation is responsible for translating Exception into Failure.

Example:

```text
Datasource
    ↓
ProductException.productNotFound()
    ↓
ProductFailure.productNotFound
```

In FSDA, exceptions are placed at module scope in `module/shared/data/errors` because they are often shared by several features in the same module.

Example:

```text
<module>/
└── lib/
    └── src/
        └── shared/
            └── data/
                └── errors/
                    └── <module>_exception.dart
```

&nbsp;

## Dependency Rules

Allowed:

```text
domain/
data/
```

Forbidden:

```text
logic/
ui/
```

&nbsp;

## Why This Layer Exists

Data exists to isolate technical details from business contracts.

&nbsp;

## Key Principle

Data implements domain contracts.

Data must not leak into Logic or UI.
