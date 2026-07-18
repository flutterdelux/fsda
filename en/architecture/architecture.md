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
├── Modules
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

A Feature Slice is the smallest development unit in FSDA.

Example:

```text
create
update
delete
list
detail
status
mark_all_read
```

A Feature Slice has one clear purpose and follows one clear sequence.

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

*(Execution Flow)*
```
UI
 ↓ (calls)
Logic
 ↓ (calls)
Domain

Data
 └─ implement Domain Contract
```

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

**Important**: The arrow from UI to Logic in the execution flow is not a direct structural dependency from the UI layer, but rather merely a *method* access. The one responsible for assembling (composing) the UI and Logic is the **App** layer. The UI, Logic, and Data layers essentially depend on the Domain layer independently.

Detailed dependency rules are explained in:

* [Dependency Rules](dependency-rules.md)



## Sequence-Based Development

FSDA uses a Sequence-Based Development approach.

Every Feature Slice must follow a defined sequence.

Examples:

- Mutation
- Mutation + Param
- Mutation + Return
- Mutation + Return + Param
- Retrieval
- Retrieval + Param
- Retrieval + Pagination
- Retrieval + Stream
- Retrieval + Stream + Param
- Retrieval + Offline First

Sequences provide implementation patterns that are consistent, predictable, and easy to automate.



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