# Sequence Decision Guide

This document helps choose the most suitable sequence for a feature slice.

&nbsp;

## Purpose

The first question in FSDA is not folder location, but which sequence is most appropriate.

This guide speeds up that decision.

&nbsp;

## Quick Decision Flow

Use this flow:

1. Does this slice modify data?
2. If yes, start with `Mutation` family.
3. If not, start with `Retrieval` family.
4. Does this slice require input?
5. Does this slice return operation result?
6. Does this slice need pagination, stream, cache, or local-first behavior?

&nbsp;

## Mutation Family

Use:

* `Mutation` if it does not require params and does not return data
* `Mutation + Param` if it needs input
* `Mutation + Return` if it returns operation result
* `Mutation + Return + Param` if it needs input and returns result

Examples:

* `mark_all_read` -> Mutation
* `delete` -> Mutation + Param
* `take` -> Mutation + Return
* `create` -> Mutation + Return + Param

&nbsp;

## Retrieval Family

Use:

* `Retrieval` if it reads data without extra input
* `Retrieval + Param` if it reads data with input
* `Retrieval + Pagination` if list requires paging
* `Retrieval + Stream` if data changes continuously and must be observed
* `Retrieval + Stream + Param` if stream also requires input
* `Retrieval + Cache` if it reads with simple cache behavior
* `Retrieval + Local First` if local source should be prioritized before remote source

Examples:

* `popular` -> Retrieval
* `detail` -> Retrieval + Param
* `list` -> Retrieval + Pagination
* `status` -> Retrieval + Stream + Param
* `mode` -> Retrieval + Cache
* `note list` -> Retrieval + Local First

&nbsp;

## Selection Rule

One feature slice must map to one clear sequence.

If a slice seems to require too many sequences at once, usually:

* the slice is too large
* responsibility boundary is still unclear
* or the flow should be split into multiple slices
