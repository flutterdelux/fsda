# Sequence Pattern

## What is Sequence

Sequence is an implementation pattern that defines data flow, implementation structure, and layer interactions for each feature slice.

## Why Sequence Exists

Sequence exists to ensure every feature slice implementation follows a consistent pattern, so implementation becomes:

* predictable
* consistent
* easy to learn
* easy to automate

## Sequence Registry

| Code | Sequence | Diagram | Blueprint | Test |
| ---- | -------- | ------- | --------- | ---- |
| M | Mutation | [Open](../specs/sequences/mutation-sequence.md) | [Open](../specs/blueprints/mutation-blueprint.md) | [Planned] |
| Mp | Mutation + Param | [Open](../specs/sequences/mutation-param-sequence.md) | [Open](../specs/blueprints/mutation-param-blueprint.md) | [Planned] |
| Mr | Mutation + Return | [Open](../specs/sequences/mutation-return-sequence.md) | [Open](../specs/blueprints/mutation-return-blueprint.md) | [Planned] |
| Mrp | Mutation + Return + Param | [Open](../specs/sequences/mutation-return-param-sequence.md) | [Open](../specs/blueprints/mutation-return-param-blueprint.md) | [Planned] |
| R | Retrieval | [Open](../specs/sequences/retrieval-sequence.md) | [Open](../specs/blueprints/retrieval-blueprint.md) | [Open](../specs/tests/retrieval_test.md) |
| Rp | Retrieval + Param | [Open](../specs/sequences/retrieval-param-sequence.md) | [Open](../specs/blueprints/retrieval-param-blueprint.md) | [Planned] |
| Rpag | Retrieval + Pagination | [Open](../specs/sequences/retrieval-pagination-sequence.md) | [Open](../specs/blueprints/retrieval-pagination-blueprint.md) | [Planned] |
| Rs | Retrieval + Stream | [Open](../specs/sequences/retrieval-stream-sequence.md) | [Open](../specs/blueprints/retrieval-stream-blueprint.md) | [Planned] |
| Rsp | Retrieval + Stream + Param | [Open](../specs/sequences/retrieval-stream-param-sequence.md) | [Open](../specs/blueprints/retrieval-stream-param-blueprint.md) | [Planned] |
| Rof | Retrieval + Offline First | [Open](../specs/sequences/retrieval-offline-first-sequence.md) | [Open](../specs/blueprints/retrieval-offline-first-blueprint.md) | [Planned] |
