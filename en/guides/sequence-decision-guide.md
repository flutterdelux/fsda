# Sequence Decision Guide

This document helps choose the most suitable sequence for a feature slice.

## Purpose

The first question in FSDA is not folder location, but which sequence is most appropriate.

This guide speeds up that decision.

## Quick Decision Flow

Use this flow:

1. Does this slice modify data?
2. If yes, start with `Mutation` family.
3. If not, start with `Retrieval` family.
4. Does this slice require input?
5. Does this slice return operation result?
6. Does this slice need pagination, stream, or offline-first behavior?

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

## Retrieval Family

Use:

* `Retrieval` if it reads data without extra input
* `Retrieval + Param` if it reads data with input
* `Retrieval + Pagination` if list requires paging
* `Retrieval + Stream` if data changes continuously and must be observed
* `Retrieval + Stream + Param` if stream also requires input
* `Retrieval + Offline First` if local source should be prioritized or requires cache mechanism

Examples:

* `popular` -> Retrieval
* `detail` -> Retrieval + Param
* `list` -> Retrieval + Pagination
* `list` -> Retrieval + Stream
* `status` -> Retrieval + Stream + Param
* `list` -> Retrieval + Offline First

## Selection Rule

One feature slice must map to one clear sequence.

If a slice seems to require too many sequences at once, usually:

* the slice is too large
* responsibility boundary is still unclear
* or the flow should be split into multiple slices
