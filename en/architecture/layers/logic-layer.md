# Logic Layer

Logic is the layer focused on state management and acts as a bridge between Domain and UI. Highest orchestration still belongs to App, so Logic provides state needs and lets App compose it with UI.

&nbsp;

## Responsibilities

Logic is responsible for providing:

* State
* Cubit / Bloc / Provider / Controller or other state management units

Logic is not responsible for:

* API
* Database
* UI Rendering

&nbsp;

## Logic Structure

Grouping in logic layer can be done by feature slice.

```text
logic/
└── <slice>/
    ├── feature_slice_cubit.dart
    └── feature_slice_state.dart
```

&nbsp;

## Cubit

Logic orchestrates use cases through chosen state management. One Cubit typically accesses one use case so state management remains focused and simple.

In more complex scenarios, one Cubit may access multiple use cases, as long as state management remains focused and use cases are related.

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

&nbsp;

## State

State is data/snapshot representing application condition at a point in time. State is immutable, so every value change produces a new state. If grouped by Mutation and Retrieval operations, baseline state status may look like this:

Current Flutter baseline state details are documented in [Development Workflow](../../guides/development-workflow.md).

| Mutation        | Retrieval       |
|-----------------|-----------------|
| Initial         | Initial         |
| Loading         | Loading         |
| Success         | Loaded          |
| Failure         | Failure         |

State status does not have to be exactly these four. Count may vary by needs. Most important is clear and consistent state semantics.

State should remain pure and independent from specific state management implementation. If state management changes later, only management layer changes while state model can stay.

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

Logic exists to manage state and interaction flow.

&nbsp;

## Key Principle

State in Logic should be pure and independent from concrete state management implementation.

Logic acts only as bridge between Domain and UI, so it must not know datasource technical implementation or UI rendering implementation.
