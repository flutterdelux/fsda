# Logic Layer

Logic is the layer focused on state management and acts as a bridge between the domain and UI. Its highest orchestration remains in the App, so Logic only provides state management needs and lets the App assemble them with the UI.



## Responsibilities

Logic is responsible for providing:

* State
* Cubit / Bloc / Provider / Controller or other state management

Logic is not responsible for:

* API
* Database
* UI Rendering



## Logic Structure

Grouping within the logic layer can be done based on feature slices.

```text
logic/
└── <slice>/
    ├── feature_slice_cubit.dart
    └── feature_slice_state.dart
```



## Cubit

Logic orchestrates use cases through the state management being used. A single Cubit typically accesses only one use case, keeping its state management needs focused and simple.

However, in more complex situations, a single Cubit may access more than one use case, provided that its state management remains focused and the use cases are interrelated.

Example:

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

State is data or a snapshot representing the application's condition at a specific moment. State is immutable, meaning every change in value or data results in a new state. State usually consists of several statuses, which, when categorized into Mutation and Retrieval operations, can be illustrated as follows:

In the current Flutter baseline, state implementation details are explained in the [Development Workflow](../../guides/development-workflow.md).

| Mutation        | Retrieval       |
|-----------------|-----------------|
| Initial         | Initial         |
| Loading         | Loading         |
| Success         | Loaded          |
| Failure         | Failure         |

State statuses do not always have to be four like the example above. The number can be more or less depending on the needs. Most importantly, the state status must clearly and consistently describe the application's condition.

State is made pure without being tied to the state management being used. Thus, if there is a need to change state management in the future, only the state management needs to be changed without having to alter the state itself.

Example:

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

Logic exists to manage state and application interaction flows.



## Key Principle

State in Logic is created purely without being tied to the state management implementation being used.

Logic solely acts as a bridge between the domain and UI, and therefore must not know the technical implementations of datasources or the UI.