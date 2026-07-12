# Infrastructure Packages

Infrastructure packages adalah kumpulan implementasi teknis dari contract yang didefinisikan di `app_core`.

FSDA memisahkan contract dan implementation agar business layer tidak bergantung pada framework maupun library tertentu.

 

## Architecture

```text
Feature
    │
    ▼
app_core (contracts)
    │
    ▼
infra_* (implementations)
    │
    ▼
Technology
```

Contoh:

```text
ApiClient
        │
        ├── infra_dio
        └── infra_http
```

```text
LocalStorage
        │
        ├── infra_hive
        └── infra_shared_preferences
```

```text
SecureLocalStorage
        │
        └── infra_flutter_secure_storage
```

Seluruh business code hanya mengenal contract pada `app_core`. Pemilihan implementasi dilakukan melalui Dependency Injection.

 

## Purpose

Infrastructure package bertanggung jawab untuk:

* mengimplementasikan contract dari `app_core`
* mengisolasi dependency terhadap library atau SDK tertentu
* menjadi adapter antara business layer dan teknologi eksternal
* menyediakan implementasi yang dapat digunakan kembali oleh banyak App maupun Module

Infrastructure package bukan tempat untuk business logic.

 

## Design Principles

Setiap package `infra_*` sebaiknya memiliki satu responsibility yang jelas.

Misalnya:

* satu HTTP client
* satu local storage
* satu secure storage
* satu database client
* satu logger

Dengan boundary yang kecil, package menjadi lebih mudah dipelihara, diuji, diganti, maupun dikembangkan secara independen.

 

## Multiple Implementations

Satu contract dapat memiliki lebih dari satu implementasi.

Contoh:

```text
ApiClient
├── infra_dio
└── infra_http
```

Kedua package sama-sama mengimplementasikan `ApiClient`, tetapi menggunakan teknologi yang berbeda.

Aplikasi cukup memilih implementasi mana yang akan didaftarkan pada Dependency Injection.

 

## Dependency Direction

Dependency selalu mengarah ke dalam.

```text
Feature
    │
    ▼
app_core
    ▲
    │
infra_*
```

Artinya:

* Feature bergantung pada `app_core`
* Infrastructure bergantung pada `app_core`
* `app_core` tidak mengetahui adanya package infrastructure

Dengan aturan ini, contract tetap stabil walaupun implementasi teknologi berubah.

 

## Package Naming

Seluruh infrastructure package menggunakan format:

```text
infra_<technology>
```

Contoh:

```text
infra_dio
infra_http
infra_logging
infra_sqflite
infra_hive
infra_shared_preferences
infra_flutter_secure_storage
infra_connectivity_plus
```

Nama package mencerminkan teknologi yang digunakan sehingga mudah dikenali.

 

## Dependency Injection

Infrastructure package tidak melakukan registrasi dependency sendiri.

Registrasi dilakukan pada aplikasi melalui `external_di.dart` untuk teknologi nya, sedangkan implementasi dilakukan melalui `core_di.dart`.

Contoh:

external_di.dart:
```dart
sl.registerLazySingleton<Dio>(() => Dio());
```

core_di.dart:
```dart
sl.registerLazySingleton<ApiClient>(
  () => DioApiClient(
    dio: sl(),
    baseUrl: env.baseUrl,
  ),
);
```

Dengan pendekatan ini, aplikasi bebas memilih implementasi yang ingin digunakan tanpa mengubah business layer.

 

## When to Create a New Infrastructure Package

Buat package `infra_*` baru apabila:

* ada contract pada app_core yang memerlukan implementasi teknologi tertentu
* ingin menyediakan alternatif implementasi untuk contract yang sudah ada
* implementasi tersebut dapat digunakan kembali oleh lebih dari satu aplikasi

