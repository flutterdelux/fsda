# Getting Started CLI-Driven E2E - Wikuy

This document guides the creation of an end-to-end FSDA project mostly through the FSDA CLI, followed by manual finalization as necessary.

## Target Output

- Workspace: `Wikuy-CLI`
- App: `wikuy`
- Module: `travel`
- Feature: `destination`
- Slice: `list`
- Sequence: `R`
- UI: `lsv`
- Compose target page: `destination_list_page`
- Generated main page class: `DestinationListPage`
- API source: `GET /destinations`

## Prerequisites

- Flutter SDK and Dart SDK installed
- `fsda` command available in terminal

## 1. Create Workspace

Run this outside any workspace:

```bash
fsda create Wikuy-CLI
cd Wikuy-CLI
```

## 2. Setup Workspace Foundation

Adjust fsda.yaml to use infra_http and infra_logging and run configure. Or you can use the following commands:

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

Make adjustments to the App ID and launcher icon then run the following command:

```bash
cd apps/wikuy
dart run package_rename
dart run flutter_launcher_icons
cd ../../
```

Adjust the baseUrl for the ApiClient in core_di.dart:

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

Explanation:

- `--ds remote`: because the data source is a public API
- `-s R`: retrieval sequence
- `-d getDestinationList`: retrieval method name
- `-u lsv`: vertical list UI bundle

Adjust the path in the data source getDestinationList:


::: code-group
```dart [destination_remote_data_source_impl.dart]
final response = await _apiClient.get<Map<String, dynamic>>(
   '/destinations',
);
```
:::

And adjust the UI:

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

## 5. Register Module and Install Feature DI

```bash
fsda reg travel -a wikuy
fsda di destination -m travel -a wikuy
```

## 6. Compose Slice to Page

`compose-main` is used to generate the page wrapper with a skeleton view from the slice list, and the target page is `destination_list_page.dart`:

```bash
fsda compose-main list -f destination -m travel -a wikuy -p destination_list_page
```

Main compose output:

- generates app wrapper page `DestinationListPage`
- injects retrieval cubit provider
- updates app wrapper route wiring

## 7. Create Navigation Button to Destination List

Open the Home page in the App (`apps/wikuy/lib/app/dashboard/pages/home_page.dart`) and add navigation to the slice that was just *composed*.

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

If there are imports that do not comply with linting and cause IDE warnings, run the following command to fix them:

```bash
fsda fix-import -m travel -a wikuy
```

## 9. Result

| Startup | Home Page | Destination List |
|:---------:|:---------:|:------------------:|
| ![img](public/startup.png) | ![img](public/home.png) | ![img](public/destination-list.png) |

## One Shot Command

Use the following command to run the entire process above in a single command line, then make manual adjustments as needed.

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