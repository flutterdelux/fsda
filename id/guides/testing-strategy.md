# Testing Strategy

Dokumen ini mendefinisikan strategi testing praktis untuk proyek FSDA.

## Purpose

Testing strategy membantu memastikan tiap layer dapat diverifikasi tanpa mengaburkan boundary arsitektur.

## Acuan Testing

Rancang test dengan mengikuti tanggung jawab tiap layer, kontrak sequence Use Case, batas slice fitur, dan komposisi App.

## Prinsip Testing FSDA

* Test berdasarkan ownership boundary tiap layer.
* Satu unit file produksi sebaiknya punya satu file test khusus (jika relevan).
* Validasi kontrak/behavior, bukan detail internal yang tidak penting.
* Jaga test tetap deterministik dan cepat sebagai default.
* Tambahkan kedalaman integration hanya pada area composition risk.
* Gunakan style BDD yang eksplisit dan mudah dibaca.

## Baseline Pilot (Travel / Destination / Popular)

Pilot pertama yang dijadikan baseline adalah Use Case `getPopularDestination` beserta Logic/UI slice `popular` pada feature travel/destination.

Ringkasan fokusnya:

| Scope | Fokus | Bentuk Test |
| --- | --- | --- |
| Module Domain | kontrak use case | `domain/usecases/*_use_case_test.dart` |
| Module Data | parsing response, mapping, translation error | `data/datasources/*_impl_test.dart`, `data/repositories/*_impl_test.dart` |
| Module Logic | state transition (loading, loaded, empty, failure) per slice | `logic/<logic_slice>/*_cubit_test.dart` |
| Module UI | perilaku widget per file ownership | `ui/<ui_slice>/widgets/*_test.dart` dan `ui/<ui_slice>/widgets/parts/*_test.dart` |
| App Integration | App-owned orchestration (wiring callback/event ke Logic), route, dan DI composition | `test/modules/.../*_widget_test.dart`, `test/modules/.../*_di_test.dart` |

## Matriks Testing Berbasis Layer

| Layer | Fokus Utama | Test yang Direkomendasikan | Yang Harus Dihindari |
| --- | --- | --- | --- |
| Domain | Rule bisnis dan kontrak | Unit test untuk use case, ekspektasi kontrak, dan behavior entity saat ada logic bisnis | Assertion framework/UI |
| Data | Mapping dan translasi teknis | Unit/contract test untuk mapping DTO-Entity, mapping request/response, translasi exception ke failure, behavior repository | Assertion UI dan state-flow |
| Logic | Orkestrasi state | Unit test untuk state transition dan orkestrasi use case | Assertion detail implementasi datasource |
| UI | Behavior presentasi | Widget test untuk render, interaction, visual loading/empty/error | Assertion repository dan transport |
| App | Wiring komposisi dan orkestrasi | Integration atau smoke test untuk route, wiring DI, callback/event dari UI ke Logic, komposisi module, dan localization | Mengulang rule bisnis level rendah; menempatkan pemanggilan Logic di UI |

## Portofolio Jenis Test

Gunakan jenis test sesuai risiko dan scope:

* Unit test: default untuk behavior Domain, Data, dan Logic.
* Widget test: default untuk presentasi dan interaksi UI.
* Integration test: untuk jalur komposisi app dan flow user lintas module.
* Smoke test: validasi minimal startup, routing, dan entry page kritis.

## Layer-Based Testing

Gunakan pendekatan berikut sebagai baseline:

* Domain: unit test untuk use case, contract behavior, dan rule bisnis
* Data: test untuk mapping, translation error, repository behavior, dan adapter teknis
* Logic: test untuk state transition dan orchestration logic pada setiap slice yang relevan
* UI: widget test untuk presentation dan interaction utama pada setiap bagian UI slice yang relevan
* App: integration atau smoke test untuk composition, route, dependency wiring, dan pemanggilan Logic melalui event/callback yang disusun App

### Policy Entity Test

Entity test bersifat kondisional berdasarkan behavior.

Wajib ketika entity memiliki:

* invariant/validasi constructor atau factory
* domain method, computed property, atau derived rules
* custom equality/normalization di luar perilaku generator default
* rule bisnis kritis dengan risiko regresi tinggi

Opsional ketika entity:

* hanya data contract field-only (anemic model)
* akan menghasilkan test yang hanya mengulang behavior generator tanpa perlindungan bisnis tambahan

Pada rollout awal testing, valid untuk memprioritaskan boundary berisiko tinggi dulu (use case, translasi data, state logic, state UI, wiring app), lalu menambah entity test saat behavior entity berkembang.

