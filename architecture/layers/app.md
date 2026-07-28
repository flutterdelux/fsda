# App

The App is a hidden layer that orchestrates Logic and UI, routing management, and other necessities that do not fall under the domain, logic, or UI layers.

It is not categorized as a main layer, keeping the layering structure at 4 forms, which are:

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```

```text
The App knows the module.
The module does not know the App. 
```

This relationship makes the App the highest composition point in the application.



## Composition

UI and Logic will eventually be combined by the App.

A Page in the App can represent one primary slice or become an aggregate surface that combines several slices at once.

Logic can also be registered at the page scope or a higher scope such as the root/global scope if the lifecycle and composition needs require it.

Example:

```text
ProductDetailPage
 ├── BlocProvider
 └── ProductDetailView
```

Routing management is also the responsibility of the App. The route of each module is arranged in the App by grouping each module, then combined into one.

Example:

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

Localization composition is also the responsibility of the App. The App arranges general localization from `app_l10n` along with localizations belonging to the modules used by the application.

Example:

```dart
MaterialApp(
  localizationsDelegates: [
    AppLocalizations.delegate,
    ProductLocalizations.delegate,
    FinanceLocalizations.delegate,
  ],
)
```

Likewise, with dependency injection, the App is responsible for initializing the dependency injection of each module and combining them into one.

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



## Why This Layer Is Hidden

The App does not represent a specific business or technical concern. The App is only tasked with orchestrating and arranging components from other layers. Therefore, the App is not categorized as a main layer in FSDA.

Hidden but important. The term hidden layer here is because the App depends on other layers so that features can be applied to the application and used by the user. The actual form of the App is the main project of the application. There can be many App projects and the way they are composed can be different, so it is not categorized as a main layer.