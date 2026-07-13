# FSDA CLI Commands Reference

This document follows the latest fsda_cli command surface.

## Workspace Rule

Run the following commands from the workspace root that contains fsda.yaml:

- fsda configure
- fsda configure-app `app`
- fsda list-pckg
- fsda add-pckg `name`
- fsda gen-app `app`
- fsda gen-module `module`
- fsda gen-feature `feature` -m `module` [--ds `datasource_mode`]
- fsda regen-feature `feature` -m `module` [--ds `datasource_mode`]
- fsda gen-slice `slice` -f `feature` -m `module` -s `sequence_code` [-d `method`] [-u `ui_code`]...
- fsda gen-ui `slice` -f `feature` -m `module` -u `ui_code`
- fsda compose-main `slice` -f `feature` -m `module` -a `app` -p `target_page`
- fsda compose-form `slice` -f `feature` -m `module` -a `app` -p `target_page`
- fsda compose-pag `slice` -f `feature` -m `module` -a `app` -p `target_page`
- fsda compose-pmi `slice` -f `feature` -m `module` -a `app` -p `target_page`
- fsda compose-sec `slice` -f `feature` -m `module` -a `app` -p `target_page`
- fsda reg `module` -a `app`
- fsda di `feature` -m `module` -a `app`
- fsda rm-reg `module` -a `app`
- fsda fix-import [-m `module`] [-a `app`]

`fsda create <workspace>` is intentionally run outside the workspace root.

## Command List

### fsda create `workspace`

Create a new FSDA workspace (apps, modules, packages, fsda.yaml).

### fsda configure

Synchronize workspace packages from the root `packages:` section in fsda.yaml.

### fsda configure-app `app`

Synchronize app dependencies based on active packages in workspace/packages.

### fsda list-pckg

List available package templates (including `infra_...`).

### fsda add-pckg `name`

Add one package template to workspace/packages and sync fsda.yaml.

Important behavior:

- if `name` matches a template exactly, it is used directly
- if `name` is an infra short name (for example `http`), CLI resolves it to `infra_http`
- packages commented in fsda.yaml are activated
- packages missing in fsda.yaml are appended

### fsda gen-app `app`

Create a Flutter app project in `apps/<app>` using the FSDA template.

### fsda gen-module `module`

Create a module package in `modules/<module>`.

### fsda gen-feature `feature` -m `module` [--ds `datasource_mode`]

Create a feature in `modules/<module>/lib/src/features/<feature>`.

Datasource mode (`--ds`):

- both (default)
- remote
- local

### fsda regen-feature `feature` -m `module` [--ds `datasource_mode`]

Fill missing baseline feature files without overwriting existing files.

### fsda gen-slice `slice` -f `feature` -m `module` -s `sequence_code` [-d `method`] [-u `ui_code`]...

Generate a slice and weave it into checkpoint files based on sequence rules.

Supported sequence codes:

- M
- Mp
- Mr
- Mrp
- R
- Rp
- Rpag
- Rs
- Rsp
- Rof

Notes:

- `-d` is optional
- `-u` is optional and repeatable
- target baseline datasource/repository files must already exist

### fsda gen-ui `slice` -f `feature` -m `module` -u `ui_code`

Generate UI bundle and apply `ui.yaml` manifest effects:

- inject ARB keys into all module `.arb` files (idempotent)
- inject UI exports into feature barrel
- generate UI files under `ui/<slice>/...`

Supported UI codes:

- detail
- dialog
- form
- lsh
- lsv
- pag
- pmi
- sec

## Compose Family

### fsda compose-main `slice` -f `feature` -m `module` -a `app` -p `target_page`

Compose retrieval/main flow as the primary page scaffold.

Behavior:

- builds/replaces target page
- syncs base route builder to `NotFoundPage` + updates child route
- for retrieval, provider can auto-trigger bootstrap method (`sl()..method()`)

### fsda compose-form `slice` -f `feature` -m `module` -a `app` -p `target_page`

Compose form flow (form-based mutation) as the primary page scaffold.

Behavior:

- inject mutation cubit provider + form cubit provider
- inject form widget `onListen` to form cubit
- inject submit action method + listener + loading overlay
- syncs base route builder to `NotFoundPage` + updates child route
- does not auto-trigger mutation in provider

### fsda compose-pag `slice` -f `feature` -m `module` -a `app` -p `target_page`

Compose retrieval pagination page with pagination-aware state handling.

Behavior:

- generates pagination page + state mapping
- syncs base route builder to `NotFoundPage` + updates child route
- retrieval provider may auto-bootstrap method

### fsda compose-pmi `slice` -f `feature` -m `module` -a `app` -p `target_page`

Compose popup menu action injection.

Behavior:

- inject provider/listener/method
- inject popup menu action into target page
- if dialog widget exists, mutation execution follows dialog-first flow
- does not auto-trigger mutation in provider

### fsda compose-sec `slice` -f `feature` -m `module` -a `app` -p `target_page`

Compose section mode (manual widget wiring by developer).

Behavior:

- inject retrieval provider and auto-execute retrieval method during provider create
- generate execution method for manual trigger (retry/refresh)
- generate section widget method (for example: `_destinationPopularSection()`) so developers can place it manually in Scaffold body or any layout container
- does not inject popup action
- listener is not auto-injected
- section placement remains manual by developer

## Compose Execution Semantics

- mutation-oriented compose (`compose-pmi`, `compose-form`) must not execute mutation during provider create
- `compose-sec` (retrieval section mode) executes retrieval method during provider create
- retrieval-oriented compose (`compose-main`, `compose-pag`) may auto-bootstrap retrieval method during provider create

## Listener Localization Convention

For composed listener success messages, l10n key pattern is:

- `<featureCamel><slicePascal>Success`

Examples:

- `inboxMarkAllReadSuccess`
- `walletDeleteSuccess`
- `taskCreateSuccess`

## Module Registration Commands

### fsda reg `module` -a `app`

Register module wrapper into app:

- app pubspec dependency
- DI registration
- route registration
- l10n delegate registration
- failure extension registration

### fsda di `feature` -m `module` -a `app`

Generate/merge feature DI registration in app module wrapper.

### fsda rm-reg `module` -a `app`

Remove module registration from target app.

### fsda fix-import [-m `module`] [-a `app`]

Automate import cleanup and directive ordering without editing files one by one.

Behavior:

- runs `dart fix --apply --code=directives_ordering --code=unused_import`
- target can be module (`-m`) and/or app (`-a`) in a single command
- requires at least one target (`-m` or `-a`)

## Legacy Note

`fsda compose ... --main` is legacy/transitional surface. Use the explicit compose command family.

## Quick Example

```bash
fsda create fsda_base
cd fsda_base

fsda configure
fsda add-pckg app_core
fsda add-pckg infra_http

fsda gen-app fsda_demo
fsda configure-app fsda_demo

fsda gen-module finance
fsda gen-feature wallet -m finance --ds remote
fsda gen-slice detail -f wallet -m finance -s Rp -u detail
fsda gen-slice delete -f wallet -m finance -s Mp -u pmi,dialog

fsda reg finance -a fsda_demo
fsda di wallet -m finance -a fsda_demo

fsda compose-main detail -f wallet -m finance -a fsda_demo -p wallet_detail_page
fsda compose-pmi delete -f wallet -m finance -a fsda_demo -p wallet_detail_page
```
