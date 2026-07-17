# Naming Conventions

This document defines the naming conventions used in FSDA.

The primary goals of these conventions are:

- Maintain a consistent project structure.
- Improve code navigation.
- Simplify automation and code generation.
- Make the project structure predictable.
- Reduce subjective naming decisions.

---

# General Rules

## File Naming

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

---

## Class Naming

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

---

## Method Naming

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

getPopularDestination()
getRecentNote()
```

---

# Module Naming

Use the business domain name.

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

---

# Feature Naming

Use the primary resource owned by the module.

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

---

# Slice Naming

A feature slice is the smallest unit of business implementation.

## Mutation Slice

Use an action (verb).

Examples:

```text
create
update
delete
reset
generate
mark_all_read
```

---

## Retrieval Slice

Use the target data being retrieved.

Examples:

```text
list
detail
status
recent
popular
mode
```

---

# Shared Naming

Shared components follow the ownership boundary.

Their names should retain the originating feature or domain.

Examples:

```text
product_status_x.dart
ProductStatusX

payment_status.dart
PaymentStatus
```

Not:

```text
shared_status_x.dart
SharedStatusX
```

---

# Failure Naming

## File

Format:

```text
<module>_failure.dart
```

---

## Enum

Format:

```text
<Module>Failure
```

Examples:

```dart
InboxFailure
FinanceFailure
TaskFailure
```

---

## Enum Value

Format:

```text
<feature><slice><result>

or

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

---

# Exception Naming

## File

Format:

```text
<module>_exception.dart
```

Examples:

```text
inbox_exception.dart
finance_exception.dart
```

---

## Class

Format:

```dart
<Module>Exception
```

Examples:

```dart
InboxException
FinanceException
```

---

## Factory

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

If the exception is not associated with a slice but only with a feature, use:

```text
<feature><result>
```

Examples:

```dart
ProductException.productUnavailable()
ProductException.productNotFound()
```

---

# Failure Extension Naming

## File

Format:

```text
<module>_failure_x.dart
```

---

## Class

Format:

```dart
<Module>FailureX
```

Examples:

```dart
InboxFailureX
FinanceFailureX
```

---

## Localization Key

Format:

```text
failure<Feature><Slice><Result>

or

failure<Feature><Result>
```

Examples:

```text
failureWalletDeleteFailed

failureTaskCreateFailed

failureInboxMarkAllReadFailed

failureDestinationNotFound
```

---

# Feature Barrel Naming

## File

Format:

```text
<feature>_feature.dart
```

---

## Export Scope

A feature barrel should only export the public resources owned by that feature.

---

# Module Barrel Naming

## File

Format:

```text
<module>.dart
```

Examples:

```text
inbox.dart
task.dart
finance.dart
```

A module barrel re-exports the feature barrels that should be exposed outside the module.

---

# Enum Naming

## File

Format:

```text
<name>.dart
```

Examples:

```text
payment_status.dart

theme_mode.dart

task_priority.dart
```

---

## Enum

Format:

```dart
<Name>
```

Examples:

```dart
PaymentStatus

ThemeMode

TaskPriority
```

Enums should **not** use the suffix:

```text
Enum
```

---

# Entity Naming

## File

Format:

```text
<feature>_entity.dart
```

or

```text
<feature>_<slice>_entity.dart
```

---

## Class

Format:

```dart
<Feature>Entity
```

or

```dart
<Feature><Slice>Entity
```

Examples:

```dart
UserEntity

TaskEntity

ProductEntity
```

Entities must use the `Entity` suffix to avoid naming collisions with external packages.

---

# Param Naming

## Folder

Format:

```text
params/
```

---

## File

Format:

```text
<feature>_<slice>_param.dart
```

---

## Class

Format:

```dart
<Feature><Slice>Param
```

Examples:

```dart
TaskCreateParam

WalletDeleteParam

ProductDetailParam
```

`Param` is preferred over `Params` to maintain consistency with the object model:

```
Entity → Param → Dto → Request → Response
```

where every type uses the singular form.

---

# Repository Naming

## Contract File

Format:

```text
<feature>_repository.dart
```

---

## Contract Class

Format:

```dart
<Feature>Repository
```

---

## Method

Use natural business-oriented names while keeping them consistent across repository contracts.

Examples:

```dart
createTask()

deleteWallet()

markAllInboxRead()

getProductDetail()

getCityList()

watchPaymentStatus()
```

---

# Use Case Naming

## File

Format:

```text
<feature>_<slice>_use_case.dart
```

Examples:

```text
task_create_use_case.dart

wallet_delete_use_case.dart

product_detail_use_case.dart
```

---

## Class

Format:

```dart
<Feature><Slice>UseCase
```

