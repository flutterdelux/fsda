# Retrieval + Offline First Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rof  | Retrieval + Offline First     | note         | note        | list          | getNoteList()            |


## Shared

::: code-group

```dart [note_failure.dart]
```

```dart [note_failure_x.dart]
```

```dart [note_exception.dart]
```

:::

## L10n

::: code-group

```arb [note_en.arb]
```

```arb [note_id.arb]
```

:::

## Domain Layer

::: code-group

```dart [note_enum.dart]
```

```dart [note_entity.dart]
```

```dart [note_param.dart]
```

```dart [note_repository.dart]
```

```dart [note_use_case.dart]
```

:::

## Data Layer

::: code-group

```dart [note_converter.dart]
```

```dart [note_dto.dart]
```

```dart [note_request.dart]
```

```dart [note_response.dart]
```

```dart [note_remote_data_source.dart]
```

```dart [note_remote_data_source_impl.dart]
```

```dart [note_repository_impl.dart]
```

:::

## Logic Layer

::: code-group

```dart [note_state.dart]
```

```dart [note_cubit.dart]
```

:::

## UI Layer

::: code-group

```dart [note_view.dart]
```

```dart [note_content.dart]
```

```dart [note_error_feedback.dart]
```

```dart [note_empty_feedback.dart]
```

```dart [note_skeleton.dart]
```

:::

## Barrel

::: code-group

```dart [note_feature.dart]
```

```dart [note.dart]
```

:::