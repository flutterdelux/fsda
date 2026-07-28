# Domain Layer

The Domain is the center of the business contract in FSDA.

The Domain defines what the application does, not how the application does it.

The Domain is the most stable layer and acts as the dependency center for all other layers.

The examples in this document are simplified to focus on architecture. Current Flutter baseline technical details are explained in [Development Workflow](../../guides/development-workflow.md).

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```



## Responsibilities

The Domain is responsible for:

* Entity
* Repository Contract
* Use Case
* Param
* Failure
* Business Enum

The Domain is not responsible for:

* API
* Database
* Cache
* UI
* State Management
* Framework Implementation



## Domain Structure

```text
domain/
├── entities/
├── enums/
├── params/
├── repositories/
└── usecases/
```

Failure remains a domain concern, but in FSDA it is placed at the module scope so that it can be shared by all features within the same module.

```text
shared/
└── domain/
    └── errors/
        └── <module>_failure.dart
```



## Entities

Entities represent the core business models of the application.

Example:

```dart
final class ProductEntity {
  final int id;
  final String name;
  final double price;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
  });
}
```

Entities do not know about:

* DTO
* Request
* Response
* Flutter Widget



## Repository Contracts

A Repository in the domain is a contract.

A Repository defines the business operations required by the application.

Example:

```dart
abstract interface class ProductRepository {
  AsyncResult<ProductEntity> getProductDetail(ProductDetailParam param);
}
```

A Repository has no implementation.

The implementation is in the data layer.



## Param

Param is used to carry use case inputs.

Param must be immutable. Current Flutter baseline technical details are explained in [Development Workflow](../../guides/development-workflow.md).

Example:

```dart
final class ProductDetailParam {
  final int id;

  const ProductDetailParam({required this.id});
}
```



## Use Cases

Use Cases are the business entry points.

Use Cases orchestrate repository contracts.

Example:

```dart
class ProductDetailUseCase extends UseCase<ProductEntity, ProductDetailParam> {
  final ProductRepository _repository;

  const ProductDetailUseCase({required ProductRepository productRepository})
    : _repository = productRepository;

  @override
  AsyncResult<ProductEntity> call(ProductDetailParam param) {
    return _repository.getProductDetail(param);
  }
}
```




## Business Enums

Enums are used to define business values.

Example:

```dart
enum PaymentStatus { unpaid, paid, expired }
```



## Failures

Failures represent business failures.

Failures do not know about:

* HTTP Error
* SQLite Error

Example:

```dart
enum ProductFailure implements Failure { productNotFound }
```

In FSDA, failures are placed in `module/shared/domain/errors` because they are a domain concern that can be accessed collectively by all features under the same module.



## Dependency Rules

The Domain can only depend on the domain.

Allowed:

```text
domain/
```

Forbidden:

```text
data/
logic/
ui/
flutter/
```



## Why This Layer Exists

The Domain exists to separate business contracts from implementations.



## Key Principle

The Domain is a contract.

The Domain does not know about implementation.

Other layers can know about the domain.

The Domain must not know about other layers.