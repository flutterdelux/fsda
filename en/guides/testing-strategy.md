# Testing Strategy

This document describes baseline testing strategy in FSDA.

&nbsp;

## Purpose

Testing strategy ensures each layer can be verified without blurring architectural boundaries.

&nbsp;

## Layer-Based Testing

Use this baseline approach:

* Domain: unit tests for use cases, contract behavior, and business rules
* Data: tests for mapping, error translation, repository behavior, and technical adapters
* Logic: tests for state transitions and orchestration logic
* UI: widget tests for key presentation and interaction
* App: integration or smoke tests for composition, routes, and dependency wiring

&nbsp;

## Sequence-Based Testing

Besides layer focus, tests can also follow sequence behavior.

Example focus:

* Mutation: valid input, invalid input, success flow, failure flow
* Mutation + Return: verify return result and relevant side effects
* Retrieval: success, empty state, failure, loading
* Retrieval + Pagination: page progression, append behavior, end-of-list behavior
* Retrieval + Stream: initial emission, update emission, failure emission when relevant
* Retrieval + Local First: local hit, remote fallback, sync behavior when applicable

&nbsp;

## What To Prioritize

Prioritize tests on:

* boundaries that frequently change
* error translation from Data to Domain
* state transitions in Logic
* critical App composition flows

&nbsp;

## What To Avoid

Avoid tests that:

* are overly tied to unimportant internal implementation details
* are hard to maintain because technical setup is more complex than tested behavior
* duplicate the same validation across too many layers without clear added value
