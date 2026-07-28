# app_l10n

Foundation package for localization and language resources shared across applications.

## Purpose

`app_l10n` centralizes cross-application text management so localization is not scattered across App, Module, or specific widgets.

`app_l10n` is not a replacement for module localization. It serves as shared localization foundation at app/system level.

## Typical Responsibilities

Examples of resources suitable for `app_l10n`:

* localization resources and generated localization outputs
* translation key/access patterns
* shared localized messages used across modules
* locale and fallback locale configuration used across applications

## Shared L10n vs Module L10n

Responsibility split:

* `app_l10n` stores general/shared localization used across many modules
* each module can and usually should maintain its own localization for module-specific UI text

If a module renders user-facing text, the module should own its l10n resources so text ownership stays near module boundary.

## Module L10n Baseline

Recommended baseline for modules with UI text:

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

Example module `l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: <module>_en.arb
output-localization-file: <module>_localizations.dart
output-class: <Module>Localizations
output-dir: lib/src/generated
untranslated-messages-file: missing_keys.json
```

## Good Candidates

Place resources in `app_l10n` when they:

* are directly related to language or translation
* are shared by more than one module or app
* do not carry specific business feature ownership

## Not For

`app_l10n` is not for:

* business rules
* UI widgets
* datasource or repository
* messages relevant only to one feature/module and not yet cross-boundary

## Dependency Position

`app_l10n` can be used by App and Module when shared localization resources are needed.

Keep system-wide localization here so language changes do not stick to specific feature implementations.

For truly module-specific text, keep localization in that module.

In current Flutter baseline, modules commonly depend on `app_l10n` for general localization used across apps/modules.

## Composition In App

App is responsible for composing shared localization from `app_l10n` with module localization used by the application.

With this pattern:

* `app_l10n` remains shared localization foundation
* modules keep ownership of boundary-specific UI text
* App becomes final composition point for delegates, locales, and root localization needs

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
