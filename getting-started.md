# Getting Started

Welcome to Feature Slice Driven Architecture (FSDA).

This page helps you understand how FSDA works before building features.

## What is FSDA?

FSDA is a modular Flutter architecture built on these principles:

* Feature First
* Domain Centered
* Sequence Driven
* Automation Friendly

Its primary goals are:

* Easy-to-understand structure
* Predictable implementation
* Controlled dependencies
* Portable features
* Tooling-friendly generation

## Read Order

Before starting feature development, read the documentation in the following order:

1. [Architecture Overview](/architecture/architecture)
2. [Principles](/architecture/principles)
3. [Structure](/architecture/structure)
4. [Dependency Rules](/architecture/dependency-rules)
5. [Sequence Pattern](/architecture/sequence-pattern)
6. [Naming Conventions](/conventions/naming-conventions)
7. [Domain Layer](/architecture/layers/domain-layer)
8. [Data Layer](/architecture/layers/data-layer)
9. [Logic Layer](/architecture/layers/logic-layer)
10. [UI Layer](/architecture/layers/ui-layer)
11. [App Layer](/architecture/layers/app)
12. [Development Workflow](/guides/development-workflow)
13. [Structure Example](/architecture/structure-example)

Then continue with supporting documents:

* [Foundations](/architecture/foundations)
* [Sequence Decision Guide](/guides/sequence-decision-guide)
* [Testing Strategy](/guides/testing-strategy)
* [Anti-Patterns](/guides/anti-patterns)
* [Tooling](/guides/tooling)

## Getting Started Paths (Wikuy)

For practical end-to-end onboarding, follow the manual path:

1. [Manual E2E (without FSDA CLI)](/getting-started-wikuy)

For CLI installation, commands, and workflows, see the dedicated [FSDA CLI documentation](https://flutterdelux.github.io/fsda_cli/).

The manual guide targets:

* Workspace: `Wikuy`
* App: `wikuy`
* Module: `travel`
* Feature: `destination`
* Logic slice: `list`
* UI slice: `list`
* Use Case sequence: async return (`ReturnUseCase<List<DestinationEntity>>`)
* UI: `lsv`
* Main page class: `DestinationListPage`
* API source: `GET /destinations`
