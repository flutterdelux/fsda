# Testing Strategy

Dokumen ini mendefinisikan strategi testing praktis untuk proyek FSDA.

## Purpose

Testing strategy membantu memastikan tiap layer dapat diverifikasi tanpa mengaburkan boundary arsitektur.

## Hirarki Artefak Testing

Pada FSDA, acuan testing dibaca berurutan:

1. Sequence: acuan utama alur interaksi.
2. Blueprint: acuan utama bentuk implementasi kode.
3. Testing Blueprint: acuan utama desain automated test dari blueprint yang sudah diimplementasikan.

Urutan wajib: Sequence -> Blueprint -> Testing Blueprint.

Aturan boundary rujukan:

* Blueprint menerjemahkan dan membatasi Sequence menjadi kontrak implementasi.
* Automated test wajib menjadikan Blueprint sebagai acuan utama.
* Sequence tetap konteks hulu untuk Blueprint, bukan pengganti langsung Blueprint saat mendesain test.

## Prinsip Testing FSDA

* Terjemahkan sequence ke blueprint dulu, lalu turunkan test dari blueprint.
* Test berdasarkan ownership boundary tiap layer.
* Satu unit file produksi sebaiknya punya satu file test khusus (jika relevan).
* Validasi kontrak/behavior, bukan detail internal yang tidak penting.
* Jaga test tetap deterministik dan cepat sebagai default.
* Tambahkan kedalaman integration hanya pada area composition risk.
* Gunakan style BDD yang eksplisit dan mudah dibaca.

## Baseline Pilot Retrieval (Travel / Destination / Popular)

Pilot pertama yang dijadikan baseline adalah Retrieval (R) pada slice travel destination popular.

Ringkasan fokusnya:

| Scope | Fokus | Bentuk Test |
| --- | --- | --- |
| Module Domain | kontrak use case | `domain/usecases/*_use_case_test.dart` |
| Module Data | parsing response, mapping, translation error | `data/datasources/*_impl_test.dart`, `data/repositories/*_impl_test.dart` |
| Module Logic | state transition (loading, loaded, empty, failure) | `logic/<slice>/*_cubit_test.dart` |
| Module UI | perilaku widget per file ownership | `ui/<slice>/widgets/*_test.dart` dan `ui/<slice>/widgets/parts/*_test.dart` |
| App Integration | page orchestration + DI composition | `test/modules/.../*_widget_test.dart`, `test/modules/.../*_di_test.dart` |

## Matriks Testing Berbasis Layer

| Layer | Fokus Utama | Test yang Direkomendasikan | Yang Harus Dihindari |
| --- | --- | --- | --- |
| Domain | Rule bisnis dan kontrak | Unit test untuk use case, ekspektasi kontrak, dan behavior entity saat ada logic bisnis | Assertion framework/UI |
| Data | Mapping dan translasi teknis | Unit/contract test untuk mapping DTO-Entity, mapping request/response, translasi exception ke failure, behavior repository | Assertion UI dan state-flow |
| Logic | Orkestrasi state | Unit test untuk state transition dan orkestrasi use case | Assertion detail implementasi datasource |
| UI | Behavior presentasi | Widget test untuk render, interaction, visual loading/empty/error | Assertion repository dan transport |
| App | Wiring komposisi | Integration atau smoke test untuk route, wiring DI, komposisi module, komposisi localization | Mengulang rule bisnis level rendah |

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
* Logic: test untuk state transition dan orchestration logic
* UI: widget test untuk presentation dan interaction utama
* App: integration atau smoke test untuk composition, route, dan dependency wiring

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

## Sequence-Based Testing

Selain berdasarkan layer, testing juga mengikuti skenario sequence melalui kontrak yang sudah ditegaskan di blueprint.

### Checklist Skenario Minimum per Sequence

| Sequence | Skenario Minimum |
| --- | --- |
| Mutation (M) | success, failure, expected side effect |
| Mutation + Param (Mp) | valid param, invalid param, failure mapping |
| Mutation + Return (Mr) | success return payload, failure, side effect consistency |
| Mutation + Return + Param (Mrp) | valid param + return, invalid param path, failure mapping |
| Retrieval (R) | loading, loaded, empty, failure |
| Retrieval + Param (Rp) | valid param loaded, invalid param path, failure |
| Retrieval + Pagination (Rpag) | first page, append page, end-of-list, pagination failure |
| Retrieval + Stream (Rs) | initial emission, update emission, failure/close behavior |
| Retrieval + Stream + Param (Rsp) | valid param stream, update emission, failure/close behavior |
| Retrieval + Offline First (Rof) | local hit, remote fallback, cache update/sync behavior |

Contoh fokus pengujian tambahan:

* Mutation: input valid, input invalid, success flow, failure flow
* Mutation + Return: verifikasi hasil return dan side effect yang relevan
* Retrieval: success, empty state, failure, loading
* Retrieval + Pagination: page progression, append behavior, end-of-list behavior
* Retrieval + Stream: initial emission, update emission, failure emission bila relevan
* Retrieval + Offline First: local hit, remote fallback, sync behavior bila ada

## Struktur File Test yang Direkomendasikan

Mirror ownership produksi agar discovery test lebih mudah.

```text
modules/
└── <module>/
		└── test/
				└── src/
						└── features/
								└── <feature>/
										├── domain/usecases/<feature>_<slice>_use_case_test.dart
										├── data/repositories/<feature>_repository_impl_test.dart
										├── logic/<slice>/<feature>_<slice>_cubit_test.dart
										└── ui/<slice>/views/<feature>_<slice>_view_test.dart

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

## Definition Of Done per Slice

Sebuah slice dianggap test-complete ketika layer yang memang diimplementasikan pada slice tersebut memenuhi checklist minimum berikut:

* [ ] Domain: behavior success/failure pada use case ter-cover.
* [ ] Domain: behavior entity ter-cover jika entity memuat logic atau invariant bisnis.
* [ ] Data: parsing/mapping DTO, request, converter dan parsing kontrak response ter-cover jika unit tersebut ada.
* [ ] Data: jalur sukses/gagal datasource ter-cover jika datasource bagian dari slice.
* [ ] Data: behavior repository untuk mapping dan translasi exception ke failure ter-cover.
* [ ] Logic: state transition untuk skenario slice ter-cover.
* [ ] UI: state/interaksi widget kritis ter-cover per file ownership, termasuk widget `parts/` jika memuat kontrak visual/interaksi.
* [ ] App: smoke komposisi route/page serta registrasi/resolusi DI ter-cover jika slice menambah wiring app.
* [ ] Sequence checklist: skenario minimum sequence terkait ter-cover.

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
4. perluas module demi module, sequence demi sequence
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

## Referensi Specs

* Sequence: `specs/sequences/`
* Blueprint kode: `specs/blueprints/`
* Blueprint testing: [specs/tests/retrieval_test.md](/specs/tests/retrieval_test.md)

## What To Prioritize

Prioritaskan test pada area berikut:

* boundary yang rawan berubah
* error translation dari Data ke Domain
* state transition pada Logic
* flow App composition yang kritis

