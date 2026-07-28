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

The implementation of a feature slice must follow a defined sequence pattern.

A sequence defines the data flow pattern, implementation structure, and interaction form between layers.

Sequence examples:

* Mutation
* Mutation + Param
* Mutation + Return
* Mutation + Return + Param
* Retrieval
* Retrieval + Param
* Retrieval + Pagination
* Retrieval + Stream
* Retrieval + Stream + Param
* Retrieval + Offline First

Every feature slice must map to exactly one clear sequence.

Example:

```
mark_all_read  -> Mutation

delete         -> Mutation + Param

create         -> Mutation + Return + Param

detail         -> Retrieval + Param

list           -> Retrieval + Pagination
```

With this approach, all implementations become:

* predictable
* consistent
* easy to learn
* easy to automate

## 4. Single Responsibility per Feature Slice

Each feature slice represents only one specific business goal.

A feature slice must not combine multiple distinct goals into a single implementation.

Feature slice examples:

* create
* update
* delete
* list
* detail
* status
* mark_all_read

Each feature slice must have a clear responsibility, be understandable on its own, and map to a defined sequence.

A feature slice is the smallest development unit in FSDA.

## 5. Explicit Data Flow

Data flow must always be visible and traceable.

Data moves explicitly through layers:

UI → Logic → Domain → Data

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