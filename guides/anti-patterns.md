# Anti-Patterns

This document summarizes patterns that should be avoided when using FSDA.


## Purpose

Anti-patterns help keep architecture consistent by highlighting implementation choices that look practical at first but usually cause drift later.


## Common Anti-Patterns

Avoid the following:

* starting implementation from folders before understanding the feature flow and layer responsibilities
* placing business orchestration in UI
* letting DTO or raw responses leak into Logic or UI
* accessing repository implementation directly from inappropriate layers
* moving resources to shared boundaries too early without clear ownership
* creating naming variants outside active conventions
* combining unrelated responsibilities into one feature slice
* allowing circular dependency across features


## Folder First vs Flow and Contract First

This anti-pattern does not mean folders are unimportant.

Workspace, module, and feature still require clear folder structure. The problem appears when implementation starts by guessing folders, files, and classes before the feature flow, Use Cases, and layer responsibilities are clear.

Wrong approach example:

* new requirement arrives: `delete wallet`
* developer immediately creates `data/`, `domain/`, `logic/`, `ui/`, several request/response/cubit/widget/repository files
* only then they try to guess the flow

Problems with this approach:

* structure grows without clear reason
* implementation and tests may diverge from layer rules or Use Case sequence contracts
* naming and dependency drift more easily

Correct approach:

* start from requirement
* identify the feature flow and required Use Cases
* determine sequence types from Use Case contracts
* identify related feature slices and their Logic/UI parts
* then derive folders, files, classes, dependencies, and implementation flow

In short: folders follow layer and slice boundaries; sequence types follow Use Case contracts. App orchestrates the related parts.


## App vs Module Confusion

Avoid mixing App composition concerns with Module implementation concerns.

Avoid cases such as:

* placing page composition in the wrong boundary
* placing route aggregation in module package
* placing app-level dependency injection in feature boundary


## Shared Misuse

`shared/` is not a dumping ground for resources with unclear placement.

Before moving something into shared, make sure:

* reuse is real
* ownership is clear
* nearest boundary is truly insufficient


## Sequence Misuse

Do not assume a feature slice must have one sequence, or that its name determines a sequence.

If the relationship between a slice and a Use Case is unclear, reevaluate the feature flow, layer responsibilities, and App composition.
