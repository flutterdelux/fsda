# UI Layer

UI is the visual surface users can see and interact with.

UI is responsible for presenting information to users.

UI must focus on presentation.

UI must not contain business orchestration.

&nbsp;

## Responsibilities

UI is responsible for providing:

* View
* Widget
* other visual components

UI is not responsible for:

* API
* Database
* Business Logic
* State Management

&nbsp;

## UI Structure

Visual resources tied to a slice are grouped in that slice. If reused, place them in shared.

```text
ui/
├── <slice>/
│   ├── views/
│   └── widgets/
└── shared/
```

&nbsp;

## View

View is root visual for a feature slice.

Example:

```dart
class ProductDetailView extends StatelessWidget {
}
```

View receives data only.

View does not call repository.

View does not call datasource.

&nbsp;

## Widget

Widget is a presentation component.

Example:

```dart
class ProductDetailCard extends StatelessWidget {
}
```

&nbsp;

## Shared UI

Used by multiple slices inside one feature.

Example:

```text
ui/
└── shared/
    ├── widgets/
    └── extensions/
```

Failure extension used to map module failures for presentation needs is placed at module scope:

```text
shared/
└── ui/
    └── extensions/
        └── <module>_failure_x.dart
```

If module UI displays text to users, that module should maintain its own localization resources. `app_l10n` is still used for general/shared cross-module text.

&nbsp;

## Dependency Rules

Allowed:

```text
domain/ (entity, enum, param only)
ui/
flutter/
app_ui/
```

Forbidden:

```text
data/
logic/
```

&nbsp;

## Why This Layer Exists

UI exists to present information to users.

&nbsp;

## Key Principle

UI only presents data.

UI does not orchestrate business.

UI does not know data implementation.

UI should only know domain models needed for presentation, not repository contracts or use cases.

App Layer is responsible for composing UI and Logic.
