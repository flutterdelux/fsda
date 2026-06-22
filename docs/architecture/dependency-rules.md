# Dependency Rules

Dokumen ini mendefinisikan aturan dependency pada FSDA.

Tujuan utama dependency rules adalah:

- Menjaga arah dependency tetap konsisten.
- Mencegah coupling antar layer.
- Memastikan feature tetap mudah dipindahkan.
- Memastikan automation dapat dilakukan secara deterministik.
- Menjaga scalability jangka panjang.

&nbsp;

## Dependency Direction

Dependency selalu mengarah ke dalam (inward).

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```

Domain tidak mengetahui layer lain.

Domain adalah pusat kontrak aplikasi.

&nbsp;

## Layer Dependency Matrix

| Layer  | Boleh Depend Ke |
| ------ | --------------- |
| Domain | Domain          |
| Data   | Domain, Data    |
| Logic  | Domain, Logic   |
| UI     | Domain, UI      |

&nbsp;

## Domain Layer Rules

Domain adalah lapisan paling stabil.

Domain mendefinisikan:

- Entity
- Repository Contract
- Use Case
- Param
- Failure
- Enum bisnis

Domain tidak boleh mengetahui implementasi.

&nbsp;

### Domain Can Depend On

Allowed:

```text
domain/
```

Contoh:

```dart
import '../entities/task.dart';
import '../repositories/task_repository.dart';
```

&nbsp;

### Domain Cannot Depend On

Forbidden:

```text
data/
logic/
ui/
flutter/
```

Contoh salah:

```dart
import '../../data/dtos/task_dto.dart';
```

```dart
import '../../logic/create/task_create_cubit.dart';
```

```dart
import 'package:flutter/material.dart';
```

&nbsp;

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

&nbsp;

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

&nbsp;

## Data Layer Rules

Data adalah implementasi dari kontrak domain.

Data bertanggung jawab terhadap:

- API
- Database
- Cache
- DTO
- Request
- Response
- Converter
- Repository Implementation

&nbsp;

### Data Can Depend On

Allowed:

```text
domain/
data/
```

Contoh:

```dart
import '../../domain/entities/task.dart';
import '../dtos/task_dto.dart';
```

&nbsp;

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

&nbsp;

### Data Cannot Depend On

Forbidden:

```text
logic/
ui/
```

&nbsp;

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

&nbsp;

## Logic Layer Rules

Logic mengorkestrasi use case.

Logic bertanggung jawab terhadap:

- State
- Cubit
- Bloc
- Provider
- Controller
- State management lainnya

Logic tidak boleh mengetahui implementasi data.

&nbsp;

### Logic Can Depend On

Allowed:

```text
domain/
logic/
```

Contoh:

```dart
import '../../domain/usecases/task_create_use_case.dart';
```

&nbsp;

### Correct Examples

✅ Dependency on use case

```dart
import '../../domain/usecases/task_create_use_case.dart';
```

✅ Dependency on params

```dart
import '../../domain/params/task_create_param.dart';
```

✅ Dependency on another logic file in same slice

```dart
import 'task_create_state.dart';
```

&nbsp;

### Logic Cannot Depend On

Forbidden:

```text
data/
ui/
```

&nbsp;

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

&nbsp;

## UI Layer Rules

* UI adalah tampilan yang dilihat user.
* UI harus sesederhana mungkin.
* UI bertanggung jawab terhadap:

    - View
    - Widget 
    - Dialog, bottom sheet, dan ui component lainnya

* UI tidak boleh mengakses data layer.
* UI tidak boleh mengakses logic layer.
* UI dapat mengakses domain hanya dalam bentuk model presentasi yang stabil, seperti entity, enum, atau param.
* UI tidak boleh mengakses repository contract atau use case domain.

App Layer bertugas meng-compose UI dengan Logic.

&nbsp;

### UI Can Depend On

Allowed:

```text
domain/ (entity, enum, param only)
ui/
flutter/
app_ui/
```

&nbsp;

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

&nbsp;

### UI Cannot Depend On

Forbidden:

```text
data/
logic/
```

&nbsp;

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

&nbsp;

## App Layer Rules

App Layer adalah orchestrator.

App Layer bertanggung jawab terhadap:

- Routing
- Dependency Injection
- Navigation
- Module Composition
- Global State Composition

&nbsp;

### App Can Depend On

Allowed:

```text
modules/
packages/
```

&nbsp;

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

&nbsp;

## Cross Feature Rules

Feature boleh mengakses feature lain selama masih berada di dalam module yang sama.

Hal ini dimungkinkan karena module adalah business boundary utama. Dalam kasus tertentu, ada operasi yang sulit dipisahkan sepenuhnya antar feature, tetapi masih jelas ownership bisnisnya di level module.

Meski begitu, akses lintas feature harus tetap:

- sesederhana mungkin
- sejelas mungkin
- tetap mengikuti layer dependency masing-masing
- tidak membentuk circular dependence antar feature

Akses lintas feature untuk kebutuhan modeling seperti DTO, Entity, Param, Request, Response, enum, atau referensi lain yang bersifat cascade adalah hal yang normal. Ini mirip dengan kebutuhan reference atau cascade pada database, selama alurnya tetap eksplisit dan mudah ditelusuri.

Jika `featureC` membutuhkan operasi yang berada di `featureD`, misalnya `createTransaction` membutuhkan `createTransactionItems`, maka akses tersebut diperbolehkan selama alasan keterkaitannya jelas, flow-nya tetap sederhana, dan tidak menciptakan circular dependence.

&nbsp;

### Allowed

Di dalam module yang sama, akses lintas feature dapat dilakukan melalui pola berikut:

```text
modeling cascade
shared/
domain contract
```

Penjelasan singkat:

- `modeling cascade` untuk DTO, Entity, Param, Request, Response, enum, atau reference lain yang saling terkait secara natural
- `shared/` untuk resource module-scope atau feature-scope yang memang dimiliki bersama
- `domain contract` untuk entity, enum, param, atau contract stabil lain yang aman dijadikan acuan bersama

`feature barrel` boleh digunakan bila membantu discoverability, tetapi di dalam module yang sama tidak wajib dijadikan satu-satunya bentuk import. Karena masih berada di dalam satu Flutter package yang sama, terkadang direct import ke resource yang jelas justru lebih mudah dibaca dan tidak membingungkan suggestion import. Namun mengikuti bentuk import linting yang konsisten tetap lebih disarankan.

Allowed bukan berarti semua file internal bebas diakses dari mana saja. Tetap jaga agar alasan aksesnya jelas, sederhana, dan tidak sampai membentuk circular dependence.

&nbsp;

### Wrong Example

❌ Circular dependence antar feature

```text
feature_c
  -> feature_d

