# Dependency Rules

This document defines the dependency rules in FSDA.

The main goals of dependency rules are:

- Maintain a consistent dependency direction.
- Prevent coupling between layers.
- Ensure features remain easy to move (portable).
- Ensure automation can be performed deterministically.
- Maintain long-term scalability.



## Dependency Direction

Dependencies always point inwards.

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```

The Domain does not know about other layers.

The Domain is the center of application contracts.



## Layer Dependency Matrix

| Layer  | Allowed Dependencies |
| ------ | -------------------- |
| Domain | Domain               |
| Data   | Domain, Data         |
| Logic  | Domain, Logic        |
| UI     | Domain, UI           |



## Domain Layer Rules

The Domain is the most stable layer.

The Domain defines:

- Entity
- Repository Contract
- Use Case
- Param
- Failure
- Business Enum

The Domain must not know about implementations.

---

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

---

### Domain Cannot Depend On

Forbidden:

```text
data/
logic/
ui/
flutter/
```

Example:

```dart
import '../../data/dtos/task_dto.dart';
```

```dart
import '../../logic/create/task_create_cubit.dart';
```

```dart
import 'package:flutter/material.dart';
```

---

### Correct Example

✅ Dependency on domain contract

```dart
import '../repositories/task_repository.dart';

class TaskCreateUseCase {
  final TaskRepository _repository;

