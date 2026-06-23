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

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           | Blueprint                                                             |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ | --------------------------------------------------------------------- |
| M    | Mutation                      | inbox        | inbox       | mark_all_read | markAllInboxRead()       | [Open](../../specs/v1/blueprints/mutation-blueprint.md)              |
| Mp   | Mutation + Param              | finance      | wallet      | delete        | deleteWallet()           | [Open](../../specs/v1/blueprints/mutation-param-blueprint.md)        |
| Mr   | Mutation + Return             | queue        | queue       | take          | takeQueue()              | [Open](../../specs/v1/blueprints/mutation-return-blueprint.md)       |
| Mrp  | Mutation + Return + Param     | task         | task        | create        | createTask()             | [Open](../../specs/v1/blueprints/mutation-return-param-blueprint.md) |
| R    | Retrieval                     | travel       | destination | popular       | getPopularDestination()  | [Open](../../specs/v1/blueprints/retrieval-blueprint.md)             |
| Rp   | Retrieval + Param             | product      | product     | detail        | getProductDetail()       | [Open](../../specs/v1/blueprints/retrieval-param-blueprint.md)       |
| Rpag | Retrieval + Pagination        | location     | city        | list          | getCityList()            | [Open](../../specs/v1/blueprints/retrieval-pagination-blueprint.md)  |
| Rs   | Retrieval + Stream            | attendance   | attendance  | list          | watchAttendanceList()    | [Open](../../specs/v1/blueprints/retrieval-stream-blueprint.md)      |
| Rsp  | Retrieval + Stream + Param    | subscription | payment     | status        | watchPaymentStatus()     | [Open](../../specs/v1/blueprints/retrieval-stream-param-blueprint.md)|
| Rc   | Retrieval + Cache             | settings     | theme       | mode          | getThemeMode()           | [Open](../../specs/v1/blueprints/retrieval-cache-blueprint.md)       |
| Rloc | Retrieval + Local First       | note         | note        | list          | getNoteList()            | [Open](../../specs/v1/blueprints/retrieval-local-first-blueprint.md) |

### Supported Slice Sequences

| Code | Sequence                       | Supported Slices                                                      |
| ---- | ------------------------------ | --------------------------------------------------------------------- |
| M    | Mutation                       | mark_all_read, logout, ...                                            |
| Mp   | Mutation + Param               | mark_all_read, login, register, add_to_cart, change_password, ...     |
| Mr   | Mutation + Return              | take, archive, ...                                                    |
| Mrp  | Mutation + Return + Param      | create, update, delete, login, register, checkout, update_avatar, ... |
| R    | Retrieval                      | popular, summary, ...                                                 |
| Rp   | Retrieval + Param              | detail, insight, ...                                                  |
| Rpag | Retrieval + Pagination         | list, ...                                                             |
| Rs   | Retrieval + Stream             | list, ...                                                             |
| Rsp  | Retrieval + Stream + Param     | status, ...                                                           |
| Rc   | Retrieval + Cache              | mode, ...                                                             |
| Rloc | Retrieval + Local First        | list, ...                                                             |