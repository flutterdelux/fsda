# Dependency Rules

This document defines dependency rules in FSDA.

Primary goals of dependency rules:

- keep dependency direction consistent
- prevent cross-layer coupling
- keep features movable
- ensure deterministic automation
- preserve long-term scalability

&nbsp;

## Dependency Direction

Dependencies always point inward.

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```

Domain does not know other layers.

Domain is the contract center of the application.

&nbsp;

## Layer Dependency Matrix

| Layer  | Allowed Dependencies |
| ------ | -------------------- |
| Domain | Domain               |
| Data   | Domain, Data         |
| Logic  | Domain, Logic        |
| UI     | Domain, UI           |

&nbsp;

## Domain Layer Rules

Domain is the most stable layer.

Domain defines:

- Entity
- Repository Contract
- Use Case
- Param
- Failure
- Business Enum

Domain must not know implementation details.

### Domain Can Depend On

Allowed:

```text
domain/
```

Example:

```dart
import '../entities/task.dart';
import '../repositories/task_repository.dart';
```

### Domain Cannot Depend On

Forbidden:

```text
data/
logic/
ui/
flutter/
```

Wrong examples:

```dart
import '../../data/dtos/task_dto.dart';
import '../../logic/create/task_create_cubit.dart';
import 'package:flutter/material.dart';
```

### Correct Example

```dart
import '../repositories/task_repository.dart';

class TaskCreateUseCase {
  final TaskRepository _repository;

  const TaskCreateUseCase({required TaskRepository taskRepository})
      : _repository = taskRepository;
}
```

### Wrong Example

```dart
import '../../data/repositories/task_repository_impl.dart';
import '../../logic/create/task_create_cubit.dart';
import '../../ui/create/pages/task_create_page.dart';
```

&nbsp;

## Data Layer Rules

Data implements domain contracts.

Data is responsible for:

- API
- Database
- Cache
- DTO
- Request
- Response
- Converter
- Repository Implementation

### Data Can Depend On

Allowed:

```text
domain/
data/
```

Examples:

```dart
import '../../domain/entities/task.dart';
import '../dtos/task_dto.dart';
```

### Correct Examples

```dart
import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';
import '../converters/task_converter.dart';
```

### Data Cannot Depend On

Forbidden:

```text
logic/
ui/
```

### Wrong Examples

```dart
import '../../logic/create/task_create_cubit.dart';
import '../../logic/create/task_create_state.dart';
import '../../ui/create/pages/task_create_page.dart';
```

&nbsp;

## Logic Layer Rules

Logic orchestrates use cases.

Logic is responsible for:

- State
- Cubit
- Bloc
- Provider
- Controller
- other state-management adapters

Logic must not know Data implementation details.

### Logic Can Depend On

Allowed:

```text
domain/
logic/
```

Example:

```dart
import '../../domain/usecases/task_create_use_case.dart';
```

### Correct Examples

```dart
import '../../domain/usecases/task_create_use_case.dart';
import '../../domain/params/task_create_param.dart';
import 'task_create_state.dart';
```

### Logic Cannot Depend On

Forbidden:

```text
data/
ui/
```

### Wrong Examples

```dart
import '../../data/dtos/task_dto.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../ui/create/pages/task_create_page.dart';
```

&nbsp;

## UI Layer Rules

UI is the user-facing presentation layer.

UI should be as simple as possible.

UI is responsible for:

- View
- Widget
- Dialog, bottom sheet, and other UI components

UI must not access Data or Logic layers directly.

UI may use Domain only as stable presentation models: entity, enum, param.

UI must not access domain repository contract or use case.

App layer composes UI with Logic.

### UI Can Depend On

Allowed:

```text
domain/ (entity, enum, param only)
ui/
flutter/
app_ui/
```

### Correct Examples

```dart
import '../../domain/params/task_create_param.dart';
import '../widgets/task_form.dart';
import '../extensions/task_status_x.dart';
import 'package:app_ui/app_ui.dart';
```

### UI Cannot Depend On

Forbidden:

```text
data/
logic/
```

### Wrong Examples

```dart
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/task_create_use_case.dart';
import '../../logic/create/task_create_cubit.dart';
```

&nbsp;

## App Layer Rules

App layer is the orchestrator.

App layer is responsible for:

- Routing
- Dependency Injection
- Navigation
- Module Composition
- Global State Composition

### App Can Depend On

Allowed:

```text
modules/
packages/
```

### Correct Examples

```dart
routes: [
  InboxRoute.base,
  TaskRoute.base,
]
```

```dart
await inboxDI();
await taskDI();
```

&nbsp;

## Cross Feature Rules

Feature-to-feature access is allowed only inside the same module.

This is allowed because module is the primary business boundary. In some cases, operations are tightly related across features while ownership remains clear at module level.

Cross-feature access must remain:

- simple
- explicit
- aligned with layer dependency rules
- free from circular dependency

Cross-feature modeling cascade for DTO, Entity, Param, Request, Response, Enum, or other explicit references is acceptable when flow stays clear.

If `featureC` needs operation in `featureD` (for example, `createTransaction` needs `createTransactionItems`), access is allowed when relation is clear and does not create circular dependency.

### Allowed

Within same module, cross-feature access can use:

```text
modeling cascade
shared/
domain contract
```

Feature barrel may be used for discoverability, but within one module direct imports can be acceptable when explicit and readable.

Allowed does not mean all internal files are free to access. Keep access explicit and ownership clear.

### Wrong Example

```text
feature_c -> feature_d
feature_d -> feature_c
```

```dart
import '../feature_d/data/repositories/feature_d_repository_impl.dart';
```

Avoid cross-feature access that makes ownership and flow unclear.

&nbsp;

## Cross Module Rules

Modules must not access internals of other modules.

### Allowed

Use public barrel exports.

```dart
import 'package:task/task.dart';
```

### Wrong Example

```dart
import 'package:task/src/features/task/...';
```

&nbsp;

## Shared Rules

Shared placement follows actual usage boundary.

### Feature Shared

Used by multiple slices in one feature.

```text
feature/
 └── shared/
```

### Module Shared

Used by multiple features in one module.

```text
module/
 └── shared/
```

### App Shared

Used across modules.

```text
app/
core/
packages/
```

Do not move components to higher boundary only because higher boundaries read them.

Ownership should follow primary usage boundary.

&nbsp;

## Golden Rule

Dependency must always point to more stable contracts.

Do not depend on implementation.

Depend on contract, not implementation.

Domain is effectively shared contract space for entity, enum, and param.
