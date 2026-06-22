# Data Layer

Data adalah implementasi dari kontrak domain.

Data bertanggung jawab untuk memperoleh, menyimpan, dan mengubah data dari berbagai sumber.

Contoh pada dokumen ini disederhanakan agar fokus pada arsitektur. Detail teknis baseline Flutter saat ini dijelaskan pada [Development Workflow](../../guides/development-workflow.md).

&nbsp;

## Responsibilities

Data bertanggung jawab terhadap:

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

Datasource bertanggung jawab berinteraksi dengan sumber data.

Contoh:

```dart
abstract interface class ProductRemoteDataSource {
  Future<ProductDto> getProductDetail(ProductDetailRequest request);
}
```

&nbsp;

## DTO

DTO adalah representasi data mentah.

Contoh:

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

DTO adalah detail implementasi data layer.

Entity adalah kontrak yang boleh keluar menuju layer lain.

&nbsp;

## Request

Request digunakan untuk komunikasi ke datasource. Input yang menjadi kebutuhan mutasi maupun retrieval harus dibungkus dalam bentuk request. Namun biasanya request hanya digunakan untuk komunikasi dengan remote datasource seperti API. Untuk komunikasi dengan local datasource bisa langsung menggunakan object DTO.

Contoh:

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

Response digunakan untuk membungkus hasil dari sumber data. Sama seperti Request, Response juga biasanya digunakan untuk komunikasi dengan remote datasource. Dimana object return dari API biasanya dibungkus dalam bentuk ApiResponse kontrak yang kemudin body nya di mapping ke bentuk Response yang dibuat.

Response menjadi tukang prediksi untuk response API, sehingga jika response API berubah maka yang perlu diubah hanya Response nya saja agar adaptible dengan actual response API dan bentuk DTO.

Contoh:

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

Karena Enum (Domain) tidak boleh tau tentang implementasi teknis, maka converter ini biasanya digunakan untuk mengubah Enum menjadi bentuk yang bisa dipahami oleh data source, seperti String atau int.

Contoh:

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

Repository implementation menghubungkan domain dengan datasource. Di sini juga tempat untuk menangani error yang terjadi maupun yang dilempar oleh datasource.

Repository implementation juga menjadi titik berhenti dari Param, sehingga harus di mapping ke bentuk request/dto yang dibutuhkan datasource. Begitu juga dengan dto, repository implementation menjadi titik berhenti dari dto dari arah datasource, sehingga harus di mapping ke bentuk entity sebelum disalurkan kembali ke domain.

Contoh:

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

Exception merepresentasikan kegagalan teknis yang terjadi pada Data Layer.

Exception digunakan untuk membungkus error dari sumber data sebelum diterjemahkan menjadi Failure.

Contoh sumber error:

- API Error
- Network Error
- Timeout
- Database Error
- Cache Error
- Serialization Error

Contoh:

```dart
sealed class ProductException implements Exception {
  const ProductException();

  factory ProductException.productNotFound() =
      ProductExceptionProductNotFound;

  factory ProductException.productUnavailable() =
      ProductExceptionProductUnavailable;
}
```

Exception tidak boleh keluar dari Data Layer.

Repository Implementation bertanggung jawab menerjemahkan Exception menjadi Failure.

Contoh:

```text
Datasource
    ↓
ProductException.productNotFound()
    ↓
ProductFailure.productNotFound
```

Pada FSDA, exception diletakkan pada module scope di `module/shared/data/errors` karena sering digunakan bersama oleh beberapa feature dalam module yang sama.

Contoh:

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

Data ada untuk mengisolasi detail teknis dari bisnis.

&nbsp;

## Key Principle

Data mengimplementasikan kontrak domain.

Data tidak boleh bocor ke logic maupun UI.