  const TaskCreateUseCase({required TaskRepository taskRepository})
      : _repository = taskRepository;
}
```

---

### Wrong Example

❌ Dependency on data implementation

```dart
import '../../data/repositories/task_repository_impl.dart';
```

❌ Dependency on logic layer

```dart
import '../../logic/create/task_create_cubit.dart';
```

❌ Dependency on UI

```dart
import '../../ui/create/pages/task_create_page.dart';
```



## Data Layer Rules

Data is the implementation of domain contracts.

Data is responsible for:

- API
- Database
- Cache
- DTO
- Request
- Response
- Converter
- Repository Implementation

---

### Data Can Depend On

Allowed:

```text
domain/
data/
```

Example:

```dart
import '../../domain/entities/task.dart';
import '../dtos/task_dto.dart';
```

---

### Correct Examples

✅ Dependency on domain contract

```dart
import '../../domain/repositories/task_repository.dart';
```

✅ Dependency on domain entity

```dart
import '../../domain/entities/task.dart';
```

✅ Dependency on another data resource

```dart
import '../converters/task_converter.dart';
```

---

### Data Cannot Depend On

Forbidden:

```text
logic/
ui/
```

---

### Wrong Examples

❌ Dependency on cubit

```dart
import '../../logic/create/task_create_cubit.dart';
```

❌ Dependency on state

```dart
import '../../logic/create/task_create_state.dart';
```

❌ Dependency on page

```dart
import '../../ui/create/pages/task_create_page.dart';
```



## Logic Layer Rules

Logic orchestrates use cases.

Logic is responsible for:

- State
- Cubit
- Bloc
- Provider
- Controller
- Other state management

Logic must not know about data implementations.

---

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

---

### Correct Examples

✅ Dependency on use case

```dart
import '../../domain/usecases/task_create_use_case.dart';
```

✅ Dependency on params

```dart
import '../../domain/params/task_create_param.dart';
```

✅ Dependency on another logic file

```dart
import 'task_create_state.dart';
```

---

### Logic Cannot Depend On

Forbidden:

```text
data/
ui/
```

---

### Wrong Examples

❌ Dependency on DTO

```dart
import '../../data/dtos/task_dto.dart';
```

❌ Dependency on repository implementation

```dart
import '../../data/repositories/task_repository_impl.dart';
```

❌ Dependency on page

```dart
import '../../ui/create/pages/task_create_page.dart';
```



## UI Layer Rules

- UI is the view seen by the user.
- UI should be as simple as possible.
- UI is responsible for:
  - View
  - Widget
  - Dialogs, bottom sheets, and other UI components
- UI must not access the data layer.
- UI must not access the logic layer.
- UI can access the domain only in the form of stable presentation models, such as entity, enum, or param.
- UI must not access repository contracts or domain use cases.

The App Layer is responsible for composing UI with Logic.

---

### UI Can Depend On

Allowed:

```text
domain/ (entity, enum, param only)
ui/
flutter/
app_ui/
```

---

### Correct Examples

✅ Dependency on domain models

```dart
import '../../domain/params/task_create_param.dart';
```

✅ Dependency on widget

```dart
import '../widgets/task_form.dart';
```

✅ Dependency on extension

```dart
import '../extensions/task_status_x.dart';
```

✅ Dependency on app_ui

```dart
import 'package:app_ui/app_ui.dart';
```

---

### UI Cannot Depend On

Forbidden:

```text
data/
logic/
```

---

### Wrong Examples

❌ Dependency on repository

```dart
import '../../domain/repositories/task_repository.dart';
```

❌ Dependency on use case

```dart
import '../../domain/usecases/task_create_use_case.dart';
```

❌ Dependency on cubit

```dart
import '../../logic/create/task_create_cubit.dart';
```



## App Layer Rules

The App Layer is the orchestrator.

The App Layer is responsible for:

- Routing
- Dependency Injection
- Navigation
- Module Composition
- Global State Composition

---

### App Can Depend On

Allowed:

```text
modules/
packages/
```

---

### Correct Examples

✅ Compose route

```dart
routes: [
  InboxRoute.base,
  TaskRoute.base,
]
```

✅ Compose DI

```dart
await inboxDI();
await taskDI();
```



## Cross Feature Rules

A feature may access another feature as long as both reside within the same module.

This is allowed because the module serves as the primary business boundary. In certain cases, there are operations that are difficult to isolate completely between features, but their business ownership remains clear at the module level.

However, cross-feature access must still be:

- As simple as possible
- As clear as possible
- Compliant with their respective layer dependencies
- Free of circular dependencies between features

Cross-feature access for modeling needs such as DTO, Entity, Param, Request, Response, enum, or other cascade references is normal. This is similar to reference or cascade requirements in databases, provided that the flow remains explicit and easy to trace.

If `featureC` requires an operation residing in `featureD`, for example `createTransaction` requires `createTransactionItems`, such access is permitted as long as the reason for interrelation is clear, the flow remains simple, and it does not create a circular dependence.

---

### Allowed

Within the same module, cross-feature access can be accomplished through the following patterns:

```text
modeling cascade
shared/
domain contract
```

Brief explanation:

- `modeling cascade` for DTO, Entity, Param, Request, Response, enum, or other naturally interrelated references
- `shared/` for module-scope or feature-scope resources that are indeed shared
- `domain contract` for entities, enums, params, or other stable contracts that are safe to use as shared references

`feature barrel` files may be used if they help discoverability, but within the same module, they are not strictly required as the sole form of import. Since they are still within the same Flutter package, direct imports to clear resources can sometimes be easier to read and less confusing for import suggestions. However, following a consistent import linting format remains recommended.

Being allowed does not mean every internal file can be freely accessed from anywhere. Always ensure the reason for access is clear, simple, and avoids forming circular dependencies.

---

### Wrong Example

❌ Circular dependence between features

```text
feature_c
  -> feature_d

feature_d
  -> feature_c
```

❌ Cross-feature access that violates layer dependencies

```dart
import '../feature_d/data/repositories/feature_d_repository_impl.dart';
```

❌ Cross-feature access that blurs flow ownership and makes tracing difficult

```text
feature_c calls many internal files of feature_d
without a clear boundary
```



## Cross Module Rules

A module must not access the internal files of another module.

---

### Allowed

Through the public barrel.

This rule applies to access between modules or between packages, not to access between features that remain within the same module.

Example:

```dart
import 'package:task/task.dart';
```

---

### Wrong Example

❌ Internal access

```dart
import 'package:task/src/features/task/...';
```



## Shared Rules

Shared resources follow their actual usage boundary.

---

### Feature Shared

Used by multiple slices within a single feature.

```text
feature/
 └── shared/
```

---

### Module Shared

Used by multiple features within a single module.

```text
module/
 └── shared/
```

---

### App Shared

Used across modules.

```text
app/
core/
packages/
```

Components do not need to be moved to a higher boundary simply because they are read by a higher boundary.

Ownership always follows its primary usage boundary.



## Golden Rule

Dependencies must always point toward more stable contracts.

Do not depend on implementations.

Depend on contract, not implementation.

The Domain is essentially a shared contract for things like entities, enums, and params.