## Sequence Contract dan Slice Testing

Sequence adalah kontrak Use Case-to-data. Uji behavior setiap Use Case berdasarkan flow/signature contract yang dipakainya, bukan berdasarkan nama Logic/UI slice. Minimal verifikasi:

* Async/sync Use Case: input yang diteruskan (jika ada), hasil atau `void`, dan failure.
* Stream Use Case: emission berurutan, failure emission, serta cancel/close bila dimiliki lifecycle.
* Param Use Case: pemetaan input dari Param ke repository/data contract.
* Return Use Case: nilai hasil, termasuk pemetaan DTO ke Entity pada boundary yang bertanggung jawab.

Pagination, limit tertentu, offline-first, serta transformasi state diuji pada layer pemilik behavior tersebut. Contohnya, pagination/load-more dan limit `5` diuji pada Logic slice yang membentuk parameter; cache/fallback diuji di Data; state loading/loaded/error diuji di Logic; rendering dan callback diuji di UI.

Bagian Logic yang memanggil beberapa Use Case perlu test untuk orkestrasi sukses/gagal masing-masing jalur. Logic form yang tidak memanggil Use Case tetap diuji untuk input, validasi lokal, dan transisi state. UI slice diuji tanpa mengakses Logic langsung, dengan callback dan data sebagai batas test.

## Struktur File Test yang Direkomendasikan

Mirror ownership produksi agar discovery test lebih mudah.

```text
modules/
└── <module>/
		└── test/
				└── src/
						└── features/
								└── <feature>/
										├── domain/usecases/<use_case_name>_test.dart
										├── data/repositories/<feature>_repository_impl_test.dart
										├── logic/<logic_slice>/<feature>_<logic_slice>_cubit_test.dart
										└── ui/<ui_slice>/views/<feature>_<ui_slice>_view_test.dart

apps/
└── <app>/
		├── test/
		│   └── app/<module>_route_test.dart
		└── integration_test/
				└── <feature>_<slice>_flow_test.dart
```

## Naming Skenario Test (BDD)

Gunakan pola:

* `<production_file_name>_test.dart`
* nama `group` mengikuti `<Feature><Slice>` jika memungkinkan
* title test mengikuti format BDD: `Given <konteks>, When <aksi>, Then <ekspektasi>`
* untuk title panjang, gunakan multi-line string segment agar mudah dibaca

Untuk readability, gunakan multi-line string segment:

```dart
group('DestinationListCubit', () {
	test(
		'Given data valid, '
		'When getList dipanggil, '
		'Then loaded state diemit',
		() async {
			// ...
		},
	);
});
```

## Service Locator Testing Policy

Saat test dengan GetIt:

* jangan mock object service locator (`sl`) itu sendiri
* gunakan `sl.reset()` per lifecycle test
* register test double hanya untuk collaborator yang relevan dengan skenario
* pada test komposisi app, pisahkan validasi registration/resolution DI dari test business flow

## Test Double Strategy

Gunakan test double secara sengaja:

* Fake: untuk collaborator sederhana dan deterministik
* Mock: hanya saat verifikasi interaksi dibutuhkan
* Stub: untuk return behavior tetap

Hindari mocking value object seperti Params, Entities, atau enum sederhana.

## Definition Of Done per Layer Slice and Feature Flow

Sebuah slice dianggap test-complete ketika layer yang memang diimplementasikan pada slice tersebut memenuhi checklist minimum berikut:

* [ ] Domain: behavior success/failure pada use case ter-cover.
* [ ] Domain: behavior entity ter-cover jika entity memuat logic atau invariant bisnis.
* [ ] Data: parsing/mapping DTO, request, converter dan parsing kontrak response ter-cover jika unit tersebut ada.
* [ ] Data: jalur sukses/gagal datasource ter-cover jika datasource bagian dari slice.
* [ ] Data: behavior repository untuk mapping dan translasi exception ke failure ter-cover.
* [ ] Logic: state transition untuk skenario slice ter-cover.
* [ ] UI: state/interaksi widget kritis ter-cover per file ownership, termasuk widget `parts/` jika memuat kontrak visual/interaksi.
* [ ] App: smoke komposisi route/page, registrasi/resolusi DI, dan jalur callback/event App → Logic ter-cover jika slice menambah wiring app.
* [ ] Use Case sequence contract: signature, input/result, failure, dan stream lifecycle ter-cover sesuai tipe contract yang digunakan.
* [ ] Alur fitur: wiring App antar UI/Logic slices dan Use Case dependencies yang relevan ter-cover.

## Rekomendasi Quality Gate CI

