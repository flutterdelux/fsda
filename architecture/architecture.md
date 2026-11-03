# Feature Slice Driven Architecture (FSDA)

> A pragmatic and rule-driven Flutter architecture focusing on consistency, discoverability, maintainability, scalability, and automation.



## What is Feature Slice Driven Architecture (FSDA)?

FSDA is a Flutter architecture designed to build applications that are consistent, easy to understand, easy to maintain, and easy to scale in the long run.

This architecture combines various proven concepts from:

- Clean Architecture
- Domain Driven Design (DDD)
- Feature First Architecture
- Modular Monorepo Architecture
- Layered Architecture
- Package-Based Architecture
- Separation of Concerns
- SOLID Principles
- Dependency Inversion Principle

However, FSDA is not intended to be a direct copy of any single philosophy.

Instead, FSDA focuses on how to build project structures that are consistent, predictable, discoverable, understandable, and automatable.



## Why FSDA?

Many architectures explain:

- What layers should exist
- How dependencies flow
- What the responsibilities of each layer are

But they often do not explain:

- Where files should be placed
- How module structures are built
- How feature structures are built
- How to maintain consistency across developers
- How to maintain consistency across projects
- How to reduce architectural drift
- How to create a structure that can be automated

As a result, two projects claiming to use the same architecture often have significantly different structures.

FSDA is here to reduce this ambiguity through explicit and consistent implementation rules.



## Structure Summary

FSDA uses a Modular Monorepo approach.

```text
Workspace
├── Apps
└── Packages
```

Each layer has clear responsibilities and explicit boundaries.

---

### Workspace

Workspace is the root of the entire system.

Workspace groups:

- Apps
- Modules
- Shared Packages

The Workspace is not a place for business logic implementation.

---

### App

The App Layer is a composition layer.

App Layer responsibilities:

- Bootstrap application
- Configure external services
- Register dependencies
- Configure routing
- Compose modules
- Configure MaterialApp
- Provide global state

The App Layer does not contain domain business logic.

Example:

```text
lib/
├── app/
├── core/
└── modules/
```

---

### Module

Module is the main modular unit in FSDA.

Modules group features that belong to the same business domain.

Example:

```text
task/
├── task
├── task_category
└── task_milestone
```

Modules can be used by one or more applications.

---

### Feature

A Feature is a representation of a business capability within a module.

Example:

```text
task
task_category
task_milestone
wallet
product
destination
```

A Feature serves as the primary boundary for domain implementation.

---

### Feature Slice

A feature slice is a modular grouping of related components within a feature, organized around a responsibility. It may have a Logic part under `logic/<slice>`, a UI part under `ui/<slice>`, or both. Matching Logic and UI folder names are parts of the same slice.

Example:

```text
features/product/
├── logic/
│   ├── update/
│   └── form_update/
└── ui/
	└── update/
```

Here, `logic/update` and `ui/update` are the Logic and UI parts of the `update` slice. The `form_update` slice has a separate responsibility that supports the update flow and may have only a Logic part.

A slice does not need a direct relationship with a sequence. App, as the orchestrator, composes the UI and Logic parts needed for a feature flow. The Logic part of `update` may call multiple Use Cases, each with its own sequence; `form_update` may manage form state without calling a Use Case. Different slices may also be related to the same Use Case or sequence.

The conceptual FSDA hierarchy can be summarized as:

```text
One Module → many Features
One Feature → many Feature Flows
One Feature Flow → a composition of Slices and/or Sequences
```

A **feature flow** is a conceptual term for describing a requirement or capability in motion. It does not introduce another layer or required folder. App composes and orchestrates related components so the flow can run.

---

### Shared Package

Shared Packages provide a foundation that is shared across the entire system.

Example:

```text
packages/
├── app_core
├── infra_...
├── app_l10n
└── app_ui
```

Shared Packages provide contracts, utilities, UI foundations, and technology integrations that can be used by all applications and modules.



