# Naming Conventions

This document defines naming conventions for FSDA.

Primary goals:

* keep project structure consistent
* improve code navigation
* support automation and code generation
* make structure predictable
* reduce subjective naming decisions


## General Rules

### File Naming

Use:

```text
snake_case
```

Examples:

```text
task_create_use_case.dart
wallet_delete_param.dart
product_detail_view.dart
inbox_mark_all_read_cubit.dart
```

### Class Naming

Use:

```text
PascalCase
```

Examples:

```dart
TaskCreateUseCase
WalletDeleteParam
ProductDetailView
InboxMarkAllReadCubit
```

### Method Naming

Use:

```text
camelCase
```

Examples:

```dart
createTask()
deleteWallet()
markAllInboxRead()
getProductDetail()
getCityList()
watchPaymentStatus()
```

&nbsp;

## Module Naming

Use business-domain names.

Format:

```text
<module>
```

Examples:

```text
inbox
finance
task
product
location
travel
```

## Feature Naming

Use primary resource names owned by the module.

Format:

```text
<feature>
```

Examples:

```text
inbox
wallet
task
product
city
destination
```

## Slice Naming

Feature slice is the smallest business implementation unit.

### Mutation Slice

Use action/verb.

Examples:

```text
create
update
delete
reset
generate
mark_all_read
```

### Retrieval Slice

Use retrieved target/data intent.

Examples:

```text
list
detail
status
recent
popular
mode
```

## Shared Naming

Shared naming should follow ownership boundary.

Examples:

```text
product_status_x.dart
ProductStatusX

payment_status.dart
PaymentStatus
```

Avoid generic/unowned names such as:

```text
shared_status_x.dart
SharedStatusX
```

&nbsp;

## Failure Naming

### File

```text
<module>_failure.dart
```

### Enum

```text
<Module>Failure
```

Examples:

```dart
InboxFailure
FinanceFailure
TaskFailure
```

### Enum Value

Format:

```text
<feature><slice><result>
```

or

```text
<feature><result>
```

Examples:

```dart
walletDeleteFailed
taskCreateFailed
inboxMarkAllReadFailed
productDetailNotFound
paymentStatusUnavailable
noteNotFound
```

&nbsp;

## Exception Naming

### File

```text
<module>_exception.dart
```

Examples:

```text
inbox_exception.dart
finance_exception.dart
```

### Class

```text
<Module>Exception
```

Examples:

```dart
InboxException
FinanceException
```

### Factory

Format:

```text
<feature><slice><result>
```

Examples:

```dart
InboxException.inboxMarkAllReadFailed()
FinanceException.walletDeleteFailed()
TaskException.taskCreateFailed()
ProductException.productDetailNotFound()
```

If not tied to a slice and only feature-level, use:

```text
<feature><result>
```

Example:

```dart
PaymentException.paymentNotFound()
```

&nbsp;

## Failure Extension Naming

### File

```text
<module>_failure_x.dart
```

### Class

```text
<Module>FailureX
```

### Localization Key

Format:

```text
failure<Feature><Slice><Result>

atau

failure<Feature><Result>
```

Contoh:

```text
failureWalletDeleteFailed

failureTaskCreateFailed

failureInboxMarkAllReadFailed

failureDestinationNotFound
```

&nbsp;

## Feature Barrel Naming

### File

```text
<feature>_feature.dart
```

### Export Scope

Feature barrel should export only resources that are intentionally public for that feature boundary.

&nbsp;

## Module Barrel Naming

### File

```text
<module>.dart
```

Module barrel should expose module-level public surface only.

&nbsp;

## Enum Naming

### File

```text
<feature>_<concept>.dart
```

or

```text
<concept>.dart
```

when context is already clear.

### Enum

Use concise domain terms in PascalCase.

Examples:

```dart
PaymentStatus
AttendanceType
ThemeModeType
```

&nbsp;

