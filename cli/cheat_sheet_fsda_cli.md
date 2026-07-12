# FSDA CLI Cheat Sheet

Panduan cepat command fsda_cli terbaru.

## 1) Setup Workspace

```bash
# create workspace baru (jalankan di luar workspace)
fsda create fsda_base

cd fsda_base

# sinkronisasi package root dari fsda.yaml
fsda configure
```

## 2) Package Management

```bash
# lihat template package tersedia
fsda list-pckg

# tambahkan package
fsda add-pckg app_core
fsda add-pckg app_ui
fsda add-pckg app_l10n

# tambahkan infra package
fsda add-pckg infra_dio
# short infra name juga didukung (akan di-resolve)
fsda add-pckg dio
```

## 3) Create App and Module

```bash
# buat app
fsda gen-app daylook

# sinkronisasi dependency app dari workspace/packages
fsda configure-app daylook

# buat module
fsda gen-module travel
```

## 4) Create Feature and Slice

```bash
# buat feature
fsda gen-feature destination -m travel --ds remote

# generate retrieval slice + detail UI
fsda gen-slice popular -f destination -m travel -s Rp -u detail

# generate mutation slice + popup menu and dialog UI
fsda gen-slice bookmark -f destination -m travel -s Mp -u pmi,dialog

# generate form mutation slice
fsda gen-slice create -f destination -m travel -s Mp -u form
```

Sequence code:

- `M` mutation
- `Mp` mutation + param
- `Mr` mutation + return
- `Mrp` mutation + return + param
- `R` retrieval
- `Rp` retrieval + param
- `Rpag` retrieval + pagination
- `Rs` retrieval stream
- `Rsp` retrieval stream + param
- `Rof` retrieval local-first

## 5) Generate UI Only

```bash
fsda gen-ui popular -f destination -m travel -u detail
fsda gen-ui bookmark -f destination -m travel -u pmi
```

UI code yang didukung:

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
# register module wrapper ke app
fsda reg travel -a daylook

# register DI feature
fsda di destination -m travel -a daylook

# remove registration
fsda rm-reg travel -a daylook
```

## 7) Compose Commands (New)

Gunakan command compose sesuai mode UI:

```bash
# compose page utama retrieval
fsda compose-main popular -f destination -m travel -a daylook -p destination_page

# compose page utama form mutation
fsda compose-form create -f destination -m travel -a daylook -p destination_create_page

# compose page pagination
fsda compose-pag popular -f destination -m travel -a daylook -p destination_page

# compose popup menu action ke page existing
fsda compose-pmi bookmark -f destination -m travel -a daylook -p destination_page

# compose section mode (retrieval auto-bootstrap + section method)
fsda compose-sec bookmark -f destination -m travel -a daylook -p destination_page
```

Mode guidance:

- `compose-main`: retrieval/detail flow
- `compose-form`: form mutation flow
- `compose-pag`: pagination retrieval flow
- `compose-pmi`: popup action injection
- `compose-sec`: retrieval section compose (provider auto-exec + section method generated; placement manual)

## 8) Compose Behavior Notes

- mutation compose (`compose-pmi`, `compose-form`) tidak auto-execute mutation saat provider create
- `compose-sec` mengeksekusi method retrieval saat provider create
- retrieval compose (`compose-main`, `compose-pag`) bisa auto-bootstrap retrieval method
- listener success message key mengikuti pola:

`<featureCamel><slicePascal>Success`

Contoh: `destinationBookmarkSuccess`

## 9) One Full Example

```bash
fsda create fsda_base
cd fsda_base

fsda configure
fsda add-pckg app_core
fsda add-pckg app_l10n
fsda add-pckg infra_dio

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
