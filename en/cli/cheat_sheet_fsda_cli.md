# FSDA CLI Cheat Sheet

Quick reference for the latest fsda_cli commands.

## 1) Setup Workspace

```bash
# create a new workspace (run outside workspace)
fsda create fsda_base

cd fsda_base

# sync root packages from fsda.yaml
fsda configure
```

## 2) Package Management

```bash
# list available package templates
fsda list-pckg

# add packages
fsda add-pckg app_core
fsda add-pckg app_ui
fsda add-pckg app_l10n

# add infra package
fsda add-pckg infra_http
# infra short name is also supported (auto-resolved)
fsda add-pckg http
```

## 3) Create App and Module

```bash
# generate app
fsda gen-app daylook

# sync app dependencies from workspace/packages
fsda configure-app daylook

# generate module
fsda gen-module travel
```

## 4) Create Feature and Slice

```bash
# generate feature
fsda gen-feature destination -m travel --ds remote

# generate retrieval slice + detail UI
fsda gen-slice popular -f destination -m travel -s Rp -u detail

# generate mutation slice + popup menu and dialog UI
fsda gen-slice bookmark -f destination -m travel -s Mp -u pmi,dialog

# generate form mutation slice
fsda gen-slice create -f destination -m travel -s Mp -u form
```

Sequence codes:

- `M` mutation
- `Mp` mutation + param
- `Mr` mutation + return
- `Mrp` mutation + return + param
- `R` retrieval
- `Rp` retrieval + param
- `Rpag` retrieval + pagination
- `Rs` retrieval stream
- `Rsp` retrieval stream + param
- `Rof` retrieval offline-first

## 5) Generate UI Only

```bash
fsda gen-ui popular -f destination -m travel -u detail
fsda gen-ui bookmark -f destination -m travel -u pmi
```

Supported UI codes:

- `detail`
- `dialog`
- `form`
- `lsh`
- `lsv`
- `pag`
- `pmi`
- `sec`

## 6) Register Module to App

```bash
# register module wrapper into app
fsda reg travel -a daylook

# register feature DI
fsda di destination -m travel -a daylook

# remove registration
fsda rm-reg travel -a daylook
```

## 7) Compose Commands (New)

Use compose command based on UI intent:

```bash
# compose retrieval primary page
fsda compose-main popular -f destination -m travel -a daylook -p destination_page

# compose form mutation primary page
fsda compose-form create -f destination -m travel -a daylook -p destination_create_page

# compose pagination page
fsda compose-pag popular -f destination -m travel -a daylook -p destination_page

# compose popup menu action into existing page
fsda compose-pmi bookmark -f destination -m travel -a daylook -p destination_page

# compose section mode (retrieval auto-bootstrap + section method)
fsda compose-sec bookmark -f destination -m travel -a daylook -p destination_page
```

Mode guidance:

- `compose-main`: retrieval/detail flow
- `compose-form`: form mutation flow
- `compose-pag`: pagination retrieval flow
- `compose-pmi`: popup action injection
- `compose-sec`: retrieval section compose (provider auto-exec + section method generated; placement remains manual)

## 8) Compose Behavior Notes

- mutation compose (`compose-pmi`, `compose-form`) does not auto-execute mutation during provider create
- `compose-sec` executes retrieval method during provider create
- retrieval compose (`compose-main`, `compose-pag`) may auto-bootstrap retrieval method
- listener success key follows:

`<featureCamel><slicePascal>Success`

Example: `destinationBookmarkSuccess`

## 9) One Full Example

```bash
fsda create fsda_base
cd fsda_base

fsda configure
fsda add-pckg app_core
fsda add-pckg app_l10n
fsda add-pckg infra_http

fsda gen-app daylook
fsda configure-app daylook

fsda gen-module travel
fsda gen-feature destination -m travel --ds remote

fsda gen-slice popular -f destination -m travel -s Rp -u detail
fsda gen-slice bookmark -f destination -m travel -s Mp -u pmi,dialog
fsda gen-slice create -f destination -m travel -s Mp -u form

fsda reg travel -a daylook
fsda di destination -m travel -a daylook

fsda compose-main popular -f destination -m travel -a daylook -p destination_page
fsda compose-pmi bookmark -f destination -m travel -a daylook -p destination_page
fsda compose-form create -f destination -m travel -a daylook -p destination_create_page
```
