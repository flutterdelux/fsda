# Coding Standards

This document defines baseline coding guidelines for FSDA.

&nbsp;

## Purpose

Coding standards keep implementation consistent, make reviews easier, and reduce unnecessary variation across the codebase.

&nbsp;

## General Principles

Use the following as your baseline:

* prioritize small, focused changes
* follow established architectural boundaries
* prefer clarity over cleverness
* keep naming aligned with active conventions
* avoid hidden side effects

&nbsp;

## Layer Discipline

Each layer must stay within its responsibility:

* Domain contains stable contracts and business rules
* Data contains technical implementation details
* Logic contains state management and interaction flow
* UI contains presentation
* App contains composition

If a change blurs layer responsibilities, the implementation structure usually needs to be revisited.

&nbsp;

## Code Style

Use a consistent writing style:

* names should be clear and descriptive
* avoid uncommon abbreviations
* avoid one-letter variables except for very short and obvious contexts
* add comments only when they clarify decisions or non-obvious flow
* avoid files or classes with too many responsibilities

&nbsp;

## Flow Clarity

Data flow should be easy to trace from UI to data source.

Keep these rules:

* do not leak DTO into Logic or UI
* do not leak repository implementation into Domain
* do not place business orchestration in UI
* do not place composition concerns in Module

&nbsp;

## Shared Placement

Do not move resources to shared boundaries too early.

Promote a boundary only when:

* it is truly reused
* ownership is clear
* reuse is stable

If a resource is still specific to one feature or one module, keep it in its nearest boundary.

&nbsp;

## Testing Awareness

When writing code, also think about how it will be tested.

Good implementation usually:

* has clear dependencies
* avoids excessive hidden state
* is testable per layer
* does not require excessive technical setup to verify core behavior
