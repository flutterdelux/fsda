# FSDA CLI Workflow

Workflow ini disusun berdasarkan command CLI yang aktif saat ini, urut dari inisialisasi workspace sampai cycle development berulang.

Untuk skenario E2E test yang siap pakai (workspace -> app run) gunakan:
- [Wikuy-CLI Driven E2E](/id/getting-started-cli-wikuy.md)

Target dokumen:
- jelas untuk developer baru (junior)
- tetap cukup rinci untuk solo dan tim
- urutannya sesuai proses nyata di project

## Rule Utama

Semua command dijalankan dari root workspace yang punya fsda.yaml, kecuali create.

Contoh:

```bash
# dijalankan di luar workspace
fsda create fsda-base

# masuk ke root workspace
cd fsda-base
```

## 1) Create Workspace

Mulai dari pembuatan workspace kosong dengan struktur FSDA.

```bash
fsda create fsda-base
cd fsda-base
```

Struktur awal minimal:

```text
fsda-base/
├── apps/
├── modules/
├── packages/
└── fsda.yaml
```

## 2) Cek dan Edit fsda.yaml untuk Setup Awal

Setelah workspace dibuat, langsung cek fsda.yaml. File ini adalah sumber kebenaran paket awal workspace.

Contoh isi awal yang umum:

```yaml
packages:
  - app_core
  - app_l10n
  - app_ui
  - infra_http
  - infra_logging
```

Catatan:
- daftar di packages menentukan apa yang akan disiapkan oleh fsda configure
- kalau mau ganti stack infra (misal dari http ke http), edit di sini dulu

## 3) Cek Template Package dan Infra yang Tersedia

Sebelum final edit fsda.yaml, developer bisa lihat daftar template yang tersedia.

```bash
fsda list-pckg
```

Tips cek infra dari output list-pckg:

```bash
fsda list-pckg | grep infra_
```

Gunakan hasil list untuk memastikan nama package di fsda.yaml valid.

## 4) Configure Workspace Sesuai fsda.yaml

Jalankan sinkronisasi package awal workspace.

```bash
fsda configure
```

Expected outcome:
- folder packages berisi package yang ada di fsda.yaml
- package yang tidak lagi ada di fsda.yaml akan disesuaikan sesuai mekanisme configure

Contoh hasil:

```text
packages/
├── app_core/
├── app_l10n/
├── app_ui/
├── infra_http/
└── infra_logging/
```

## 5) Generate App dan Setup App Awal

Generate app target.

```bash
fsda gen-app ruviti
```

Lalu setup awal app sesuai petunjuk docs app / log output setelah generate sukses.

```bash
cd apps/ruviti
flutter pub get

# jika diperlukan oleh app template
dart run package_rename
dart run flutter_launcher_icons

flutter run
```

Kembali ke root workspace, lalu sinkronkan app dengan package aktif workspace:

```bash
cd ../..
fsda configure-app ruviti
```

Gunakan fsda configure-app setiap kali ada perubahan package infra/app package yang mempengaruhi app dependency dan DI app.

## 6) Generate Module (Mulai Development Modular)

```bash
fsda gen-module finance
```

Tujuan step ini:
- menyiapkan boundary modul
- menyiapkan shared error, extension, dan wrapper fitur

## 7) Generate Feature

```bash
fsda gen-feature wallet -m finance --ds both
```

Menyiapkan folder feature di modul target, termasuk struktur awal file barrel feature.

Catatan:
- mode datasource default adalah both.
- opsi yang tersedia: both, remote, local.
- untuk feature yang sudah ada, gunakan regen-feature untuk melengkapi baseline tanpa menimpa file yang sudah ada.

Contoh regen:

```bash
fsda regen-feature wallet -m finance --ds both
```

## 8) Generate Slice (Automation Inti)

Gunakan gen-slice untuk menghasilkan automation inti per use case.

```bash
fsda gen-slice get_balance -f wallet -m finance -s M
fsda gen-slice delete_balance -f wallet -m finance -s Mp
```

