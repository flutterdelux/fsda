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

1. [Architecture Overview](/en/architecture/architecture)
2. [Principles](/en/architecture/principles)
3. [Structure](/en/architecture/structure)
4. [Dependency Rules](/en/architecture/dependency-rules)
5. [Sequence Pattern](/en/architecture/sequence-pattern)
6. [Naming Conventions](/en/conventions/naming-conventions)
7. [Domain Layer](/en/architecture/layers/domain-layer)
8. [Data Layer](/en/architecture/layers/data-layer)
9. [Logic Layer](/en/architecture/layers/logic-layer)
10. [UI Layer](/en/architecture/layers/ui-layer)
11. [App Layer](/en/architecture/layers/app)
12. [Development Workflow](/en/guides/development-workflow)
13. [Structure Example](/en/architecture/structure-example)

Then continue with supporting documents:

* [Foundations](/en/architecture/foundations)
* [Sequence Decision Guide](/en/guides/sequence-decision-guide)
* [Testing Strategy](/en/guides/testing-strategy)
* [Anti-Patterns](/en/guides/anti-patterns)
* [Tooling](/en/guides/tooling)

## Getting Started Paths (Wikuy)

For practical end-to-end onboarding, choose one path:

1. [Manual E2E (without FSDA CLI)](/en/getting-started-manual-wikuy)
2. [CLI-Driven E2E (mostly FSDA CLI + small manual finalization)](/en/getting-started-cli-wikuy)

Both paths target the same output:

* Workspace: `Wikuy`
* App: `wikuy`
* Module: `travel`
* Feature: `destination`
* Slice: `list`
* Sequence: `R`
* UI: `lsv`
* Main page class: `DestinationListPage`
* API source: `GET /destinations`