Mulai dari gate yang pragmatis, lalu ketatkan bertahap:

* jalankan unit dan widget test module yang berubah di tiap pull request
* jalankan integration/smoke test pada jalur komposisi app yang berubah
* validasi dependency/architecture rules di pipeline CI
* gunakan coverage floor sebagai trend guard, bukan vanity metric

Contoh baseline coverage awal (sesuaikan kematangan tim):

* Domain: 85%+
* Data: 75%+
* Logic: 80%+
* UI: 60%+ pada surface kritis

## Rollout Plan untuk Proyek yang Belum Memiliki Test

Gunakan rollout bertahap:

1. finalisasi strategi dan template bersama
2. pilot satu slice nyata (contoh: `travel/destination/popular` pada Retrieval)
3. stabilisasi checklist dan naming dari hasil pilot
4. perluas module demi module, pastikan kontrak Use Case dan jenis Logic/UI slice yang relevan mendapat test
5. aktifkan gate CI saat baseline coverage sudah realistis

## Template Test Case

Gunakan template berikut untuk konsistensi:

```text
Title:
Given:
When:
Then:
Expected State:
Notes:
```

## Workflow Coverage Multi-Package

Karena module dan app beda folder:

```bash
cd <workspace>/modules/<module>
flutter test --coverage
lcov --ignore-errors unused --remove coverage/lcov.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/lcov.info

cd <workspace>/apps/<app>
flutter test --coverage
lcov --ignore-errors unused --remove coverage/lcov.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/lcov.info
```

Opsional report HTML per package:

```bash
cd <workspace>/modules/<module>
genhtml coverage/lcov.info -o coverage/html --ignore-errors empty,unused
open coverage/html/index.html
```

Opsional gabung angka coverage (filtered):

```bash
cd <workspace>
mkdir -p coverage
lcov -a modules/<module>/coverage/lcov.info -a apps/<app>/coverage/lcov.info -o coverage/combined.info
lcov --ignore-errors unused --remove coverage/combined.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/combined.info
lcov --summary coverage/combined.info
```

Opsional report HTML gabungan:

```bash
cd <workspace>
genhtml coverage/combined.info -o coverage/combined_html --source-directory apps/<app> --source-directory modules/<module> --ignore-errors empty,unused
open coverage/combined_html/index.html
```

Contoh konkret di `fsda-examples/FSDA-Base`:

```bash
cd /Users/flutter-delux/fsda/fsda-examples/FSDA-Base/modules/travel
flutter test --coverage
lcov --ignore-errors unused --remove coverage/lcov.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/lcov.info

cd /Users/flutter-delux/fsda/fsda-examples/FSDA-Base/apps/base_app
flutter test --coverage
lcov --ignore-errors unused --remove coverage/lcov.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/lcov.info

cd /Users/flutter-delux/fsda/fsda-examples/FSDA-Base
mkdir -p coverage
lcov -a modules/travel/coverage/lcov.info -a apps/base_app/coverage/lcov.info -o coverage/combined.info
lcov --ignore-errors unused --remove coverage/combined.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/combined.info
lcov --summary coverage/combined.info
genhtml coverage/combined.info -o coverage/combined_html --source-directory apps/base_app --source-directory modules/travel --ignore-errors empty,unused
open coverage/combined_html/index.html
```

Catatan:

* Placeholder seperti `<module_lcov.info>` harus diganti path nyata, jangan dipakai literal.
* Pastikan pola glob diapit tanda kutip agar shell tidak expand sebelum dibaca oleh `lcov`.
* Untuk cek file coverage yang tersedia, jalankan: `find modules apps -type f -path "*/coverage/lcov.info" | sort`.
* Pada monorepo, gunakan `--source-directory` untuk tiap root package agar `genhtml` bisa resolve path `lib/...` dengan benar.
* Jika suatu pola tidak punya match (misalnya belum ada file `freezed`), `lcov` dapat menampilkan warning `unused` dan ini aman.
* Disarankan HTML per package, sedangkan gabungan dipakai untuk summary angka.
* Jika module memakai package UI yang menggunakan Material icons, tambahkan `flutter.uses-material-design: true` di `pubspec.yaml` module supaya warning tidak muncul saat test dari root module.

## Referensi

* Gunakan aturan tiap layer, kontrak Use Case pada [Sequence Pattern](../architecture/sequence-pattern.md), serta contoh test yang tersedia pada repository sebagai acuan.

## What To Prioritize

Prioritaskan test pada area berikut:

* boundary yang rawan berubah
* error translation dari Data ke Domain
* state transition pada Logic
* flow App composition yang kritis

