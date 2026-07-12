# Foundations

This document explains the foundational abstractions that commonly appear in FSDA examples.

&nbsp;

## Purpose

FSDA depends not only on folder structure, but also on baseline abstractions that keep implementation flow consistent.

This document does not lock a single final package implementation. It explains commonly used abstraction roles.

&nbsp;

## Core Concepts

Frequently used abstractions include:

* `Failure`
* `Exception`
* `Result` or `AsyncResult`
* `UseCase`
* `Repository Contract`
* `RepositoryExceptionHandler`
* `AppLogger`

&nbsp;

## Failure

`Failure` represents failure on domain side.

Failure is used by layers above Data as error already translated into business language or a more stable boundary.

In FSDA, module-scoped failures are placed at:

```text
module/shared/domain/errors/
```

&nbsp;

## Exception

`Exception` represents technical failure in Data layer.

Exception must not leak into Logic or UI. It should be translated into Failure first.

In FSDA, module-scoped exceptions are placed at:

```text
module/shared/data/errors/
```

&nbsp;

## Result and AsyncResult

`Result` or `AsyncResult` helps keep operation outcomes explicit.

This approach is commonly used so success and failure can be handled consistently without throwing errors upward arbitrarily.

&nbsp;

## UseCase

`UseCase` is the business entry point in Domain layer.

UseCase commonly:

* accepts input as `Param`
* calls `Repository Contract`
* returns `Result` or `AsyncResult`

&nbsp;

## Repository Contract

Repository contract belongs in Domain.

It defines required business operations without knowing implementation details.

&nbsp;

## RepositoryExceptionHandler

This abstraction is commonly used in Data layer to translate technical exceptions into stable failures.

Concrete implementation may vary, but the role remains the same: keep error translation flow consistent.

&nbsp;

## AppLogger

`AppLogger` (or equivalent logging abstraction) records technical events without mixing logging details randomly into each business flow.

If logging is needed across many boundaries, place the abstraction in a stable foundation like `app_core` or an appropriate shared package.

&nbsp;

## Placement Guidance

Not all abstractions must be placed in the same location for every project.

Use these principles:

* system-wide stable abstractions fit shared packages like `app_core`
* abstractions relevant to one module should remain in that module boundary
* do not promote abstractions to higher boundaries before reuse and ownership are truly clear
