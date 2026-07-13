# Domain Layer

Domain is the business contract center in FSDA.

Domain defines what the application does, not how it does it.

Domain is the most stable layer and the dependency center for all other layers.

Examples in this document are simplified to focus on architecture. Current Flutter baseline technical details are documented in [Development Workflow](../../guides/development-workflow.md).

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```

&nbsp;

## Responsibilities

Domain is responsible for:

* Entity
* Repository Contract
* Use Case
* Param
* Failure
* Business Enum

Domain is not responsible for:

* API
* Database
* Cache
* UI
* State Management
* Framework Implementation

&nbsp;

## Domain Structure

```text
domain/
├── entities/
├── enums/
├── params/
├── repositories/
└── usecases/
```

Failure remains a domain concern, but in FSDA it is placed at module scope so it can be shared by all features in the same module.

```text
shared/
└── domain/
    └── errors/
        └── <module>_failure.dart
```

&nbsp;

## Entities

Entity represents core business model.

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

Entity does not know:

* DTO
* Request
* Response
* Flutter Widget

&nbsp;

## Repository Contracts

Repository in Domain is a contract.

Repository defines business operations required by application.

Example:

```dart
abstract interface class ProductRepository {
  AsyncResult<ProductEntity> getProductDetail(ProductDetailParam param);
}
```

Repository has no implementation.

Implementation belongs in Data layer.

&nbsp;

## Param

Param carries use case input.

Param should be immutable. Current Flutter baseline technical details are documented in [Development Workflow](../../guides/development-workflow.md).

Example:

```dart
final class ProductDetailParam {
  final int id;

  const ProductDetailParam({required this.id});
}
```

&nbsp;

## Use Cases

Use Case is business entry point.

Use Case orchestrates repository contract.

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

&nbsp;

## Business Enums

Enum defines business values.

Example:

```dart
enum PaymentStatus { unpaid, paid, expired }
```

&nbsp;

## Failures

Failure represents business failure.

Failure should not know:

* HTTP Error
* SQLite Error

Example:

```dart
enum ProductFailure implements Failure { productNotFound }
```

In FSDA, failure is placed at `module/shared/domain/errors` because it is a domain concern shared by all features under the same module.

&nbsp;

## Dependency Rules

Domain may only depend on domain.

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

&nbsp;

## Why This Layer Exists

Domain exists to separate business contracts from implementation details.

&nbsp;

## Key Principle

Domain is contract.

Domain does not know implementation.

Other layers may know domain.

Domain must not know other layers.
