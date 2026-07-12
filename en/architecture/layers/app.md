# App

App is a hidden composition layer that orchestrates Logic and UI, routing management, and concerns that do not belong to domain, logic, or UI directly.

It is not categorized as a primary layer, so the primary layering remains in four forms:

```text
Data  ─────┐
           │
Logic ─────┼──► Domain
           │
UI ────────┘
```

```text
App knows modules.
Modules do not know App.
```

This relation makes App the highest composition point in the application.

&nbsp;

## Composition

UI and Logic are composed by App.

A page in App may represent one primary slice or an aggregate surface combining multiple slices.

Logic can also be registered at page scope or higher scope (such as root/global) when lifecycle and composition needs require it.

Example:

```text
ProductDetailPage
 ├── BlocProvider
 └── ProductDetailView
```

Routing management is also App responsibility. Module routes are grouped per module, then merged together.

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

Localization composition is also App responsibility. App composes shared localization from `app_l10n` together with module localizations used by the application.

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

Dependency injection is also App responsibility. App initializes each module DI and merges them.

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

App does not represent specific business or technical concern. App only orchestrates and composes components from other layers, so it is not categorized as a primary FSDA layer.

Hidden but essential. Hidden layer here means App depends on other layers so features can be applied in an application and used by users. App is the main application project itself. Because there can be many App projects with different composition styles, App is not treated as a primary layer.
