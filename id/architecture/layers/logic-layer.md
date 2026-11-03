# Logic Layer

Logic adalah layer yang berfokus pada state management dan menjadi penghubung antara domain dengan UI. Orkestrasi tertingginya tetap berada pada App, sehingga Logic hanya menyediakan kebutuhan state management dan membiarkan App menyusunnya bersama UI.



## Responsibilities

Logic bertanggung jawab menyediakan:

* State
* Cubit / Bloc / Provider / Controller atau state management lainnya

Logic tidak bertanggung jawab terhadap:

* API
* Database
* UI Rendering



## Logic Structure

Logic menyimpan bagian state/orchestration dari slice fitur di dalam `logic/<slice>`. Nama folder tersebut mengikuti nama slice, bukan nama sequence. Jika slice yang sama memiliki bagian UI, folder UI-nya menggunakan nama sepadan di `ui/<slice>`; App yang mengorkestrasi kedua bagian tersebut.

```text
logic/
└── <logic_slice>/
    ├── feature_slice_cubit.dart
    └── feature_slice_state.dart
```



## Cubit

Logic memanggil Use Case melalui state management yang digunakan. Bagian Logic dari satu slice dapat memanggil satu atau lebih Use Case yang berkaitan dengan tanggung jawab slice tersebut. App mengorkestrasi bagian UI/Logic dan sequence yang relevan dalam alur fitur.

Slice seperti `form_update` juga dapat memiliki bagian Logic untuk mengelola state form/input atau koordinasi lokal tanpa memanggil Use Case secara langsung. Dengan demikian, tidak setiap slice memiliki sequence.

Contoh:

```dart
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductDetailUseCase _useCase;
  final int _id;

  ProductDetailCubit({
    required ProductDetailUseCase productDetailUseCase,
    required int id,
  }) : _id = id,
       _useCase = productDetailUseCase,
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



## Hubungan dengan App dan Sequence

```text
UI slice --callback--> App orchestrator --action/input--> Logic slice(s)
                |
                +--> Use Case(s)
                  ↓
                  Repository contract
                  ⇣ implemented by
                  Repository/Data source
```

Use Case hingga Data adalah sequence. UI dan Logic slice berada di luar sequence; App menghubungkan interaksi dan data antar layer. Satu bagian Logic dapat memanggil beberapa Use Case, dan beberapa bagian Logic dapat berkaitan dengan Use Case yang sama.



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



## Why This Layer Exists

Logic ada untuk mengelola state dan alur interaksi aplikasi.



## Key Principle

State pada Logic dibuat murni tanpa terikat pada implementasi state management yang digunakan.

Logic hanya menjadi penghubung antara domain dengan UI, sehingga tidak boleh 
mengetahui implementasi teknis dari datasource maupun UI.