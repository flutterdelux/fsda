# FSDA Principles

## 1. Modular First

Applications are built from independent modules.

Each module represents one business domain that can be developed, tested, maintained, and reused independently.

Module is the primary organizational unit in the codebase.

Examples:

* Inbox Module
* Task Module
* Finance Module
* Product Module

App does not contain business logic.

App only composes required modules.

&nbsp;

## 2. Feature-Oriented Design

Each module consists of one or more features.

Feature is a clear functional boundary inside a business domain.

Example in Task Module:

* Task Feature
* Task Category Feature
* Task Milestone Feature

Features are not globally organized by layer.

Feature is the center of code organization.

&nbsp;

## 3. Sequence-Driven Development

Feature slice implementation must follow predefined sequence patterns.

Sequence defines data flow pattern, implementation structure, and layer interaction.

Example sequences:

* Mutation
* Mutation + Param
* Mutation + Return
* Mutation + Return + Param
* Retrieval
* Retrieval + Param
* Retrieval + Pagination
* Retrieval + Stream
* Retrieval + Stream + Param
* Retrieval + Cache
* Retrieval + Local First

Each feature slice must map to exactly one clear sequence.

Example:

```text
mark_all_read  -> Mutation

delete         -> Mutation + Param

create         -> Mutation + Return + Param

detail         -> Retrieval + Param

list           -> Retrieval + Pagination
```

With this approach, implementation becomes:

* predictable
* consistent
* easy to learn
* easy to automate

&nbsp;

## 4. Single Responsibility per Feature Slice

Each feature slice represents only one specific business goal.

A feature slice must not combine multiple different goals in one implementation.

Examples of feature slices:

* create
* update
* delete
* list
* detail
* status
* mark_all_read

Each feature slice must have clear responsibility, be independently understandable, and map to one defined sequence.

Feature slice is the smallest development unit in FSDA.

&nbsp;

## 5. Explicit Data Flow

Data flow must always be visible and traceable.

Data moves explicitly through layers.

UI -> Logic -> Domain -> Data

Hidden, hard-to-follow flows are not allowed.

Developers should easily trace data from UI to source.

&nbsp;

## 6. Dependency Inward

Dependencies always point inward.

Outer layers may know inner layers.

Inner layers must not know outer layers.

```text
UI
 ↓
Logic
 ↓
Domain
 ↑
Data
```

Or in dependency order:

```text
(Inner)
Domain

↑
Logic

↑
UI

↑
Data
(Outer)
```

Domain becomes an independent business center, isolated from technical implementation.

&nbsp;

## 7. Shared by Boundary

Shared components should be placed in the nearest boundary that actually needs them.

Shared is not unlimited common storage.

Each shared component must have clear usage scope.

Shared placement guidelines:

* Used by multiple slices in one feature -> place in feature shared boundary
* Used by multiple features in one module -> place in module shared boundary
* Used by whole application -> place in app or suitable package boundary
* Components should not be promoted to higher boundary only because higher boundaries access them. Ownership still follows primary usage boundary.

Shared follows actual usage boundary, not future guesses.

&nbsp;

## 8. Consistency Over Preference

Consistency is more important than personal preference.

If a pattern is chosen, the entire codebase should follow it.

Developers should not introduce style variations only due to personal preference.

Consistent codebase is easier to learn and maintain than highly varied codebase.

&nbsp;

## 9. Discoverability First

Code structure should help developers find things quickly without deep searching.

Developers should quickly answer:

* where is this feature?
* where is this use case?
* where is this state?
* where is this widget?

Code navigation should be prioritized over overly complex structural optimization.

&nbsp;

## 10. Convention Over Configuration

Repeated decisions should be solved by convention.

Developers should not repeatedly decide:

* folder naming
* file naming
* class placement
* state placement
* widget placement

Clear conventions reduce repeated discussions and speed up development.

&nbsp;

## 11. Scalable by Default

Structure should stay comfortable as project grows.

Good structure should still work when the app has:

* dozens of modules
* hundreds of features
* thousands of files

Architecture decisions should work across different scales, so when project grows or shrinks, structure and principles remain consistent.

&nbsp;

## 12. Automation Friendly

Architecture should be understandable by both humans and tooling.

Consistent conventions enable:

* code generation
* scaffolding
* linting
* validation
* automation

The fewer structural exceptions, the easier architecture automation becomes.
