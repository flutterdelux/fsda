# Naming Conventions

Dokumen ini mendefinisikan aturan penamaan (naming convention) pada FSDA.

Tujuan utama naming convention adalah:

* Menjaga konsistensi struktur proyek.
* Mempermudah navigasi kode.
* Mempermudah automation dan code generation.
* Membuat struktur dapat diprediksi.
* Mengurangi keputusan naming yang bersifat subjektif.


## General Rules


### File Naming

Gunakan:

```text
snake_case
```

Contoh:

```text
task_create_use_case.dart
wallet_delete_param.dart
product_detail_view.dart
inbox_mark_all_read_cubit.dart
```

&nbsp;

### Class Naming

Gunakan:

```text
PascalCase
```

Contoh:

```dart
TaskCreateUseCase
WalletDeleteParam
ProductDetailView
InboxMarkAllReadCubit
```

&nbsp;

### Method Naming

Gunakan:

```text
camelCase
```

Contoh:

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

&nbsp;

## Module Naming


Gunakan nama domain bisnis.

Format:

```text
<module>
```

Contoh:

```text
inbox
finance
task
product
location
travel
```

&nbsp;

## Feature Naming


Gunakan nama resource utama yang dimiliki module.

Format:

```text
<feature>
```

Contoh:

```text
inbox
wallet
task
product
city
destination
```

&nbsp;

## Slice Naming


Feature slice adalah unit terkecil implementasi bisnis.

&nbsp;

### Mutation Slice

Gunakan action atau verb.

Contoh:

```text
create
update
delete
reset
generate
mark_all_read
```

&nbsp;

### Retrieval Slice

Gunakan target data yang diretrieval.

Contoh:

```text
list
detail
status
recent
popular
mode
```

&nbsp;

## Shared Naming


Shared mengikuti ownership boundary.

Nama shared tetap menggunakan ownership feature atau domain asalnya.

Contoh:

```text
product_status_x.dart
ProductStatusX

payment_status.dart
PaymentStatus
```

Bukan:

```text
shared_status_x.dart
SharedStatusX
```

&nbsp;

## Failure Naming


### File

Format:

```text
<module>_failure.dart
```

&nbsp;

### Enum

Format:

```text
<Module>Failure
```

Contoh:

```dart
InboxFailure
FinanceFailure
TaskFailure
```

&nbsp;

### Enum Value

Format:

```text
<feature><slice><result>

atau

<feature><result>
```

Contoh:

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

Format:

```text
<module>_exception.dart
```

Contoh:

```text
inbox_exception.dart
finance_exception.dart
```

&nbsp;

### Class

Format:

```dart
<Module>Exception
```

Contoh:

```dart
InboxException
FinanceException
```

&nbsp;

### Factory

Format:

```text
<feature><slice><result>
```

Contoh:

```dart
InboxException.inboxMarkAllReadFailed()

FinanceException.walletDeleteFailed()

TaskException.taskCreateFailed()

ProductException.productDetailNotFound()
```

Jika tidak terikat pada slice dan hanya terikat pada feature, maka gunakan format:

```text
<feature><result>
```

contoh:

```dart
ProductException.productUnavailable()
ProductException.productNotFound()
```

&nbsp;

## Failure Extension Naming


### File

Format:

```text
<module>_failure_x.dart
```

&nbsp;

### Class

Format:

```dart
<Module>FailureX
```

Contoh:

```dart
InboxFailureX
FinanceFailureX
```

&nbsp;

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

Format:

```text
<feature>_feature.dart
```

&nbsp;

### Export Scope

Feature barrel hanya mengekspor resource publik milik feature tersebut.

&nbsp;

## Module Barrel Naming


### File

Format:

```text
<module>.dart
```

Contoh:

```text
inbox.dart
task.dart
finance.dart
```

Module barrel meneruskan export dari feature barrel yang ingin diekspos keluar module.

&nbsp;

## Enum Naming


### File

Format:

```text
<name>.dart
```

Contoh:

```text
payment_status.dart

theme_mode.dart

task_priority.dart
```

&nbsp;

### Enum

Format:

```dart
<Name>
```

Contoh:

```dart
PaymentStatus

ThemeMode

TaskPriority
```

Enum tidak menggunakan suffix:

```text
Enum
```

&nbsp;

## Entity Naming


### File

Format:

```text
<feature>_entity.dart
```

atau

```text
<feature>_<slice>_entity.dart
```

&nbsp;

### Class

Format:

```dart
<Feature>Entity
```

atau

```dart
<Feature><Slice>Entity
```

Contoh:

```dart
UserEntity

TaskEntity

ProductEntity
```

Entity wajib menggunakan suffix:

```text
Entity
```

untuk menghindari collision dengan package eksternal.

&nbsp;

## Param Naming


### Folder

Format:

```text
params/
```

### File

Format:

```text
<feature>_<slice>_param.dart
```

&nbsp;

### Class

Format:

```dart
<Feature><Slice>Param
```

Contoh:

```dart
TaskCreateParam

WalletDeleteParam

ProductDetailParam
```

Dipilih naming `Param` over `Params` (konvensi global) karena untuk menjaga konsistensi object modelling (Entity - Param - Dto - Request - Response) yang semuanya menggunakan bentuk singular.

&nbsp;

## Repository Naming


### Contract File

Format:

```text
<feature>_repository.dart
```

&nbsp;

### Contract Class

Format:

```dart
<Feature>Repository
```

&nbsp;

### Method

Gunakan nama bisnis yang natural. Namun tetap mengikuti contract dan konsistensi naming secara keseluruhan. Agar discoverability dan predictability tetap terjaga.

Contoh:

