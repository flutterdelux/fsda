# FSDA CLI Commands Reference

This document provides a comprehensive guide to using the `fsda` CLI tool to generate scaffolding for your Clean Architecture project, allowing you to rapidly build applications like `examples/fsda-base`.

## Table of Contents
1. [Initialization](#initialization)
2. [Packages & Infrastructure](#packages--infrastructure)
3. [Modules & Features](#modules--features)
4. [Slices (FSDA Core)](#slices-fsda-core)

---

## Initialization

### `fsda init <app_name>`
Generates the base application shell, including dependency injection setup, router setup, and base app config.

**Example:**
```bash
fsda init fsda_base
```

**Output:**
Creates a new directory `fsda_base` (or populates your current app folder based on the `app` template) containing:
- `main.dart` & `bootstrap.dart`
- Core DI files
- `router.dart`
- Base app configurations.

---

## Packages & Infrastructure

### `fsda add package <package_name>`
Adds predefined core packages to your workspace.

**Available Packages (based on standard FSDA architecture):**
- `app_core`
- `app_ui`
- `app_l10n`

**Example:**
```bash
fsda add package app_core
```

### `fsda add infra <infra_name>`
Adds infrastructure adapters (Data layer implementation tools).

**Available Infrastructure (based on `cli/fsda_cli/assets/generators/infra/`):**
- `connectivity`
- `dio`
- `flutter_secure_storage`
- `hive`
- `http`
- `sqflite`

**Example:**
```bash
fsda add infra dio
```

---

## Modules & Features

### `fsda generate module <module_name>`
Creates a new feature module container. In FSDA, modules act as independent packages or top-level boundaries containing multiple features.

**Example:**
```bash
fsda generate module auth
```

**Output:**
Generates the `auth` module directory with:
- Module barrel file (`auth_module.dart`)
- `routes.dart`
- `bindings.dart`

### `fsda generate feature <feature_name>`
Generates a standard Clean Architecture feature structure within your module.

**Example:**
```bash
fsda generate feature user
```

**Output:**
Generates a structured folder inside the current location:
- `data/` (datasources, models, repositories)
- `domain/` (entities, repositories, usecases)
- `presentation/` (pages, controllers, widgets)
- `user_feature.dart`

---

## Slices (FSDA Core)

Slices are the core of FSDA, representing distinct, vertical use cases (like retrieving data or mutating data). You can generate slices based on the 11 predefined blueprints in `specs/v1/blueprints/`.

### `fsda generate slice <slice_type> <slice_name>`

**Available Slice Types (from Blueprints):**

| Slice Type | Description |
|---|---|
| `mutation` | Basic mutation (e.g., Delete without params, logout). |
| `mutation-param` | Mutation requiring parameters (e.g., Update profile). |
| `mutation-return` | Mutation returning data (e.g., Create returning ID). |
| `mutation-return-param`| Mutation with params returning data. |
| `retrieval` | Basic data retrieval without params. |
| `retrieval-cache` | Retrieval with caching strategy. |
| `retrieval-local-first`| Retrieval prioritizing local database first. |
| `retrieval-pagination` | Retrieval with pagination logic. |
| `retrieval-param` | Retrieval requiring parameters (e.g., Get user by ID). |
| `retrieval-stream` | Real-time stream retrieval. |
| `retrieval-stream-param`| Real-time stream retrieval with parameters. |

**Example:**
To generate a "get user by id" feature slice:
```bash
fsda generate slice retrieval-param user
```

**Output:**
The CLI will generate the corresponding slice structure based on the `retrieval-param` blueprint:
- Domain layer (Entity, Repository Interface, UseCase)
- Data layer (Model, Datasource Interface & Impl, Repository Impl)
- Presentation layer (State, Controller, View)

---

## Workflow Example: Building `fsda-base`

To build an example project using these commands:

1. **Initialize the app:**
   ```bash
   mkdir fsda_base && cd fsda_base
   fsda init fsda_base
   ```

2. **Add core packages:**
   ```bash
   fsda add package app_core
   fsda add package app_ui
   ```

3. **Add necessary infrastructure:**
   ```bash
   fsda add infra dio
   fsda add infra hive
   ```

4. **Create a module:**
   ```bash
   fsda generate module auth
   cd auth
   ```

5. **Generate slices inside the module/feature:**
   ```bash
   fsda generate slice mutation-param login
   fsda generate slice retrieval-param profile
   ```

You can repeat this process, adding blueprints into `cli/fsda_cli/assets/generators/` and running the CLI to instantly scaffold clean architecture layers.