feature_d
  -> feature_c
```

❌ Akses lintas feature yang melanggar layer dependency

```dart
import '../feature_d/data/repositories/feature_d_repository_impl.dart';
```

❌ Akses lintas feature yang membuat flow ownership menjadi kabur dan sulit ditelusuri

```text
feature_c memanggil banyak file internal feature_d
tanpa boundary yang jelas
```

&nbsp;

## Cross Module Rules

Module tidak boleh mengakses internal module lain.

&nbsp;

### Allowed

Melalui public barrel.

Aturan ini berlaku untuk akses antar module atau antar package, bukan untuk akses antar feature yang masih berada di dalam module yang sama.

Contoh:

```dart
import 'package:task/task.dart';
```

&nbsp;

### Wrong Example

❌ Internal access

```dart
import 'package:task/src/features/task/...';
```

&nbsp;

## Shared Rules

Shared mengikuti boundary penggunaan aktual.

&nbsp;

### Feature Shared

Digunakan oleh beberapa slice dalam satu feature.

```text
feature/
 └── shared/
```

&nbsp;

### Module Shared

Digunakan oleh beberapa feature dalam satu module.

```text
module/
 └── shared/
```

&nbsp;

### App Shared

Digunakan lintas module.

```text
app/
core/
packages/
```

&nbsp;

Komponen tidak harus dipindahkan ke boundary yang lebih tinggi hanya karena dibaca oleh boundary yang lebih tinggi.

Ownership tetap mengikuti boundary penggunaan utamanya.

&nbsp;

## Golden Rule

Dependency harus selalu mengarah ke kontrak yang lebih stabil.

Jangan bergantung pada implementasi.

Depend on contract, not implementation.

Domain pada dasarnya adalah shared contract untuk hal hal seperti entity, enum, dan param.