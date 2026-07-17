# Anti-Patterns

This document summarizes patterns that should be avoided when using FSDA.


## Purpose

Anti-patterns help keep architecture consistent by highlighting implementation choices that look practical at first but usually cause drift later.


## Common Anti-Patterns

Avoid the following:

* starting implementation from folders instead of sequence
* placing business orchestration in UI
* letting DTO or raw responses leak into Logic or UI
* accessing repository implementation directly from inappropriate layers
* moving resources to shared boundaries too early without clear ownership
* creating naming variants outside active conventions
* combining multiple business goals into one slice
* allowing circular dependency across features


## Folder First vs Sequence First

This anti-pattern does not mean folders are unimportant.

Workspace, module, and feature still require clear folder structure. The problem appears when implementation starts by guessing folders, files, and classes before the slice and sequence are clear.

Wrong approach example:

* new requirement arrives: `delete wallet`
* developer immediately creates `data/`, `domain/`, `logic/`, `ui/`, several request/response/cubit/widget/repository files
* only then they try to guess the flow

Problems with this approach:

* structure grows without clear reason
* generated files often miss the correct sequence blueprint
* naming and dependency drift more easily

Correct approach:

* start from requirement
* identify the feature slice
* choose the most appropriate sequence
* open the corresponding blueprint
* then derive folders, files, classes, and implementation flow

In short: folders still matter, but folders should follow sequence decisions, not the other way around.


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

Do not force a slice into an unsuitable sequence only to mimic another implementation.

If sequence feels wrong, reevaluate slice requirement first.
