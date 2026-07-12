# Sequence Pattern

## What is Sequence

Sequence adalah pola implementasi yang mendefinisikan aliran data, struktur implementasi, serta bentuk interaksi antar layer untuk setiap feature slice.

## Why Sequence Exists

Sequence ada untuk memastikan seluruh implementasi feature slice mengikuti pola yang konsisten, sehingga seluruh implementasi menjadi:
* predictable
* konsisten
* mudah dipelajari
* mudah diautomasi

## Sequence Registry

| Code | Sequence                      | Module       | Feature     | Feature Slice |  Blueprint                                                             |
| ---- | ----------------------------- | ------------ | ----------- | ------------- |  --------------------------------------------------------------------- |
| M    | Mutation                      | inbox        | inbox       | mark_all_read        | [Open](../specs/blueprints/mutation-blueprint.md)              |
| Mp   | Mutation + Param              | finance      | wallet      | delete                   | [Open](../specs/blueprints/mutation-param-blueprint.md)        |
| Mr   | Mutation + Return             | queue        | queue       | take          | [Open](../specs/blueprints/mutation-return-blueprint.md)       |
| Mrp  | Mutation + Return + Param     | task         | task        | create        | [Open](../specs/blueprints/mutation-return-param-blueprint.md) |
| R    | Retrieval                     | travel       | destination | popular       | [Open](../specs/blueprints/retrieval-blueprint.md)             |
| Rp   | Retrieval + Param             | product      | product     | detail        | [Open](../specs/blueprints/retrieval-param-blueprint.md)       |
| Rpag | Retrieval + Pagination        | location     | city        | list          | [Open](../specs/blueprints/retrieval-pagination-blueprint.md)  |
| Rs   | Retrieval + Stream            | attendance   | attendance  | list          | [Open](../specs/blueprints/retrieval-stream-blueprint.md)      |
| Rsp  | Retrieval + Stream + Param    | subscription | payment     | status        | [Open](../specs/blueprints/retrieval-stream-param-blueprint.md)|
| Rof  | Retrieval + Offline First     | note         | note        | list          | [Open](../specs/blueprints/retrieval-offline-first-blueprint.md) |

