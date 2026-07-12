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

| Code | Sequence                   | Module       | Feature     | Feature Slice  | Blueprint |
| ---- | -------------------------- | ------------ | ----------- | -------------- | --------- |
| M    | Mutation                   | inbox        | inbox       | mark_all_read  | [Open](../specs/blueprints/mutation-blueprint.md) |
| Mp   | Mutation + Param           | finance      | wallet      | delete         | [Open](../specs/blueprints/mutation-param-blueprint.md) |
| Mr   | Mutation + Return          | queue        | queue       | take           | [Open](../specs/blueprints/mutation-return-blueprint.md) |
| Mrp  | Mutation + Return + Param  | task         | task        | create         | [Open](../specs/blueprints/mutation-return-param-blueprint.md) |
| R    | Retrieval                  | travel       | destination | popular        | [Open](../specs/blueprints/retrieval-blueprint.md) |
| Rp   | Retrieval + Param          | product      | product     | detail         | [Open](../specs/blueprints/retrieval-param-blueprint.md) |
| Rpag | Retrieval + Pagination     | location     | city        | list           | [Open](../specs/blueprints/retrieval-pagination-blueprint.md) |
| Rs   | Retrieval + Stream         | attendance   | attendance  | list           | [Open](../specs/blueprints/retrieval-stream-blueprint.md) |
| Rsp  | Retrieval + Stream + Param | subscription | payment     | status         | [Open](../specs/blueprints/retrieval-stream-param-blueprint.md) |
| Rof  | Retrieval + Offline First  | note         | note        | list           | [Open](../specs/blueprints/retrieval-offline-first-blueprint.md) |