## Entity Naming

### File

```text
<feature>_entity.dart
```

### Class

```text
<Feature>Entity
```

Examples:

```dart
ProductEntity
WalletEntity
TaskEntity
```

&nbsp;

## Param Naming

### Folder

```text
params/
```

### File

```text
<feature>_<slice>_param.dart
```

### Class

```text
<Feature><Slice>Param
```

Examples:

```dart
WalletDeleteParam
TaskCreateParam
ProductDetailParam
```

&nbsp;

## Repository Naming

### Contract File

```text
<feature>_repository.dart
```

### Contract Class

```text
<Feature>Repository
```

### Method

Use clear business operation names.

Examples:

```dart
deleteWallet(ProductDeleteParam param)
createTask(TaskCreateParam param)
getProductDetail(ProductDetailParam param)
```

&nbsp;

## Use Case Naming

### File

```text
<feature>_<slice>_use_case.dart
```

### Class

```text
<Feature><Slice>UseCase
```

Examples:

```dart
WalletDeleteUseCase
TaskCreateUseCase
ProductDetailUseCase
```

&nbsp;

## Converter Naming

### File

```text
<feature>_<concept>_converter.dart
```

### Class

```text
<Feature><Concept>Converter
```

Examples:

```dart
PaymentStatusConverter
AttendanceTypeConverter
```

&nbsp;

## DTO Naming

### File

```text
<feature>_dto.dart
```

or for specialized shape:

```text
<feature>_<slice>_dto.dart
```

### Class

```text
<Feature>Dto
```

or

```text
<Feature><Slice>Dto
```

&nbsp;

## Request Naming

### File

```text
<feature>_<slice>_request.dart
```

### Class

```text
<Feature><Slice>Request
```

&nbsp;

## Response Naming

### File

```text
<feature>_<slice>_response.dart
```

### Class

```text
<Feature><Slice>Response
```

&nbsp;

## Datasource Naming

### File

```text
<feature>_remote_data_source.dart
<feature>_remote_data_source_impl.dart
```

Optional local variant:

```text
<feature>_local_data_source.dart
<feature>_local_data_source_impl.dart
```

### Class

```text
<Feature>RemoteDataSource
<Feature>RemoteDataSourceImpl
```

(or Local equivalents)

### Method

Use operation names aligned with repository/use-case intent.

&nbsp;

## Repository Implementation Naming

### Implementation File

```text
<feature>_repository_impl.dart
```

### Implementation Class

```text
<Feature>RepositoryImpl
```

&nbsp;

## Logic Naming

### Slice Folder

```text
logic/<slice>/
```

### State File

```text
<feature>_<slice>_state.dart
```

### State Class

```text
<Feature><Slice>State
```

### Cubit File

```text
<feature>_<slice>_cubit.dart
```

### Cubit Class

```text
<Feature><Slice>Cubit
```

&nbsp;

## UI Naming

### Slice Folder

```text
ui/<slice>/
```

### View File

```text
<feature>_<slice>_view.dart
```

### View Class

```text
<Feature><Slice>View
```

### Widget File

Use clear intent-based names.

Examples:

```text
<feature>_<slice>_content.dart
<feature>_<slice>_error.dart
<feature>_<slice>_skeleton.dart
```

### Widget Class

Use PascalCase aligned with widget file intent.

&nbsp;

## Module Compose Naming

### DI

```text
<module>_di.dart
```

Use consistent DI function names, for example:

```dart
Future<void> <module>DI() async {}
```

### Route

```text
<module>_route.dart
```

Use a route class such as:

```dart
class <Module>Route {}
```

&nbsp;

## App Compose Naming

App-level composition pages are placed in app module boundary.

### Page File

```text
<feature>_<slice>_page.dart
```

or explicit aggregate pages when needed.

### Page Class

```text
<Feature><Slice>Page
```

Use aggregate naming when one page composes multiple slices.
