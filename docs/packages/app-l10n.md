# app_l10n

Package fondasi untuk localization dan semua resource bahasa yang digunakan bersama oleh aplikasi.

&nbsp;

## Purpose

`app_l10n` menjadi tempat untuk mengelola teks lintas aplikasi secara konsisten agar localization tidak tersebar acak di App, Module, atau widget tertentu.

`app_l10n` bukan pengganti localization milik module. Package ini berfungsi sebagai fondasi localization bersama pada level aplikasi atau sistem.

&nbsp;

## Typical Responsibilities

Contoh isi yang cocok berada di `app_l10n`:

* localization resource dan generated localization
* key atau access pattern untuk translation
* shared localized message yang dipakai lintas module
* konfigurasi locale dan fallback locale yang berlaku lintas aplikasi

&nbsp;

## Shared L10n vs Module L10n

Pemisahan tanggung jawabnya sebagai berikut:

* `app_l10n` menampung localization yang sifatnya umum, shared, atau lintas banyak module
* setiap module tetap dapat dan biasanya memang perlu memiliki localization sendiri untuk text UI yang spesifik ke module tersebut

Jika sebuah module memiliki UI yang menampilkan text ke user, maka module tersebut sebaiknya memiliki resource l10n sendiri agar ownership text tetap berada dekat dengan boundary modulenya.

&nbsp;

## Module L10n Baseline

Baseline yang direkomendasikan untuk module yang memiliki UI text:

```text
<module>/
├── l10n.yaml
└── lib/
    ├── l10n/
    │   ├── <module>_en.arb
    │   └── <module>_id.arb
    └── src/
        ├── extensions/
        │   └── l10n_x.dart
        └── generated/
            ├── <module>_localizations.dart
            ├── <module>_localizations_en.dart
            └── <module>_localizations_id.dart
```

Contoh `l10n.yaml` pada module:

```yaml
arb-dir: lib/l10n
template-arb-file: <module>_en.arb
output-localization-file: <module>_localizations.dart
output-class: <Module>Localizations
output-dir: lib/src/generated
untranslated-messages-file: missing_keys.json
```

&nbsp;

## Good Candidates

Letakkan sesuatu di `app_l10n` jika resource tersebut:

* berkaitan langsung dengan bahasa atau terjemahan
* dipakai bersama oleh lebih dari satu module atau app
* tidak membawa business ownership feature tertentu

&nbsp;

## Not For

`app_l10n` bukan tempat untuk:

* business rule
* widget UI
* datasource atau repository
* message yang hanya relevan untuk satu feature atau satu module dan belum menjadi kebutuhan lintas boundary

&nbsp;

## Dependency Position

`app_l10n` dapat digunakan oleh App dan Module saat membutuhkan resource localization bersama.

Pisahkan localization lintas sistem di sini agar perubahan bahasa tidak menempel ke feature implementation tertentu.

Namun untuk text yang benar-benar spesifik ke suatu module, lebih baik letakkan localization-nya tetap di module tersebut.

Dalam baseline Flutter saat ini, module umumnya bergantung pada `app_l10n` untuk akses localization umum yang dipakai lintas app maupun module.

&nbsp;

## Composition In App

App bertugas menyusun localization umum dari `app_l10n` bersama localization milik module yang benar-benar dipakai aplikasi.

Dengan pola ini:

* `app_l10n` tetap menjadi fondasi localization umum
* module tetap memegang ownership text UI yang spesifik ke boundary-nya
* App menjadi tempat composition akhir untuk delegates, locales, dan kebutuhan localization root lainnya

Contoh:

```dart
MaterialApp(
    localizationsDelegates: [
        AppLocalizations.delegate,
        ProductLocalizations.delegate,
        FinanceLocalizations.delegate,
    ],
)
```