# Data Layer

Data is the implementation of the domain contract.

Data is responsible for fetching, storing, and modifying data from various sources.

The examples in this document are simplified to focus on architecture. Current Flutter baseline technical details are explained in [Development Workflow](../../guides/development-workflow.md).



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



## Datasource

Datasource is responsible for interacting with data sources.

Example:

```dart
abstract interface class ProductRemoteDataSource {
  Future<ProductDto> getProductDetail(ProductDetailRequest request);
}
```



## DTO

DTO is the representation of raw data.

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

DTO is the implementation detail of the data layer.

Entity is the contract that can go out to other layers.



## Request

Request is used for communication to the datasource. Inputs that are requirements for mutation or retrieval must be wrapped in a request. However, usually requests are only used for communication with remote datasources like APIs. For communication with local datasources, DTO objects can be used directly.

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



## Response

Response is used to wrap the results from data sources. Similar to Request, Response is also typically used for communication with remote datasources. The return object from the API is usually wrapped in an ApiResponse contract, and its body is mapped into the created Response format.

Response acts as a predictor for API responses, so if the API response changes, only the Response needs to be updated to be adaptable to the actual API response and the DTO format.

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



## Converter

Because Enum (Domain) must not know about technical implementations, this converter is usually used to convert an Enum into a format understood by the data source, such as String or int.

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



## Repository Implementation

Repository implementation connects the domain with the datasource. This is also the place to handle errors that occur or are thrown by the datasource.

Repository implementation also serves as the stopping point for Params, so they must be mapped to the request/dto format required by the datasource. Similarly with dtos, the repository implementation serves as the stopping point for dtos coming from the datasource, so they must be mapped into entities before being passed back to the domain.

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

Exceptions represent technical failures that occur in the Data Layer.

Exceptions are used to wrap errors from data sources before translating them into Failures.

Examples of error sources:

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

Exceptions must not leave the Data Layer.

The Repository Implementation is responsible for translating Exceptions into Failures.

Example:

```text
Datasource
    ↓
ProductException.productNotFound()
    ↓
ProductFailure.productNotFound
```

In FSDA, exceptions are placed at the module scope in `module/shared/data/errors` because they are often shared by multiple features within the same module.

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



## Why This Layer Exists

Data exists to isolate technical details from the business.



## Key Principle

Data implements the domain contract.

Data must not leak to logic or UI.