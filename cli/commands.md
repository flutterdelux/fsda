# FSDA CLI Commands Reference

Dokumen ini mengikuti command surface terbaru di fsda_cli.

## Workspace Rule

Semua command berikut dijalankan dari workspace root yang berisi fsda.yaml:

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

`fsda create <workspace>` dijalankan di luar workspace.

## Command List

### fsda create `workspace`

Membuat workspace FSDA baru (apps, modules, packages, fsda.yaml).

### fsda configure

Sinkronisasi workspace/packages dari root `packages:` pada fsda.yaml.

### fsda configure-app `app`

Sinkronisasi dependency app berdasarkan package yang aktif di workspace/packages.

### fsda list-pckg

Menampilkan daftar template package yang tersedia (termasuk `infra_...`).

### fsda add-pckg `name`

Menambahkan satu template package ke workspace/packages dan sinkronkan fsda.yaml.

Perilaku penting:

- jika `name` exact match template, langsung dipakai
- jika `name` short infra (misalnya `http`), CLI mencoba resolve ke `infra_http`
- package yang ter-comment di fsda.yaml akan diaktifkan
- package yang belum ada di fsda.yaml akan ditambahkan

### fsda gen-app `app`

Membuat project Flutter app di `apps/<app>` sesuai template FSDA.

### fsda gen-module `module`

Membuat module package di `modules/<module>`.

### fsda gen-feature `feature` -m `module` [--ds `datasource_mode`]

Membuat feature di `modules/<module>/lib/src/features/<feature>`.

Datasource mode (`--ds`):

- both (default)
- remote
- local

### fsda regen-feature `feature` -m `module` [--ds `datasource_mode`]

Melengkapi baseline file feature yang hilang tanpa menimpa file existing.

### fsda gen-slice `slice` -f `feature` -m `module` -s `sequence_code` [-d `method`] [-u `ui_code`]...

Generate slice dan weave ke checkpoint file sesuai sequence.

Sequence yang didukung:

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

Catatan:

- `-d` optional
- `-u` optional dan repeatable
- target baseline datasource/repository harus sudah tersedia

### fsda gen-ui `slice` -f `feature` -m `module` -u `ui_code`

Generate UI bundle dan apply efek manifest `ui.yaml`:

- inject ARB keys ke semua `.arb` module (idempotent)
- inject export UI ke feature barrel
- generate file UI di boundary `ui/<slice>/...`

UI code yang didukung:

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

Compose retrieval/main flow sebagai page scaffold utama.

Perilaku:

- membangun/replace target page
- sinkronkan base route builder ke `NotFoundPage` + update child route
- pada retrieval, provider boleh auto-trigger bootstrap method (`sl()..method()`)

### fsda compose-form `slice` -f `feature` -m `module` -a `app` -p `target_page`

Compose flow form (mutasi berbasis form) sebagai page scaffold utama.

Perilaku:

- inject mutation cubit provider + form cubit provider
- inject form widget `onListen` ke form cubit
- inject submit action method + listener + loading overlay
- sinkronkan base route builder ke `NotFoundPage` + update child route
- tidak auto-trigger mutation method di provider

### fsda compose-pag `slice` -f `feature` -m `module` -a `app` -p `target_page`

Compose retrieval pagination page dengan state handling khusus pagination.

Perilaku:

- generate page pagination + state mapping
- sinkronkan base route builder ke `NotFoundPage` + update child route
- provider retrieval boleh auto-bootstrap method

### fsda compose-pmi `slice` -f `feature` -m `module` -a `app` -p `target_page`

Compose popup menu action injection.

Perilaku:

- inject provider/listener/method
- inject popup menu action ke page target
- jika ada dialog widget, eksekusi mutation dilakukan dialog-first
- tidak auto-trigger mutation method di provider

### fsda compose-sec `slice` -f `feature` -m `module` -a `app` -p `target_page`

Compose section mode (manual widget wiring oleh developer).

Perilaku:

- inject provider retrieval + auto-eksekusi method retrieval saat provider create
- generate execution method untuk trigger manual (retry/refresh)
- generate method section widget (contoh: `_destinationPopularSection()`) untuk dipanggil manual di body Scaffold/layout mana pun
- tidak inject popup action
- listener tidak auto-inject
- section placement tetap manual oleh developer

## Compose Execution Semantics

- mutation-oriented compose (`compose-pmi`, `compose-form`) tidak mengeksekusi mutation saat provider create
- `compose-sec` (section retrieval) mengeksekusi method retrieval saat provider create
- retrieval-oriented compose (`compose-main`, `compose-pag`) boleh auto-bootstrap method retrieval di provider create

## Listener Localization Convention

Untuk listener success message hasil compose, key l10n menggunakan pola:

- `<featureCamel><slicePascal>Success`

Contoh:

- `inboxMarkAllReadSuccess`
- `walletDeleteSuccess`
- `taskCreateSuccess`

## Module Registration Commands

### fsda reg `module` -a `app`

Register module wrapper ke app:

- app pubspec dependency
- DI registration
- route registration
- l10n delegate registration
- failure extension registration

### fsda di `feature` -m `module` -a `app`

Generate/merge feature DI registration di wrapper module app.

### fsda rm-reg `module` -a `app`

Remove module registration dari app target.

### fsda fix-import [-m `module`] [-a `app`]

Automasi rapikan directive/import tanpa edit manual satu-per-satu file.

Perilaku:

- menjalankan `dart fix --apply --code=directives_ordering --code=unused_import`
- target bisa module (`-m`) dan/atau app (`-a`) dalam satu command
- wajib minimal salah satu target (`-m` atau `-a`)

## Legacy Note

`fsda compose ... --main` adalah surface lama/transisional. Gunakan command family compose yang spesifik.

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
fsda gen-slice detail -f wallet -m finance -s Rp -u main
fsda gen-slice delete -f wallet -m finance -s Mp -u pmi,dialog

fsda reg finance -a fsda_demo
fsda di wallet -m finance -a fsda_demo

fsda compose-main detail -f wallet -m finance -a fsda_demo -p wallet_detail_page
fsda compose-pmi delete -f wallet -m finance -a fsda_demo -p wallet_detail_page
```
