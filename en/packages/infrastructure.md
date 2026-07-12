# Infrastructure Packages

Infrastructure packages are collections of technical implementations for contracts defined in `app_core`.

FSDA separates contract and implementation so business layers do not depend on frameworks or specific libraries.

&nbsp;

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

Example:

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

Business code knows only contracts in `app_core`. Implementation choice is handled through Dependency Injection.

&nbsp;

## Purpose

Infrastructure packages are responsible for:

* implementing contracts from `app_core`
* isolating dependencies on specific libraries/SDKs
* acting as adapters between business layers and external technology
* providing reusable implementations for many apps and modules

Infrastructure packages are not a place for business logic.

&nbsp;

## Design Principles

Each `infra_*` package should have one clear responsibility.

For example:

* one HTTP client
* one local storage
* one secure storage
* one database client
* one logger

Small boundaries make packages easier to maintain, test, replace, and evolve independently.

&nbsp;

## Multiple Implementations

One contract can have multiple implementations.

Example:

```text
ApiClient
├── infra_dio
└── infra_http
```

Both packages implement `ApiClient`, but use different technology.

Application only decides which implementation to register in Dependency Injection.

&nbsp;

## Dependency Direction

Dependency always points inward.

```text
Feature
    │
    ▼
app_core
    ▲
    │
infra_*
```

Meaning:

* Feature depends on `app_core`
* Infrastructure depends on `app_core`
* `app_core` does not know infrastructure packages

With this rule, contracts remain stable even if technology implementation changes.

&nbsp;

## Package Naming

All infrastructure packages use this format:

```text
infra_<technology>
```

Examples:

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

Package names explicitly reflect underlying technology.

&nbsp;

## Dependency Injection

Infrastructure packages do not self-register dependencies.

Registration is done in app through `external_di.dart` for technology dependencies, and through `core_di.dart` for contract implementation bindings.

Example:

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

With this approach, app can switch implementation without changing business layer.

&nbsp;

## When to Create a New Infrastructure Package

Create a new `infra_*` package when:

* there is an `app_core` contract that needs specific technology implementation
* you want to provide an alternative implementation for an existing contract
* the implementation can be reused by more than one application
