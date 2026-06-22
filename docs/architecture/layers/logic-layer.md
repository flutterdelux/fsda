# Logic Layer

Logic adalah layer yang berfokus pada state management dan menjadi penghubung antara domain dengan UI. Orkestrasi tertingginya tetap berada pada App, sehingga Logic hanya menyediakan kebutuhan state management dan membiarkan App menyusunnya bersama UI.

&nbsp;

## Responsibilities

Logic bertanggung jawab menyediakan:

* State
* Cubit / Bloc / Provider / Controller atau state management lainnya

Logic tidak bertanggung jawab terhadap:

* API
* Database
* UI Rendering

&nbsp;

## Logic Structure

Grouping di dalam layer logic bisa dilakukan berdasarkan slice fitur.

```text
logic/
└── <slice>/
    ├── feature_slice_cubit.dart
    └── feature_slice_state.dart
```

&nbsp;

## Cubit

Logic mengorkestrasi use case melalui state management yang digunakan. Satu Cubit biasanya hanya mengakses satu use case, sehingga kebutuhan state management-nya dapat tetap terfokus dan sederhana.

Namun, dalam keadaan yang lebih kompleks, satu Cubit dapat mengakses lebih dari satu use case, dengan catatan state management-nya tetap terfokus dan use case-nya saling berkaitan.

Contoh:

```dart
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductDetailUseCase _useCase;
  final int id;

  ProductDetailCubit({
    required ProductDetailUseCase productDetailUseCase,
    required this.id,
  }) : _useCase = productDetailUseCase,
       super(const ProductDetailState.initial());

  Future<void> getProductDetail() async {
    emit(const ProductDetailState.loading());

    final param = ProductDetailParam(id: id);
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

&nbsp;

## State

State adalah data atau snapshot yang mewakili keadaan aplikasi pada momen tertentu. State bersifat immutable, sehingga setiap perubahan nilai atau data akan menghasilkan state baru. State biasanya terdiri dari beberapa status yang jika dikelompokkan ke operasi Mutation dan Retrieval dapat digambarkan seperti berikut:

Pada baseline Flutter saat ini, detail implementasi state dijelaskan pada [Development Workflow](../../guides/development-workflow.md).

| Mutation        | Retrieval       |
|-----------------|-----------------|
| Initial         | Initial         |
| Loading         | Loading         |
| Success         | Loaded          |
| Failure         | Failure         |

Status state tidak harus selalu empat seperti contoh di atas. Jumlahnya bisa lebih atau kurang tergantung kebutuhan. Yang terpenting, status state harus jelas dan konsisten dalam menggambarkan keadaan aplikasi.

State dibuat pure tanpa terikat pada state management yang digunakan. Sehingga jika di masa depan perlu mengganti state management, cukup ganti state management-nya saja tanpa perlu mengubah state-nya.

Contoh:

```dart
sealed class ProductDetailState {
  const ProductDetailState();
}

final class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();
}

final class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

final class ProductDetailLoaded extends ProductDetailState {
  final ProductEntity data;

  const ProductDetailLoaded({required this.data});
}

final class ProductDetailFailure extends ProductDetailState {
  final Failure failure;

  const ProductDetailFailure({required this.failure});
}
```

&nbsp;

## Flow

```text
UI
 ↓
Cubit
 ↓
Use Case
 ↓
Repository Contract
 ↓
Repository Impl
 ↓
Datasource
```

&nbsp;

## Dependency Rules

Allowed:

```text
domain/
logic/
```

Forbidden:

```text
data/
ui/
```

&nbsp;

## Why This Layer Exists

Logic ada untuk mengelola state dan alur interaksi aplikasi.

&nbsp;

## Key Principle

State pada Logic dibuat murni tanpa terikat pada implementasi state management yang digunakan.

Logic hanya menjadi penghubung antara domain dengan UI, sehingga tidak boleh 
mengetahui implementasi teknis dari datasource maupun UI.