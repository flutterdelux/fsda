# Feature Slice Driven Architecture (FSDA)

> A pragmatic, rule-driven Flutter architecture focused on consistency, discoverability, maintainability, scalability, and automation.

&nbsp;

## What is Feature Slice Driven Architecture (FSDA)?

FSDA is a Flutter architecture designed to build applications that are consistent, easy to understand, easy to maintain, and easy to evolve over time.

This architecture combines proven concepts from:

- Clean Architecture
- Domain Driven Design (DDD)
- Feature First Architecture
- Modular Monorepo Architecture
- Layered Architecture
- Package-Based Architecture
- Separation of Concerns
- SOLID Principles
- Dependency Inversion Principle

FSDA is not intended to be a direct copy of a single philosophy.

Instead, FSDA focuses on building a project structure that is consistent, predictable, discoverable, understandable, and automation-friendly.

&nbsp;

## Why FSDA?

Many architectures explain:

- which layers should exist
- how dependencies should flow
- what responsibilities each layer has

But they often do not explain:

- where files should live
- how module structure should be built
- how feature structure should be built
- how to maintain consistency across developers
- how to maintain consistency across projects
- how to reduce architectural drift
- how to design structure that can be automated

As a result, two projects claiming the same architecture often end up with significantly different structures.

FSDA reduces this ambiguity through explicit and consistent implementation rules.

&nbsp;

## Structural Overview

FSDA uses a Modular Monorepo approach.

```text
Workspace
├── Apps
├── Modules
└── Packages
```

Each boundary has clear responsibilities and explicit constraints.

&nbsp;

### Workspace

Workspace is the root of the entire system.

Workspace groups:

- Apps
- Modules
- Shared Packages
- Documentation

Workspace is not where business logic is implemented.

&nbsp;

### App

App Layer is the composition layer.

App Layer responsibilities:

- Bootstrap application
- Configure external services
- Register dependencies
- Configure routing
- Compose modules
- Configure MaterialApp
- Provide global state

App Layer should not contain domain business logic.

Example:

```text
lib/
├── app/
├── core/
└── modules/
```

&nbsp;

### Module

Module is the primary modular unit in FSDA.

A module groups features that belong to the same business domain.

Example:

```text
task/
├── task
├── task_category
└── task_milestone
```

A module can be used by one or multiple applications.

&nbsp;

### Feature

Feature represents a business capability inside a module.

Example:

```text
task
task_category
task_milestone
wallet
product
destination
```

Feature is the primary domain implementation boundary.

&nbsp;

### Feature Slice

Feature Slice is the smallest development unit in FSDA.

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

A feature slice has one clear goal and follows one clear sequence.

&nbsp;

### Shared Package

Shared Package provides system-wide foundations used across apps and modules.

Example:

```text
packages/
├── app_core
├── infra_...
├── app_l10n
└── app_ui
```

Shared packages provide contracts, utilities, UI foundations, and technology integrations reusable across the system.

&nbsp;

## Architecture Layers

```
UI
 ↓
Logic
 ↓
Domain

Data
 └─ implement Domain Contract
```

Layer details and responsibilities are explained in:

* [Data Layer](layers/data-layer.md)
* [Domain Layer](layers/domain-layer.md)
* [Logic Layer](layers/logic-layer.md)
* [UI Layer](layers/ui-layer.md)

App as composition layer is described separately in:

* [App Layer](layers/app.md)

&nbsp;

## Dependency Overview

```
UI
 ↓
Logic
 ↓
Domain
 ↑
Data
```

Dependency rules are detailed in:

* [Dependency Rules](dependency-rules.md)

&nbsp;

## Sequence-Based Development

FSDA uses Sequence-Based Development.

Every Feature Slice must follow a predefined sequence.

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
- Retrieval + Cache
- Retrieval + Local First

Sequence patterns provide implementation that is consistent, predictable, and automation-friendly.

&nbsp;

## Principles

All core FSDA principles are documented in:

* [Principles](principles.md)

&nbsp;
