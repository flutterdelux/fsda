# FSDA CLI Workflow

FSDA workflow with CLI for Development Speed, Clean code, and maintainability.

## Create Workspace

```bash
fsda workspace create <workspace_name>
```

generate:

```text
apps/
modules/
packages/
```

then: 

```bash
cd <workspace_name>
```

&nbsp;

## Setup Packages

```bash
fsda package init
```

```bash
fsda p init
```

generate:

```text
packages/
├── app_core/
├── app_l10n/
└── app_ui/
```

## Setup Infrastructure

FSDA punya template infrastructure. tinggal panggil nama infrastructure terdaftar maka akan langsung ditambahkan ke packages.

misal infra terdaftar:

| Contract                   | Name                     | Package                       | 
|----------------------------|--------------------------|-----------------------------------|
| Api Client                 | http                     | infra_http                        |
| Api Client                 | dio                      | infra_dio                         |
||||
| Database                   | supabase                 | infra_supabase                    |
| Database                   | firebase                 | infra_firebase                    |
||||
| Secure Storage             | flutter_secure_storage   | infra_flutter_secure_storage      |
||||
| Local Storage              | shared_preferences       | infra_shared_preferences          |
| Local Storage              | hive                     | infra_hive                        |
||||
| Logger                     | logging                  | infra_logging                     |
||||
| Database Client            | sqflite                  | infra_sqflite                     |
||||
| Network Info               | connectivity             | infra_connectivity                |

Check available infra:

```bash
fsda infra --list
```

```bash
fsda infra add <name>, <name>, <name>...
```

Example:

```bash
fsda infra add dio, connectivity
```

generate:

```text
packages/
├── infra_dio/
└── infra_connectivity/
```

Nanti class Impl nya didaftarkan ke core_di dan teknologinya didaftarkan ke external_di di apps yang dituju.

&nbsp;

## Create App

```bash
fsda app create <app_name>
```

Example:

```bash
fsda app create fsda_base
```

generate:

```text
fsda-base/
├── apps/
│   └── fsda_base/
│       ├── analysis_options.yaml
│       ├── flutter_launcher_icons.yaml
│       ├── package_rename_config.yaml
│       ├── pubspec.yaml
│       ├── assets/
│       │   └── images/
│       │       ├── launcher_icon-foreground.png
│       │       └── launcher_icon.png
│       └── lib/
│           ├── main.dart
│           ├── app/
│           │   ├── app_router.dart
│           │   ├── main_app.dart
│           │   ├── startup.dart
│           │   └── dashboard/
│           │       ├── dashboard_route.dart
│           │       ├── pages/
│           │       │   ├── dashboard.dart
│           │       │   └── home_page.dart
│           │       └── widgets/
│           │           └── bottom_nav_bar.dart
│           ├── core/
│           │   ├── constants/
│           │   │   └── app_external_links.dart
│           │   ├── di/
│           │   │   ├── core_di.dart
│           │   │   ├── di.dart
│           │   │   ├── di_keys.dart
│           │   │   └── external_di.dart
│           │   ├── extensions/
│           │   │   └── failure_x.dart
│           │   ├── externals/
│           │   │   └── <external>_config.dart
│           │   ├── mixins/
│           │   │   └── page_provider_mixin.dart
│           │   └── pages/
│           │       ├── invalid_argument_page.dart
│           │       └── not_found_page.dart
│           └── modules/
```

Setelah app project di create, lakukan penyesuaian resource untuk kebutuhan launcher icon dan edit flutter_launcher_icons.yaml serta edit package_rename_config.yaml. Kemudian jalankan command:

```bash
# 1. Apply the new package name and bundle identifiers
dart run package_rename

# 2. Generate the native platform launcher icons
dart run flutter_launcher_icons
```

then test run app:

```bash
flutter run
```


## Create Module

```bash
fsda module create <module>
```

```bash
fsda m create <module>
```

Example:

```bash
fsda module create finance
```

generate:

```text
modules/
├── finance/
│   ├── analysis_options.yaml
│   ├── build.yaml
│   ├── l10n.yaml
│   ├── pubspec.yaml
│   └── lib/
│       ├── finance.dart
│       ├── l10n/
│       │   ├── finance_en.arb
│       │   └── finance_id.arb
│       └── src/
│           ├── features/
│           ├── generated/
│           └── shared/
│               ├── data/
│               │   └── errors/
│               │       └── finance_exception.dart
│               ├── domain/
│               │   └── errors/
│               │       └── finance_failure.dart
│               ├── logic/
│               └── ui/
│                   └── extensions/
│                       └── finance_failure_x.dart
```

isi finance.dart sebagai module barrel
```dart
export 'src/shared/data/errors/finance_exception.dart';
export 'src/shared/domain/errors/finance_failure.dart';
export 'src/shared/ui/extensions/finance_failure_x.dart';
```

## Compose Module

```bash
fsda module compose --m <module> --app <app_name>
```

```bash
fsda m compose --m <module> --app <app_name>
```

Example:

```bash
fsda module compose --m finance --app fsda_base
```

generated presentation compose:

```text
fsda-base/
├── apps/
│   └── fsda_base/
│       └── lib/
│           ├── main.dart
│           ├── app/
│           │   ├── main_app.dart (register l10n here)
│           │   └── app_router.dart (register module route here)
│           ├── core/
│           │   ├── di/
│           │   │   ├── di.dart (register module di here)
│           │   │   └── di_keys.dart
│           │   └── extensions/
│           │       └── failure_x.dart (register module failure x here)
│           └── modules/
│               └── finance/
│                   ├── finance_di.dart (module di entry point)
│                   ├── finance_route.dart (module router entry point)
│                   └── features/
```

  * module route entry point

    ```dart
    class FinanceRoute {
      static const finance = 'finance';

      static RouteBase get base => GoRoute(
        path: '/finance',
        name: finance,
        builder: (context, state) => const NotFoundPage(),
        routes: [
        ],
      );
    }
    ```

  * register route
    ```dart
    class AppRouter {
      static const startupPath = '/';

      late final router = GoRouter(
        initialLocation: startupPath,
        errorBuilder: (context, state) => const NotFoundPage(),
        routes: [
          ...
          FinanceRoute.base, // register route module here
        ],
      );
    }
    ```
  * module di entry point
    ```dart
    class FinanceDi {
      static void init(GetIt sl) {
        _walletDi(sl);
      }

      // feature di entry point (e.g. wallet)
      static void _walletDi(GetIt sl) {
        // Datasources

        // Repositories

        // UseCases

        // Logics
      }
    }
    ```
  * register di
    ```dart
    final sl = GetIt.instance;

    Future<void> initDI() async {
      ...
      financeDI(sl); // register di module here
    }
    ```
  * register failure x
    ```dart
    extension FailureX on Failure {
      String localizeAny(BuildContext context) {
        final l10n = context.l10n!;

        ...

        // register failure module here
        if (this is FinanceFailure) {
          return (this as FinanceFailure).localize(context);
        }

        return l10n.unknownError;
      }
    }
    ```
  * register l10n
    ```dart
    localizationsDelegates: [
      ...AppLocalizations.localizationsDelegates,
      ...FinanceLocalizations.localizationsDelegates, // register l10n module here
    ],
    ```

&nbsp;

## Create Feature

```bash
fsda feature create --f <feature> --m <module>
```

Example:

```bash
fsda feature create --f wallet --m finance
```

generate:

```text
├── modules/
│   ├── finance/
│   │   ├── finance.dart (export wallet_feature.dart)
│   │   └── lib/
│   │       └── src/
│   │           ├── features/
│   │           │   └── wallet/
│   │           │       ├── wallet_feature.dart (feature barrel)
│   │           │       ├── data/
│   │           │       │   ├── converters/
│   │           │       │   ├── datasources/
│   │           │       │   ├── dtos/
│   │           │       │   ├── repositories/
│   │           │       │   ├── requests/
│   │           │       │   └── responses/
│   │           │       ├── domain/
│   │           │       │   ├── entities/
│   │           │       │   ├── enums/
│   │           │       │   ├── params/
│   │           │       │   ├── repositories/
│   │           │       │   └── usecases/
│   │           │       ├── logic/
│   │           │       └── ui/
```

then update module barrel
```dart
export 'src/features/wallet/wallet_feature.dart';

...
```

## Create Slice

Show avilable Sequence types:

```bash
fsda sequence --list
```

```bash
fsda seq --list
```


```bash
fsda slice create \
  --module <module> \
  --feature <feature> \
  --slice <slice> \
  --sequence <sequence_code>
```

```bash
fsda s create --m <module> --f <feature> --s <slice> --seq <sequence_code>
```

Example:

```bash
fsda s create --m finance --f wallet --s delete --seq Mp
```

CLI membaca:

templates/blueprints/mutation-param-blueprint.md

lalu generate (tergantung template blueprint):

- delete_wallet_param.dart using freezed
- method deleteWallet() pada repository interface, jika belum ada repository interface maka akan dibuatkan repository interface pada folder domain/repositories/
- wallet_delete_use_case.dart
- delete_wallet_request.dart using freezed
- method deleteWallet(request) pada datasource interface dan datasource implementation, jika belum ada datasource interface dan datasource implementation maka akan dibuatkan datasource interface dan datasource implementation pada folder data/datasources/
- method deleteWallet(param) pada repository implementation, jika belum ada repository implementation maka akan dibuatkan repository implementation pada folder data/repositories/
- logic/delete/wallet_delete_cubit.dart
- logic/delete/wallet_delete_state.dart using freezed
- ui/delete/views/
- ui/delete/widgets/

dll.

## Compose Feature DI

```bash
fsda feature di --module <module> --feature <feature> --app <app_name>
```

```bash
fsda f di --m <module> --f <feature> --app <app_name>
```

Example: 

```bash
fsda f di --m finance --f wallet --app fsda_base
```

yang di register ada 4 group: datasources, repositories, usecases, logics

scan ada datasource apa saja di finance/wallet
scan ada repository apa saja di finance/wallet
scan ada usecase apa saja di finance/wallet
scan ada logic apa saja di finance/wallet

kemudian tambahkan ke 

module di entry point di app yang dituju

```dart
class FinanceDi {
  static void init(GetIt sl) {
    _walletDi(sl);
  }

  // feature di entry point (e.g. wallet)
  static void _walletDi(GetIt sl) {
    // Datasources
    sl.registerLazySingleton<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImpl(
        apiClient: sl(),
      ),
    );

    // Repositories
    sl.registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(
        walletRemoteDataSource: sl(),
        appLogger: sl(param1: 'WalletRepository'),
      ),
    );

    // Usecases
    sl.registerLazySingleton(() => WalletDeleteUseCase(walletRepository: sl()));
    // others usecases ...

    // Logics
    sl.registerFactory(() => WalletDeleteCubit(walletDeleteUseCase: sl()));
    // others logics ...
  }

  // others feature di entry point ...
}
```
