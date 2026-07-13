# CLI-Driven E2E Getting Started (Mostly CLI) - Wikuy

This document guides the creation of an end-to-end FSDA project mostly through the FSDA CLI, followed by manual finalization as necessary.

## Target Output

- Workspace: `Wikuy`
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

If you use local source from this repository:

```bash
cd fsda_cli
dart pub global activate --source path .
```

## 1) Create Workspace

Run this outside any workspace:

```bash
fsda create Wikuy
cd Wikuy
```

## 2) Setup Workspace Foundation

```bash
fsda configure
fsda add-pckg infra_http
fsda add-pckg infra_logging
```

`infra_logging` is optional, but commonly used for early tracing.

## 3) Generate App

```bash
fsda gen-app wikuy
fsda configure-app wikuy
```

Optional app branding/icon finalization:

```bash
cd apps/wikuy
dart run package_rename
dart run flutter_launcher_icons
cd ../../
```

## 4) Generate Module, Feature, Slice

```bash
fsda gen-module travel
fsda gen-feature destination -m travel --ds remote
fsda gen-slice list -f destination -m travel -s R -d getDestinationList -u lsv
```

Explanation:

- `--ds remote`: because the data source is a public API
- `-s R`: retrieval sequence
- `-u lsv`: vertical list UI bundle

## 5) Register Module and Install Feature DI

```bash
fsda reg travel -a wikuy
fsda di destination -m travel -a wikuy
```

## 6) Compose Main Page

```bash
fsda compose-main list -f destination -m travel -a wikuy -p destination_list_page
```

Main compose output:

- generates app wrapper page `DestinationListPage`
- injects retrieval cubit provider
- auto-bootstraps retrieval method in provider create
- updates app wrapper route wiring

## 7) Manual Finalization (Small but Important)

After all baselines are generated, perform the following manual finalizations:

1. Ensure remote datasource points to the public endpoint:
   - docs URL: `https://fdelux-mock-545621765686.asia-southeast2.run.app/docs/api/v1/#/Destinations`
   - runtime endpoint: `GET https://fdelux-mock-545621765686.asia-southeast2.run.app/api/v1/destinations`

   ::: code-group
   ```dart [core_di.dart]
   baseUrl: FDeluxMockConfig.cloudRunBaseUrl,
   ```
   :::

2. Adjust the path and response parsing in datasource/repository if the API payload shape changes.

   ::: code-group
   ```dart [destination_remote_data_source_impl.dart]
   final response = await _apiClient.get<Map<String, dynamic>>(
      '/destinations',
   );
   ```
   :::

3. Polish the list item UX (title/subtitle, empty, error, skeleton) on the generated UI widgets.

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

4. Ensure the home/dashboard app calls the `DestinationListPage` route. You can do this by creating navigation from home to the destination list, or by making the destination list the home page.

   ::: code-group
   ```dart [home_page.dart]
   FilledButton(
      onPressed: () {
         TravelRoute.toDestinationList(context);
      },
      child: const Text('Destination List'),
   ),
   ```
   :::

5. Tidy up import ordering and analyzer warnings that do not affect behavior.

   ```bash
   fsda fix-import -m travel -a wikuy_cli_app
   ```

## 8) Validate

```bash
cd apps/wikuy
flutter pub get
flutter run
```

Quality gate:

```bash
dart analyze
```

## 9) Result Screenshots

| Startup | Home Page | Destination List |
|:---------:|:---------:|:------------------:|
| ![img](public/startup.png) | ![img](public/home.png) | ![img](public/destination-list.png) |

## One Shot Command

```bash
fsda create Wikuy-CLI && \
cd Wikuy-CLI && \
fsda configure && \
fsda add-pckg infra_http && \
fsda add-pckg infra_logging && \
fsda gen-app wikuy_cli_app && \
fsda configure-app wikuy_cli_app && \
cd apps/wikuy_cli_app && \
dart run package_rename && \
dart run flutter_launcher_icons && \
cd ../../ && \
fsda gen-module travel && \
fsda gen-feature destination -m travel --ds remote && \
fsda gen-slice list -f destination -m travel -s R -d getDestinationList -u lsv && \
fsda reg travel -a wikuy_cli_app && \
fsda di destination -m travel -a wikuy_cli_app && \
fsda compose-main list -f destination -m travel -a wikuy_cli_app -p destination_list_page
```

## Summary of This Path

- The main architectural process is handled by the FSDA CLI.
- Manual work is focused on finalization for API integration, UX polish, and cleanup.
- This is the fastest path to bootstrap a new project while remaining FSDA-compliant.