```dart
createTask()

deleteWallet()

markAllInboxRead()

getProductDetail()

getCityList()

watchPaymentStatus()
```

&nbsp;

## Use Case Naming


### File

Format:

```text
<feature>_<slice>_use_case.dart
```

Contoh:

```text
task_create_use_case.dart

wallet_delete_use_case.dart

product_detail_use_case.dart
```

&nbsp;

### Class

Format:

```dart
<Feature><Slice>UseCase
```

Contoh:

```dart
TaskCreateUseCase

WalletDeleteUseCase

ProductDetailUseCase
```

Use case menggunakan slice.

Bukan action tambahan.

&nbsp;

## Converter Naming


### File

Format:

```text
<feature>_converter.dart

atau

<feature>_<slice>_converter.dart
```

&nbsp;

### Class

Format:

```dart
<Feature>Converter

atau

<Feature><Slice>Converter
```

Contoh:

```dart
TaskConverter

DestinationPopularConverter
```

&nbsp;

## DTO Naming


### File

Format:

```text
<feature>_dto.dart

atau

<feature>_<slice>_dto.dart
```

Contoh:

```text
city_dto.dart

destination_popular_dto.dart
```

&nbsp;

### Class

Format:

```dart
<Feature>Dto

atau

<Feature><Slice>Dto
```

Contoh:

```dart
CityDto

DestinationPopularDto
```

&nbsp;

## Request Naming


### File

Format:

```text
<feature>_<slice>_request.dart
```

&nbsp;

### Class

Format:

```dart
<Feature><Slice>Request
```

Contoh:

```dart
WalletDeleteRequest

TaskCreateRequest
```

&nbsp;

## Response Naming


### File

Format:

```text
<feature>_<slice>_response.dart
```

&nbsp;

### Class

Format:

```dart
<Feature><Slice>Response
```

Contoh:

```dart
ProductDetailResponse

PaymentStatusResponse
```

&nbsp;

## Datasource Naming


### File

Format:

```text
<feature>_remote_data_source.dart

<feature>_remote_data_source_impl.dart

<feature>_local_data_source.dart

<feature>_local_data_source_impl.dart
```

&nbsp;

### Class

Format:

```dart
<Feature>RemoteDataSource

<Feature>RemoteDataSourceImpl

<Feature>LocalDataSource

<Feature>LocalDataSourceImpl
```

&nbsp;

### Method

Datasource method harus mengikuti repository contract yang digunakan oleh feature slice tersebut.

Contoh:

```dart
markAllInboxRead()

deleteWallet()

createTask()

getProductDetail()

getCityList()

watchPaymentStatus()
```

&nbsp;

## Repository Implementation Naming


### Implementation File

Format:

```text
<feature>_repository_impl.dart
```

&nbsp;

### Implementation Class

Format:

```dart
<Feature>RepositoryImpl
```

&nbsp;

## Logic Naming


### Slice Folder

Format:

```text
<slice>
```

Contoh:

```text
create
delete
detail
list
status
```

&nbsp;

### State File

Format:

```text
<feature>_<slice>_state.dart
```

&nbsp;

### State Class

Format:

```dart
<Feature><Slice>State
```

&nbsp;

### Cubit File

Format:

```text
<feature>_<slice>_cubit.dart
```

&nbsp;

### Cubit Class

Format:

```dart
<Feature><Slice>Cubit
```

&nbsp;

## UI Naming


### Slice Folder

Format:

```text
<slice>
```

&nbsp;

### View File

Format:

```text
<feature>_<slice>_view.dart
```

&nbsp;

### View Class

Format:

```dart
<Feature><Slice>View
```

Contoh:

```dart
TaskCreateView

ProductDetailView
```

UI menggunakan istilah:

```text
View
```

Bukan:

```text
Page
```

karena Page merupakan responsibility App Layer.

&nbsp;

### Widget File

Format:

```text
<feature>_<slice>_<widget>.dart
```

&nbsp;

### Widget Class

Format:

```dart
<Feature><Slice><Widget>
```

Contoh:

```dart
TaskCreateForm

InboxMarkAllReadPopupMenuItem

WalletDeleteDialog
```

&nbsp;

## Module Compose Naming


### DI

Format:

```text
<module>_di.dart
```

Contoh:

```text
inbox_di.dart

task_di.dart
```

&nbsp;

### Route

Format:

```text
<module>_route.dart
```

Contoh:

```text
inbox_route.dart

task_route.dart
```

&nbsp;

## App Compose Naming


App bertanggung jawab meng-compose UI dan Logic.

Page dapat merepresentasikan satu primary slice atau menjadi aggregate surface yang menggabungkan beberapa slice sekaligus.

Logic juga dapat diregistrasikan pada page scope atau scope yang lebih tinggi seperti root/global scope bila lifecycle dan kebutuhan composition mengharuskannya.

&nbsp;

### Page File

Default format untuk single-slice page:

```text
<feature>_<slice>_page.dart
```

Contoh:

```text
task_create_page.dart

product_detail_page.dart

inbox_mark_all_read_page.dart
```

Jika page menjadi aggregate surface, gunakan nama feature atau context yang paling representatif.

Contoh:

```text
product_page.dart
dashboard_page.dart
```

&nbsp;

### Page Class

Default format untuk single-slice page:

```dart
<Feature><Slice>Page
```

Contoh:

```dart
TaskCreatePage

ProductDetailPage

InboxMarkAllReadPage
```

Untuk aggregate page, gunakan nama surface yang paling representatif.

Contoh:

```dart
ProductPage
DashboardPage
```

Page bertugas meng-compose:

* View
* Logic
* Dependency Injection untuk lingkup UI & Logic
* Listener
* Provider
* Navigation untuk spesifik aksi route terkait
