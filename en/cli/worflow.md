# FSDA CLI Workflow

This workflow follows the active CLI command surface, from workspace initialization to repeatable development cycles.

For a ready-to-run E2E scenario (workspace -> app run), use:
- [Day-Look E2E](../../cli/daylook_e2e.md)

Document goals:
- clear for new developers
- detailed enough for solo and team use
- aligned with real project flow

## Core Rule

Run all commands from the workspace root that contains fsda.yaml, except create.

Example:

```bash
# run outside workspace
fsda create fsda-base

# move into workspace root
cd fsda-base
```

## 1) Create Workspace

Start by creating an empty FSDA workspace.

```bash
fsda create fsda-base
cd fsda-base
```

Minimal initial structure:

```text
fsda-base/
├── apps/
├── modules/
├── packages/
└── fsda.yaml
```

## 2) Check and Edit fsda.yaml for Initial Setup

After workspace creation, inspect fsda.yaml first. This file is the source of truth for baseline packages.

Common initial content:

```yaml
packages:
  - app_core
  - app_l10n
  - app_ui
  - infra_http
  - infra_logging
```

Notes:
- package list defines what fsda configure prepares
- if you change infra stack, edit this file first

## 3) Check Available Package and Infra Templates

Before finalizing fsda.yaml, inspect available templates.

```bash
fsda list-pckg
```

Tip to inspect infra templates only:

```bash
fsda list-pckg | grep infra_
```

Use this list to validate package names in fsda.yaml.

## 4) Configure Workspace from fsda.yaml

Run initial package synchronization.

```bash
fsda configure
```

Expected outcome:
- packages folder contains active packages from fsda.yaml
- removed packages are reconciled by configure behavior

Example output:

```text
packages/
├── app_core/
├── app_l10n/
├── app_ui/
├── infra_http/
└── infra_logging/
```

## 5) Generate App and Initial App Setup

Generate target app.

```bash
fsda gen-app ruviti
```

Then run initial app setup based on app docs and generation logs.

```bash
cd apps/ruviti
flutter pub get

# if required by app template
dart run package_rename
dart run flutter_launcher_icons

flutter run
```

Return to workspace root, then sync app dependencies with active workspace packages:

```bash
cd ../..
fsda configure-app ruviti
```

Use fsda configure-app whenever package changes affect app dependencies or app DI.

## 6) Generate Module (Start Modular Development)

```bash
fsda gen-module finance
```

This step prepares:
- module boundary
- shared errors, extensions, and feature wrapper

## 7) Generate Feature

```bash
fsda gen-feature wallet -m finance --ds both
```

This prepares feature folder structure and initial feature barrel files.

Notes:
- default datasource mode is both
- options: both, remote, local
- for existing features, use regen-feature to add missing baseline without overwriting existing files

Regen example:

```bash
fsda regen-feature wallet -m finance --ds both
```

## 8) Generate Slice (Core Automation)

Use gen-slice to generate core automation per use case.

```bash
fsda gen-slice get_balance -f wallet -m finance -s M
fsda gen-slice delete_balance -f wallet -m finance -s Mp
```

Optional explicit method name:

```bash
fsda gen-slice get_balance -f wallet -m finance -s M -d getBalance
fsda gen-slice delete_balance -f wallet -m finance -s Mp -d deleteBalance
```

Optional UI generation in the same command:

```bash
fsda gen-slice get_balance -f wallet -m finance -s R -u detail
```

Or generate UI separately:

```bash
fsda gen-ui detail_balance -f wallet -m finance -u detail
```

Important:
- automation focuses on logic baseline
- UI still requires manual implementation
- route/page composition per slice is still manual via compose commands

## 9) Register Module to Target App

After module is ready for app usage, compose module wrapper into app.

```bash
fsda reg finance -a ruviti
```

This prepares module integration into app, including:
- module dependency in app
- module DI entry
- module route entry
- failure extension registration
- localization delegate registration

## 10) Install Feature Resources into App Wrapper

For features used by app, install feature DI resources into app module wrapper.

```bash
fsda di wallet -m finance -a ruviti
```

Usually this registers:
- datasource
- repository
- use case
- logic

Run per feature used by the app.

## 11) Compose per Slice

After automation is done, use compose to assemble app wrapper pages.

Main compose (build/replace primary target page and update base route):

```bash
fsda compose-main get_balance -f wallet -m finance -a ruviti -p detail
```

Inject compose for popup action (inject provider/listener/method + popup action into same page):

```bash
fsda compose-pmi delete_balance -f wallet -m finance -a ruviti -p detail
```

Notes:
- `compose-main` and `compose-form` build/replace main page and update base route
- `compose-pag` is for retrieval pagination
- `compose-pmi` is for popup menu action injection
- `compose-sec` composes retrieval sections: provider auto-triggers retrieval method and a section widget method is generated; section placement remains manual
- inject mode also upserts module child route and `to<TargetPage>()` navigation helper
- final UX/layout decisions remain in developer control

## 12) Test Run

After each compose sequence, run the app.

```bash
flutter run
```

Optional quality gate:

```bash
# from workspace root
dart analyze
```

## 13) Repeat Cycle

For the next feature, repeat this core flow:

1. gen-module (if new module)
2. gen-feature
3. gen-slice
4. reg module to app (if not registered)
5. di feature to app wrapper
6. compose each slice with matching command mode (`compose-main`, `compose-form`, `compose-pag`, `compose-pmi`, `compose-sec`), then refine UI/flow manually
7. test run

## Recommended Process: Solo vs Team

### Solo Development

Use steps 1 to 13 linearly. This is the safest path to keep full context from setup to integration.

### Team Development

Split repeat process by module:

1. each team owns one main module
2. each team runs up to gen-feature, gen-slice, and manual compose in their module
3. integration team merges outputs and runs reg + di into target app
4. run full integration test in app

Benefits:
- faster parallel development
- fewer cross-team conflicts due to clear module boundaries
- final merge focused on integration and QA

## Quick Summary

Minimal flow every junior should remember:

1. create workspace
2. check/edit fsda.yaml
3. list packages/infra
4. configure workspace
5. gen app + initial setup + test run
6. gen module
7. gen feature
8. gen slice
9. reg module to app
10. di feature to app
11. compose logic/UI/route
12. test run
13. repeat