Opsional method name explicit:

```bash
fsda gen-slice get_balance -f wallet -m finance -s M -d getBalance
fsda gen-slice delete_balance -f wallet -m finance -s Mp -d deleteBalance
```

Opsional generate UI dalam command yang sama:

```bash
fsda gen-slice get_balance -f wallet -m finance -s R -u main
```

Atau generate UI terpisah:

```bash
fsda gen-ui detail_balance -f wallet -m finance -u main
```

Penting:
- automation fokus sampai level logic
- UI tetap perlu development manual
- route screen per slice juga perlu compose manual

## 9) Register Module ke App Target

Setelah module siap dipakai app, lakukan wrapper composition module ke app.

```bash
fsda reg finance -a ruviti
```

Step ini menyiapkan integrasi module ke app, termasuk:
- dependency module di app
- DI module entry
- route module entry
- failure extension registration
- localization delegate registration

## 10) Install Resource Feature ke Wrapper App

Untuk feature yang benar-benar dipakai app, install resource DI feature ke wrapper module app.

```bash
fsda di wallet -m finance -a ruviti
```

Biasanya command ini akan menyiapkan registration untuk:
- datasource
- repository
- use case
- logic

Jalankan per feature yang dipakai app.

## 11) Compose Per Slice

Setelah automation selesai, gunakan compose untuk merakit page app wrapper.

Main compose (membentuk/replace page target dari slice utama dan update base route):

```bash
fsda compose-main get_balance -f wallet -m finance -a ruviti -p detail
```

Inject compose untuk aksi popup menu (menambah provider/listener/method + popup action ke page yang sama):

```bash
fsda compose-pmi delete_balance -f wallet -m finance -a ruviti -p detail
```

Catatan:
- `compose-main` dan `compose-form` mengganti/menyusun page utama dan update base route
- `compose-pag` khusus retrieval pagination
- `compose-pmi` khusus popup menu item
- `compose-sec` compose retrieval section: provider auto-trigger method retrieval, sekaligus generate method section widget; peletakan section tetap manual oleh developer
- compose mode injection tetap mendaftarkan target page ke child routes module dan helper navigasi `to<TargetPage>()`
- keputusan UX/layout detail tetap di tangan developer setelah baseline compose terbentuk

## 12) Test Run

Setiap selesai 1 rangkaian compose, langsung test run.

```bash
flutter run
```

Opsional quality gate:

```bash
# dari root workspace
dart analyze
```

## 13) Repeat Cycle

Untuk fitur berikutnya, ulangi alur inti ini:

1. gen-module (jika module baru)
2. gen-feature
3. gen-slice
4. reg module ke app (jika belum)
5. di feature ke app wrapper
6. compose per slice dengan command mode yang sesuai (`compose-main`, `compose-form`, `compose-pag`, `compose-pmi`, `compose-sec`) lalu refine UI/flow manual
7. test run

## Rekomendasi Proses Solo vs Tim

### Solo Development

Gunakan urutan step 1 sampai 13 secara linear. Ini paling aman untuk menjaga konteks tetap utuh dari setup sampai integrasi.

### Team Development

Proses repeat dipecah per module:

1. tiap tim pegang 1 module utama
2. tiap tim jalan sampai gen-feature, gen-slice, dan manual compose di module masing-masing
3. tim integrasi menggabungkan hasil dan jalankan reg + di ke app target
4. lakukan test run integrasi penuh di app

Hasilnya:
- paralel development lebih cepat
- konflik antar tim lebih kecil karena boundary module jelas
- penggabungan akhir fokus ke integration dan QA

## Ringkasan Singkat

Alur minimal yang wajib diingat junior:

1. create workspace
2. cek/edit fsda.yaml
3. list package/infra
4. configure workspace
5. gen app + setup awal + test run
6. gen module
7. gen feature
8. gen slice
9. reg module ke app
10. di feature ke app
11. manual compose logic/ui/route
12. test run
13. repeat