Examples:

```dart
TaskCreateUseCase

WalletDeleteUseCase

ProductDetailUseCase
```

Use cases are named after slices, not additional actions.

---

# Converter Naming

## File

Format:

```text
<feature>_converter.dart
```

or

```text
<feature>_<slice>_converter.dart
```

---

## Class

Format:

```dart
<Feature>Converter
```

or

```dart
<Feature><Slice>Converter
```

Examples:

```dart
TaskConverter

DestinationPopularConverter
```

---

# DTO Naming

## File

Format:

```text
<feature>_dto.dart
```

or

```text
<feature>_<slice>_dto.dart
```

Examples:

```text
city_dto.dart

destination_popular_dto.dart
```

---

## Class

Format:

```dart
<Feature>Dto
```

or

```dart
<Feature><Slice>Dto
```

Examples:

```dart
CityDto

DestinationPopularDto
```

---

# Request Naming

## File

Format:

```text
<feature>_<slice>_request.dart
```

---

## Class

Format:

```dart
<Feature><Slice>Request
```

Examples:

```dart
WalletDeleteRequest

TaskCreateRequest
```

---

# Response Naming

## File

Format:

```text
<feature>_<slice>_response.dart
```

---

## Class

Format:

```dart
<Feature><Slice>Response
```

Examples:

```dart
ProductDetailResponse

PaymentStatusResponse
```

---

# Datasource Naming

## File

Format:

```text
<feature>_remote_data_source.dart

<feature>_remote_data_source_impl.dart

<feature>_local_data_source.dart

<feature>_local_data_source_impl.dart
```

---

## Class

Format:

```dart
<Feature>RemoteDataSource

<Feature>RemoteDataSourceImpl

<Feature>LocalDataSource

<Feature>LocalDataSourceImpl
```

---

## Method

Datasource methods should follow the repository contract for the corresponding feature slice.

Examples:

```dart
markAllInboxRead()

deleteWallet()

createTask()

getProductDetail()

getCityList()

watchPaymentStatus()
```

---

# Repository Implementation Naming

## Implementation File

Format:

```text
<feature>_repository_impl.dart
```

---

## Implementation Class

Format:

```dart
<Feature>RepositoryImpl
```

---

# Logic Naming

## Slice Folder

Format:

```text
<slice>
```

Examples:

```text
create
delete
detail
list
status
```

---

## State File

Format:

```text
<feature>_<slice>_state.dart
```

---

## State Class

Format:

```dart
<Feature><Slice>State
```

---

## Cubit File

Format:

```text
<feature>_<slice>_cubit.dart
```

---

## Cubit Class

Format:

```dart
<Feature><Slice>Cubit
```

---

# UI Naming

## Slice Folder

Format:

```text
<slice>
```

---

## View File

Format:

```text
<feature>_<slice>_view.dart
```

---

## View Class

Format:

```dart
<Feature><Slice>View
```

Examples:

```dart
TaskCreateView

ProductDetailView
```

Use the term:

```text
View
```

instead of:

```text
Page
```

because `Page` belongs to the App Layer responsibility.

---

## Widget File

Format:

```text
<feature>_<slice>_<widget>.dart
```

---

## Widget Class

Format:

```dart
<Feature><Slice><Widget>
```

Examples:

```dart
TaskCreateForm

InboxMarkAllReadPopupMenuItem

WalletDeleteDialog
```

---

# Module Compose Naming

## DI

Format:

```text
<module>_di.dart
```

Examples:

```text
inbox_di.dart

task_di.dart
```

---

## Route

Format:

```text
<module>_route.dart
```

Examples:

```text
inbox_route.dart

task_route.dart
```

---

# App Compose Naming

The application layer is responsible for composing UI and Logic.

A page may represent a single primary slice or serve as an aggregate surface that combines multiple slices.

Logic may also be registered at the page scope or a higher scope (such as the root/global scope) when required by lifecycle or composition needs.

---

## Page File

Default format for a single-slice page:

```text
<feature>_<slice>_page.dart
```

Examples:

```text
task_create_page.dart

product_detail_page.dart

inbox_mark_all_read_page.dart
```

If the page represents an aggregate surface, use the most representative feature or context name.

Examples:

```text
product_page.dart
dashboard_page.dart
```

---

## Page Class

Default format for a single-slice page:

```dart
<Feature><Slice>Page
```

Examples:

```dart
TaskCreatePage

ProductDetailPage

InboxMarkAllReadPage
```

For aggregate pages, use the most representative surface name.

Examples:

```dart
ProductPage
DashboardPage
```

A page is responsible for composing:

- View
- Logic
- Dependency Injection for the UI and Logic scope
- Listeners
- Providers
- Navigation for route-specific actions