# Retrieval + Stream Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rs   | Retrieval + Stream            | attendance   | attendance  | list          | watchAttendanceList()    |


## Shared

::: code-group

```dart [attendance_failure.dart]
```

```dart [attendance_failure_x.dart]
```

```dart [attendance_exception.dart]
```

:::

## L10n

::: code-group

```arb [attendance_en.arb]
```

```arb [attendance_id.arb]
```

:::

## Domain Layer

::: code-group

```dart [attendance_enum.dart]
```

```dart [attendance_entity.dart]
```

```dart [attendance_param.dart]
```

```dart [attendance_repository.dart]
```

```dart [attendance_use_case.dart]
```

:::

## Data Layer

::: code-group

```dart [attendance_converter.dart]
```

```dart [attendance_dto.dart]
```

```dart [attendance_request.dart]
```

```dart [attendance_response.dart]
```

```dart [attendance_remote_data_source.dart]
```

```dart [attendance_remote_data_source_impl.dart]
```

```dart [attendance_repository_impl.dart]
```

:::

## Logic Layer

::: code-group

```dart [attendance_state.dart]
```

```dart [attendance_cubit.dart]
```

:::

## UI Layer

::: code-group

```dart [attendance_view.dart]
```

```dart [attendance_content.dart]
```

```dart [attendance_error_feedback.dart]
```

```dart [attendance_empty_feedback.dart]
```

```dart [attendance_skeleton.dart]
```

:::

## Barrel

::: code-group

```dart [attendance_feature.dart]
```

```dart [attendance.dart]
```

:::