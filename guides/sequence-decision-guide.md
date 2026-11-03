# Sequence and Feature Slice Decision Guide

Sequence and feature slice answer different questions:

* **Sequence**: what contract defines a Use Case-to-Data flow?
* **Feature slice**: what related components are grouped into a modular unit within a feature, and which Logic/UI parts are needed?

Choose a sequence from the Use Case contract, not from a slice name. The relationship between slices and sequences follows the feature flow; it is not a fixed one-to-one mapping.

## Determine a Use Case Sequence Type

Decide two things from the Use Case contract:

1. Is its flow `async`, `sync`, or `stream`?
2. Is its signature `void`, `param`, `return`, or `return + param`?

Together these determine one of the 12 Use Case contracts listed in [Sequence Pattern](../architecture/sequence-pattern.md). Examples:

* Async operation with no input or result payload → `VoidUseCase`.
* Async operation with input and no result payload → `ParamUseCase<P>`.
* Async operation returning an Entity without input → `ReturnUseCase<T>`.
* Async operation accepting a Param and returning an Entity → `ReturnParamUseCase<T, P>`.
* For sync and stream operations, use the corresponding contract ending in `Sync` or `Stream`.

Pagination, a specific limit such as `5`, offline-first behavior, and state transformation are not separate sequence types. Place each behavior in the Param/Use Case, Logic, or Data according to its ownership. For example, `list` and `recent` slices may be related to the same Use Case and sequence type but provide different parameters. App orchestrates the relevant UI/Logic parts and sequences for each flow.

## Identify Related Feature Slices

After identifying the requirement and its Use Cases, group components according to their responsibilities:

* The Logic part of a slice manages state and may call one or more Use Cases. A form slice may manage local input/validation state without calling a Use Case.
* The UI part of a slice groups its views and widgets. UI presents data and sends interactions through callbacks.
* App uses and orchestrates the related UI/Logic parts and sequences, including passing inputs and dispatching actions.

The folders `logic/update` and `ui/update` are the Logic and UI parts of the `update` slice. A differently named slice such as `form_update` can support the same feature flow.

## Example: Product Update

* App orchestrates the UI part `ui/update` and Logic parts `logic/update` and `logic/form_update`.
* Logic `update` calls image-upload and product-update Use Cases, each with its own sequence.
* Slice `form_update` manages form state and may have no direct relationship with a sequence.

## Example: Reusing a Sequence

App may orchestrate `list` and `recent` slices with UI parts `ui/list` and `ui/recent`, and Logic parts related to the same Use Case/sequence. The `recent` flow may supply a limit of `5`, while `list` supplies pagination parameters.

Use **feature flow** as a descriptive term for the whole requirement. It is not a required folder or additional architectural abstraction.
