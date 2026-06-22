# Domain Layer

Domain adalah pusat kontrak bisnis pada FSDA.

Domain mendefinisikan apa yang aplikasi lakukan, bukan bagaimana aplikasi melakukannya.

Domain merupakan layer paling stabil dan menjadi pusat dependency seluruh layer lainnya.

Contoh pada dokumen ini disederhanakan agar fokus pada arsitektur. Detail teknis baseline Flutter saat ini dijelaskan pada [Development Workflow](../../guides/development-workflow.md).

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```

&nbsp;

## Responsibilities

Domain bertanggung jawab terhadap:

* Entity
* Repository Contract
* Use Case
* Param
* Failure
* Business Enum

Domain tidak bertanggung jawab terhadap:

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

Failure tetap merupakan concern domain, tetapi pada FSDA diletakkan pada module scope agar dapat digunakan bersama oleh seluruh feature di dalam module yang sama.

```text
shared/
└── domain/
    └── errors/
        └── <module>_failure.dart
```

&nbsp;

## Entities

Entity merepresentasikan model bisnis utama aplikasi.

Contoh:

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

Entity tidak mengetahui:

* DTO
* Request
* Response
* Flutter Widget

&nbsp;

## Repository Contracts

Repository pada domain adalah kontrak.

Repository mendefinisikan operasi bisnis yang dibutuhkan aplikasi.

Contoh:

```dart
abstract interface class ProductRepository {
  AsyncResult<ProductEntity> getProductDetail(ProductDetailParam param);
}
```

Repository tidak memiliki implementasi.

Implementasi berada di data layer.

&nbsp;

## Param

Param digunakan untuk membawa input use case.

Param harus immutable. Detail teknis baseline Flutter saat ini dijelaskan pada [Development Workflow](../../guides/development-workflow.md).

Contoh:

```dart
final class ProductDetailParam {
  final int id;

  const ProductDetailParam({required this.id});
}
```

&nbsp;

## Use Cases

Use Case adalah entry point bisnis.

Use Case mengorkestrasi repository contract.

Contoh:

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

Enum digunakan untuk mendefinisikan nilai bisnis.

Contoh:

```dart
enum PaymentStatus { unpaid, paid, expired }
```

&nbsp;

## Failures

Failure merepresentasikan kegagalan bisnis.

Failure tidak mengetahui:

* HTTP Error
* Dio Error
* SQLite Error

Contoh:

```dart
enum ProductFailure implements Failure { productNotFound }
```

Pada FSDA, failure diletakkan di `module/shared/domain/errors` karena merupakan domain concern yang dapat diakses bersama oleh seluruh feature di bawah module yang sama.

&nbsp;

## Dependency Rules

Domain hanya boleh bergantung pada domain.

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

Domain ada untuk memisahkan kontrak bisnis dari implementasi.

&nbsp;

## Key Principle

Domain adalah kontrak.

Domain tidak mengetahui implementasi.

Layer lain boleh mengetahui domain.

Domain tidak boleh mengetahui layer lain.