## Architecture Layers

*(Execution Flow — runtime interaction)*
```
User
 ↓ event
UI part (presentation; sends callback)
 ↓ callback / data through composition
App (orchestrator)
 ├── provides input to Logic
 ├── reads Logic state and provides it to UI
 └── dispatches Logic actions
		↓
	Logic part(s)
		↓ calls related Use Case(s)
	Use Case(s) ──► Repository contract (Domain)
					  ⇣ implemented at runtime by
				Repository implementation (Data)
					  ↓
				Data source / external system
```

The Use Case-to-Data flow is a sequence. UI and Logic slices are outside the sequence definition. Results return through the Use Case and Logic; App connects Logic state and UI callbacks. UI does not call Logic directly.

Layer details and responsibilities are explained in:

* [Data Layer](layers/data-layer.md)
* [Domain Layer](layers/domain-layer.md)
* [Logic Layer](layers/logic-layer.md)
* [UI Layer](layers/ui-layer.md)

The App as a composition layer is explained separately in:

* [App Layer](layers/app.md)



## Dependency Summary

*(Dependency Rule)*
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

The dependency arrows show that App can compose UI, Logic, Domain, and Data implementations (for example, during DI registration). UI, Logic, and Data each depend on Domain according to their contracts. There is no direct UI → Logic dependency; App orchestrates the UI and Logic parts through callbacks, providers, or another composition mechanism.

Detailed dependency rules are explained in:

* [Dependency Rules](dependency-rules.md)



## Sequence-Based Development

FSDA uses a Sequence-Based Development approach.

Sequence describes the Use Case-to-Data flow. Its type is determined by the combination of Use Case flow and signature: async, sync, or stream, each with void, param, return, or return + param. This results in 12 sequence types.

A feature flow may involve one or more slices and/or sequences. A slice may be related to several sequences, and a sequence may be related to several slices or feature flows. App orchestrates the relevant UI/Logic parts with the required sequences.

Use **feature flow** as a descriptive term for the whole process, such as updating a product. It describes the relationships among slices, sequences, and App orchestration; it is not a required folder or formal architectural abstraction.

For example, App composes the UI part `ui/update`, Logic parts `logic/update` and `logic/form_update`, and two Use Cases/sequences for uploading an image and updating a product. For deleting a product, App may compose `ui/delete`, `logic/delete`, and one delete sequence. The composition depends on the flow's requirements.



## Principles

All core principles of FSDA are explained in:

* [Principles](principles.md)



## Structure

The structure of folders, modules, features, feature slices, and sequences are explained in:

* [Structure](structure.md)



## Shared Packages 

Shared package documentation is compiled separately per package so that the responsibility of each foundation remains explicit.

* [app_core](../packages/app-core.md)
* [app_l10n](../packages/app-l10n.md)
* [app_ui](../packages/app-ui.md)



## Conventions

Currently available convention documents:

* [Naming Conventions](../conventions/naming-conventions.md)
* [Coding Standards](../conventions/coding-standards.md)
* [Commit Conventions](../conventions/commit-conventions.md)

Other conventions will be published separately according to documentation needs.



## Supporting Documents

The following supporting documents help explain the foundations, decision-making, testing, and tooling direction of FSDA.

* [Foundations](foundations.md)
* [Sequence Decision Guide](../guides/sequence-decision-guide.md)
* [Testing Strategy](../guides/testing-strategy.md)
* [Anti-Patterns](../guides/anti-patterns.md)
* [Tooling](../guides/tooling.md)



## Philosophy

> A good architecture helps developers make decisions.

> A great architecture reduces the number of decisions developers need to make.

FSDA is built upon this philosophy.

With clear rules, consistent structures, and explicit boundaries, developers can focus more on solving business problems without constantly having to think about how the project should be structured.



## Status

🚧 Under Active Development

FSDA continues to evolve based on real-world experience in developing Flutter applications and the need to maintain consistency, scalability, and ease of automation in the long run.