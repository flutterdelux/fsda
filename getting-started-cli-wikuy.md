# Getting Started CLI-Driven E2E - Wikuy

Dokumen ini memandu pembuatan project FSDA end-to-end dengan mayoritas proses melalui FSDA CLI, lalu finalisasi manual seperlunya.

## Target Hasil

- Workspace: `Wikuy-CLI`
- App: `wikuy`
- Module: `travel`
- Feature: `destination`
- Slice: `list`
- Sequence: `R`
- UI: `lsv`
- Method: `getDestinationList`
- Compose target page: `destination_list_page`
- API source: `GET /destinations`

## Prasyarat

- Flutter SDK dan Dart SDK terpasang
- `fsda` command tersedia di terminal

## 1. Setup Workspace

Jalankan di luar workspace:

```bash
fsda create Wikuy-CLI
cd Wikuy-CLI
```

## 2. Setup Workspace Foundation

Sesuaikan fsda.yaml agar menggunakan infra_http dan infra_logging dan jalankan configure. Atau bisa dengan command berikut:

```bash
fsda configure
fsda add-pckg infra_http
fsda add-pckg infra_logging
```

## 3. Setup App

```bash
fsda gen-app wikuy
fsda configure-app wikuy
```

Lakukan penyesuaian App ID dan launcher icon kemudian jalankan command berikut:

```bash
cd apps/wikuy
dart run package_rename
dart run flutter_launcher_icons
cd ../../
```

Penyesuaian baseUrl untuk ApiClient di core_di.dart:

::: code-group
```dart [core_di.dart] {2,6}
...
import '../externals/fdelux_mock_config.dart';
...

...
baseUrl: FDeluxMockConfig.cloudRunBaseUrl,
...
```
:::

## 4. Generate Module, Feature, Slice


```bash
fsda gen-module travel
fsda gen-feature destination -m travel --ds remote
fsda gen-slice list -f destination -m travel -s R -d getDestinationList -u lsv
```

Penjelasan:

- `--ds remote`: karena data source dari public API
- `-s R`: retrieval sequence
- `-d getDestinationList`: retrieval method name
- `-u lsv`: vertical list UI bundle

Lakukan penyesuaian untuk path di data source getDestinationList:

::: code-group
```dart [destination_remote_data_source_impl.dart]
final response = await _apiClient.get<Map<String, dynamic>>(
   '/destinations',
);
```
:::

Dan penyesuian untuk UI:

::: code-group
```dart [destination_list_item.dart]
return AppListTile(
   leading: AppNetworkImage(
      url: destination.imageUrl,
      width: 48,
      height: 48,
      borderRadius: BorderRadius.circular(8),
   ),
   title: destination.name,
   subtitle: destination.description,
   includeChevron: true,
   onTap: onTap,
);
```
:::

## 5. Register Module dan Feature DI ke App

```bash
fsda reg travel -a wikuy
fsda di destination -m travel -a wikuy
```

## 6. Compose Slice ke Page

`compose-main` digunakan untuk mengenerate page wrapper dengan skeleton view dari slice list, dan target page nya adalah `destination_list_page.dart`:

```bash
fsda compose-main list -f destination -m travel -a wikuy -p destination_list_page
```

Hasil compose utama:

- generate page app wrapper `DestinationListPage`
- inject provider cubit retrieval
- update route module app wrapper

## 7. Buat Button Navigasi ke Destination List

Buka halaman Home di App (`apps/wikuy/lib/app/dashboard/pages/home_page.dart`) dan tambahkan navigasi menuju slice yang baru saja di-*compose*.

::: code-group

```dart [home_page.dart] {1,8-13}
import '../../../modules/travel/travel_route.dart';

...

body: ListView(
  padding: const EdgeInsets.all(AppSpacing.screen),
  children: [
    FilledButton(
      onPressed: () {
        TravelRoute.toDestinationList(context);
      },
      child: const Text('Destination List'),
    ),
  ],
),

...
```

:::

## 8. Run & Cleanup

```bash
cd apps/wikuy
flutter run
```

Jika ada import yang tidak seuai linting sehingga memunculkan IDE warning, jalankan perintah berikut untuk perbaikan:

```bash
fsda fix-import -m travel -a wikuy
```

## 9. Result

| Startup | Home Page | Destination List |
|:---------:|:---------:|:------------------:|
| ![img](/images/startup.png) | ![img](/images/home.png) | ![img](/images/destination-list.png) |

## One Shot Command

Gunakan perintah berikut untuk menjalankan seluruh proses di atas dalam satu baris perintah, kemudian lakukan pemolesan manual seperlunya.

```bash
fsda create Wikuy-CLI && \
cd Wikuy-CLI && \
fsda configure && \
fsda add-pckg infra_http && \
fsda add-pckg infra_logging && \
fsda gen-app wikuy && \
fsda configure-app wikuy && \
cd apps/wikuy && \
dart run package_rename && \
dart run flutter_launcher_icons && \
cd ../../ && \
fsda gen-module travel && \
fsda gen-feature destination -m travel --ds remote && \
fsda gen-slice list -f destination -m travel -s R -d getDestinationList -u lsv && \
fsda reg travel -a wikuy && \
fsda di destination -m travel -a wikuy && \
fsda compose-main list -f destination -m travel -a wikuy -p destination_list_page
```