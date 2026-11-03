# FSDA Principles

## 1. Modular First

Applications are built from a collection of independent modules.

Each module represents a single business domain that can be developed, tested, maintained, and reused independently.

Modules serve as the primary organizational unit within the codebase.

Examples:

* Inbox Module
* Task Module
* Finance Module
* Product Module

The App does not contain business logic.

The App only composes the required modules.

## 2. Feature-Oriented Design

Each module consists of one or more features.

A feature serves as a clear functional boundary within a business domain.

Example in Task Module:

* Task Feature
* Task Category Feature
* Task Milestone Feature

Features are not globally divided by layers.

Features are the center of code organization.

## 3. Sequence-Driven Development

Sequence standardizes the flow from a Use Case through the Domain Repository contract to its Data implementation. Sequence types are based on the Use Case signature: three flows (async, sync, stream), each with four forms (void, param, return, return + param), resulting in 12 types.

A sequence is related to a Use Case contract and the Domain-to-Data flow, not owned by a UI slice. The Logic part of a slice may call one or more Use Cases; a slice may also manage local state without a Use Case. App orchestrates the relevant UI/Logic parts with the sequences needed for a feature flow. See [Sequence Pattern](sequence-pattern.md) for the contracts and types.

With this approach, all implementations become:

* predictable
* consistent
* easy to learn
* easy to automate

## 4. Feature Slices and Responsibility

A feature slice is a modular grouping of related components within a feature. It may have an implementation part under `logic/<slice>`, `ui/<slice>`, or both. The folders `logic/update` and `ui/update` are the Logic and UI parts of the `update` slice. UI exposes interactions through callbacks; App connects those callbacks to Logic.

A slice should have a clear focus. Its Logic part may call multiple Use Cases/sequences, or no Use Case at all. Different slices may be related to the same Use Case/sequence, and a feature flow may involve several slices and sequences.

Feature slice examples:

* create
* update
* delete
* list
* detail
* status
* mark_all_read

Each slice should have a clear responsibility and be understandable on its own. A slice name groups a feature responsibility; a sequence describes the Use Case-to-Data contract and is not determined by the slice name.

In FSDA, a Module may contain many Features, a Feature may support many feature flows, and a feature flow may involve multiple slices and/or sequences. App uses and orchestrates related components to run each flow.

## 5. Explicit Data Flow

Data flow must always be visible and traceable.

At runtime, App orchestrates communication between UI and Logic. UI provides callbacks for interactions and receives data/state for presentation; it does not call Logic directly.

User → UI part (callback) → App (composition/orchestration)
			   ├── provides data/state to UI
			   └── dispatches actions/input to Logic part(s)
				      ↓ calls related Use Case(s)
			      Sequence(s): Domain contract → Data implementation

Hidden flows that are difficult to understand are not allowed.

Developers must be able to easily trace the journey of data from the UI to the data source.

## 6. Dependency Inward

Dependencies always point inward.

Outer layers can know about inner layers.

Inner layers must not know about outer layers.


```
(Inner)
Domain

↑
Logic & UI & Data
(Outer)
```

Or illustrated as a composition structure in App:
```
App (Composition Root)
 ├── UI
 ├── Logic
 ├── Domain
 └── Data

UI ──────┐
Logic ───┼──► Domain
Data ────┘
```

Domain becomes an independent business core that is decoupled from technical implementation details.

## 7. Shared by Boundary

Shared components must be placed at the nearest boundary that requires them.

Shared is not a dumping ground for unlimited general code.

Each shared component must have a clear usage scope.

Shared Placement Guidelines:

* Used by multiple slices within a single feature → place in the shared directory within that feature boundary.
* Used by multiple features within a single module → place in module shared.
* Used across the entire app → place in app or appropriate package.
* Components do not need to be moved to a higher boundary simply because they are accessed by a higher boundary. Ownership follows its primary usage boundary.

## 8. Consistency Over Preference

Consistency is more important than personal preference.

Once a pattern is chosen, the entire codebase must follow it.

Developers must not introduce new variations simply because they prefer a specific style.

A consistent codebase is easier to learn and maintain than a codebase with many variations.

## 9. Discoverability First

Code structure must make it easy for developers to find things without searching too far.

Developers should be able to quickly answer questions like:

* Where is this feature located?
* Where is this use case located?
* Where is this state located?
* Where is this widget located?

Code navigation must be prioritized over overly complex structural optimizations.

## 10. Convention Over Configuration

Repetitive decisions should be resolved through conventions.

Developers should not have to constantly think about:

* folder names
* file names
* class locations
* state locations
* widget locations

Clear conventions reduce repeated discussions and speed up development.

## 11. Scalable by Default

The structure must remain comfortable to use as the project grows.

A good structure must hold up whether the application has:

* tens of modules
* hundreds of features
* thousands of files

Architectural decisions must apply to various application scales, ensuring consistency whether the project grows or shrinks.

## 12. Automation Friendly

The architecture must be understandable by both humans and tooling.

Consistent conventions enable:

* code generation
* scaffolding
* linting
* validation
* automation

The fewer exceptions in the structure, the easier it is to automate.