# Sequence Pattern

## Apa itu Sequence

Sequence adalah pola implementasi yang mendefinisikan aliran data, struktur implementasi, serta bentuk interaksi antar layer untuk setiap feature slice.

## Mengapa Sequence Ada

Sequence ada untuk memastikan seluruh implementasi feature slice mengikuti pola yang konsisten, sehingga seluruh implementasi menjadi:

* mudah diprediksi
* konsisten
* mudah dipelajari
* mudah diautomasi

## Sequence Registry

| Code | Sequence                      | Diagram                                                            | Blueprint                                                          |
| ---- | ----------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------ |
| M    | Mutation                      | [Open](/specs/sequences/mutation-sequence.md)                    | [Open](/specs/blueprints/mutation-blueprint.md)                  |
| Mp   | Mutation + Param              | [Open](/specs/sequences/mutation-param-sequence.md)              | [Open](/specs/blueprints/mutation-param-blueprint.md)            |
| Mr   | Mutation + Return             | [Open](/specs/sequences/mutation-return-sequence.md)             | [Open](/specs/blueprints/mutation-return-blueprint.md)           |
| Mrp  | Mutation + Return + Param     | [Open](/specs/sequences/mutation-return-param-sequence.md)       | [Open](/specs/blueprints/mutation-return-param-blueprint.md)     |
| R    | Retrieval                     | [Open](/specs/sequences/retrieval-sequence.md)                   | [Open](/specs/blueprints/retrieval-blueprint.md)                 |
| Rp   | Retrieval + Param             | [Open](/specs/sequences/retrieval-param-sequence.md)             | [Open](/specs/blueprints/retrieval-param-blueprint.md)           |
| Rpag | Retrieval + Pagination        | [Open](/specs/sequences/retrieval-pagination-sequence.md)        | [Open](/specs/blueprints/retrieval-pagination-blueprint.md)      |
| Rs   | Retrieval + Stream            | [Open](/specs/sequences/retrieval-stream-sequence.md)            | [Open](/specs/blueprints/retrieval-stream-blueprint.md)          |
| Rsp  | Retrieval + Stream + Param    | [Open](/specs/sequences/retrieval-stream-param-sequence.md)      | [Open](/specs/blueprints/retrieval-stream-param-blueprint.md)    |
| Rof  | Retrieval + Offline First     | [Open](/specs/sequences/retrieval-offline-first-sequence.md)     | [Open](/specs/blueprints/retrieval-offline-first-blueprint.md)   |

