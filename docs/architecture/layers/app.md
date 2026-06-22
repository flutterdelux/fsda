# App

App adalah layer tersembunyi yang mengorkestrasi Logic dan UI, routing management, dan kebutuhan lain yang tidak masuk ke dalam domain, logic, maupun UI.

Tidak dikategorikan sebagai layer utama sehingga bentuk layering tetap 4 bentuk, yaitu:

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```

```text
App mengetahui module.
Module tidak mengetahui App. 
```

Hubungan tersebut membuat App menjadi titik komposisi tertinggi dalam aplikasi.

&nbsp;

## Composition

UI dan Logic nantinya akan dikombinasikan oleh App.

Page pada App dapat merepresentasikan satu primary slice atau menjadi aggregate surface yang menggabungkan beberapa slice sekaligus.

Logic juga dapat diregistrasikan pada page scope atau scope yang lebih tinggi seperti root/global scope bila lifecycle dan kebutuhan composition mengharuskannya.

Contoh:

```text
ProductDetailPage
 ├── BlocProvider
 └── ProductDetailView
```

Routing management juga menjadi tanggung jawab App. Route tiap module disusun di App dengan grouping module masing-masing, kemudian digabungkan menjadi satu.

Contoh:

```dart
routes: [
    _mainRoute,
    DashboardRoute.base,
    InboxRoute.base,
    FinanceRoute.base,
    QueueRoute.base,
    TaskRoute.base,
    TravelRoute.base,
    ProductRoute.base,
    LocationRoute.base,
    AttendanceRoute.base,
    SubscriptionRoute.base,
    SettingsRoute.base,
    NoteRoute.base,
],
```

Localization composition juga menjadi tanggung jawab App. App menyusun localization umum dari `app_l10n` bersama localization milik module-module yang dipakai aplikasi.

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

Begitu juga dengan dependency injection, App bertanggung jawab untuk menginisialisasi dependency injection tiap module dan menggabungkannya menjadi satu.

```dart
Future<void> initDI() async {
  await externalDI();
  await coreDI();
  inboxDI();
  financeDI();
  queueDI();
  taskDI();
  travelDI();
  productDI();
  locationDI();
  attendanceDI();
  subscriptionDI();
  settingsDI();
  noteDI();
}
```

&nbsp;

## Dependency Rules

Allowed:

```text
modules
packages
external
```

Forbidden:

```text
other apps
```

&nbsp;

## Why This Layer Is Hidden

App tidak merepresentasikan concern bisnis maupun teknis tertentu. App hanya bertugas mengorkestrasi dan menyusun komponen yang berasal dari layer lain. Karena itu App tidak dikategorikan sebagai layer utama pada FSDA.

Tersembunyi namun penting. Sebutan hidden layer di sini adalah karena App yang bergantung ke layer-layer lain agar feature dapat diterapkan pada aplikasi dan digunakan user. Bentuk sebenarnya dari App adalah project utama aplikasinya. Project App bisa banyak dan cara compose-nya bisa berbeda-beda sehingga tidak dikategorikan sebagai layer utama.

