# UI Layer

The UI is the visual or display form that can be seen by the user and interacted with.

The UI is responsible for displaying information to the user.

The UI must focus on presentation.

The UI must not contain business orchestration.



## Responsibilities

The UI is responsible for providing:

* View
* Widget
* Other visual components

The UI is not responsible for:

* API
* Database
* Business Logic
* State Management



## UI Structure

Visuals tied to a slice are grouped within the slice. If the visual is shared, place it in shared.

```text
ui/
├── <slice>/
│   ├── views/
│   └── widgets/
└── shared/
```



## View

The View is the visual root for a feature slice.

Example:

```dart
class ProductDetailView extends StatelessWidget {
}
```

The View only receives data.

The View does not call the repository.

The View does not call the datasource.



## Widget

A Widget is a presentation component.

Example:

```dart
class ProductDetailCard extends StatelessWidget {
}
```



## Shared UI

Used by multiple slices within a feature.

Example:

```text
ui/
└── shared/
    ├── widgets/
    └── extensions/
```

Failure extensions to translate module failures into presentation needs are placed at the module scope:

```text
shared/
└── ui/
    └── extensions/
        └── <module>_failure_x.dart
```

If the UI in a module displays text to the user, the module should ideally have its own localization resource. `app_l10n` is still used for text that is general or shared across modules.



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



## Why This Layer Exists

The UI exists to present information to the user.



## Key Principle

The UI only displays data.

The UI does not orchestrate business.

The UI does not know about data implementation.

The UI is only allowed to know the domain models needed for presentation, not repository contracts or use cases.

The App Layer is responsible for composing the UI and Logic.