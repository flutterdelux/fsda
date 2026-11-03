# Sequence Pattern

## What is a Sequence

A sequence is an implementation flow and contract that starts at a Use Case, passes through the Domain Repository contract, and is carried out by the Data repository implementation and its data source. It describes how a Domain operation reads or changes data.

A sequence does not include UI or Logic slices. A Use Case is related to the Logic part that calls it; App orchestrates the relevant UI/Logic parts with the sequences required by a feature flow.

## Why Sequence Exists

Sequences standardize Use Case-to-Data flows so implementations are:

* predictable
* consistent
* easy to learn
* easy to automate

## 12 Sequence Types

Sequence type is determined by two dimensions:

1. **Flow**: async, sync, or stream.
2. **Use Case signature**: no input and no result payload (`void`), input only (`param`), result only (`return`), or input and result (`return + param`).

Together, they form the following 12 types. Contract names match `app_core`.

| Flow | Signature | Use Case contract | `call` result |
| --- | --- | --- | --- |
| Async | Void | `VoidUseCase` | `AsyncResult<void> call()` |
| Async | Param | `ParamUseCase<P>` | `AsyncResult<void> call(P param)` |
| Async | Return | `ReturnUseCase<T>` | `AsyncResult<T> call()` |
| Async | Return + Param | `ReturnParamUseCase<T, P>` | `AsyncResult<T> call(P param)` |
| Sync | Void | `VoidSyncUseCase` | `Result<void> call()` |
| Sync | Param | `ParamSyncUseCase<P>` | `Result<void> call(P param)` |
| Sync | Return | `ReturnSyncUseCase<T>` | `Result<T> call()` |
| Sync | Return + Param | `ReturnParamSyncUseCase<T, P>` | `Result<T> call(P param)` |
| Stream | Void | `VoidStreamUseCase` | `Stream<Result<void>> call()` |
| Stream | Param | `ParamStreamUseCase<P>` | `Stream<Result<void>> call(P param)` |
| Stream | Return | `ReturnStreamUseCase<T>` | `Stream<Result<T>> call()` |
| Stream | Return + Param | `ReturnParamStreamUseCase<T, P>` | `Stream<Result<T>> call(P param)` |

`void` means the operation returns no Domain payload; `param` is Use Case input; `return` is the result payload. Async uses `AsyncResult`, sync uses `Result`, and stream emits a sequence of `Result` values.

## Sequence Boundary

```text
App composes the UI/Logic parts related to a feature flow
	↓ dispatches a Logic action
Logic part (optional)
	↓ calls related Use Case(s)
Use Case [sequence entry]
	↓
Repository contract (Domain)
	⇣ implemented by
Repository implementation (Data)
	↓
Data source / external system
```

Each Use Case has one sequence type based on its flow and signature. Many Use Cases may share the same sequence type. Pagination, a specific limit, offline-first behavior, and UI state are not additional sequence codes; place them in the Use Case input, Logic behavior, or Data policy according to ownership.

## Feature Slices and Sequences

A feature slice is a modular grouping within a feature, with Logic and/or UI implementation parts such as `logic/update`, `logic/form_update`, or `ui/update`. App orchestrates the related slices with sequences for each feature flow. The relationship is not one-to-one:

* The Logic part of `update` may call image-upload and product-update Use Cases, each with its own sequence.
* `form_update` may manage form state without a direct relationship to a sequence.
* Multiple slices may be related to the same Use Case or sequence type.
* A feature flow may involve several slices and sequences composed by App.

Use **feature flow** as a descriptive term for the whole requirement. It is not an additional required folder or architectural abstraction.
