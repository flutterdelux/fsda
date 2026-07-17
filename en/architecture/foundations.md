# Foundations

This document explains the foundational abstractions that frequently appear in FSDA examples.

## Objective

FSDA does not only depend on folder structures, but also on several basic abstractions that help maintain a consistent implementation flow.

This document does not lock the final implementation to one specific package, but explains the role of commonly used abstractions.

## Core Concepts

Abstractions that frequently appear include:

* `Failure`
* `Exception`
* `Result` or `AsyncResult`
* `UseCase`
* `Repository Contract`
* `RepositoryExceptionHandler`
* `AppLogger`

## Failure

`Failure` represents a failure on the domain side.

Failure is used by layers above Data as a form of error that has been translated into business language or a more stable boundary.

In FSDA, module-scope failures are placed in:

```text
module/shared/domain/errors/
```

## Exception

`Exception` represents technical failures in the Data layer.

Exceptions must not leak to Logic or UI. Exceptions must first be translated into Failures.

In FSDA, module-scope exceptions are placed in:

```text
module/shared/data/errors/
```

## Result and AsyncResult

`Result` or `AsyncResult` helps keep the outcome of operations explicit.

This approach is usually used so that successes and failures can be treated consistently without arbitrarily throwing errors to upper layers.

## UseCase

`UseCase` acts as the business entry point in the Domain layer.

A UseCase typically:

* receives input in the form of a `Param`
* calls the `Repository Contract`
* returns a `Result` or `AsyncResult`

## Repository Contract

Repository contracts reside in the Domain.

A Repository contract defines the required business operations without knowing the details of how they are implemented.

## RepositoryExceptionHandler

This abstraction is usually used in the Data layer to help translate technical exceptions into more stable failures.

Its concrete implementation may vary, but its role remains the same: keeping the error translation flow consistent.

## AppLogger

`AppLogger` or similar logging abstractions are used to log technical events without randomly mixing logging details into every business flow.

If logging is needed across many boundaries, place its abstraction in a stable foundation like `app_core` or an appropriate shared package.

## Placement Guidelines

Not all abstractions must be placed in the same location for all projects.

Use the following principles:

* abstractions that cross the system and are stable belong in a shared package like `app_core`
* abstractions that are only relevant in one module are better kept within that module's boundary
* do not move foundations to a higher boundary until their reuse and ownership are completely clear