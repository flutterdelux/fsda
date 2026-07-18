# Retrieval Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| R    | Retrieval                     | travel       | destination | popular       | getPopularDestination()  |


## Shared

::: code-group

```dart [travel_failure.dart]
```

```dart [travel_failure_x.dart]
```

```dart [travel_exception.dart]
```

:::

## L10n

::: code-group

```arb [travel_en.arb]
```

```arb [travel_id.arb]
```

:::

## Domain Layer

::: code-group

```dart [destination_enum.dart]
```

```dart [destination_entity.dart]
```

```dart [destination_param.dart]
```

```dart [destination_repository.dart]
```

```dart [destination_use_case.dart]
```

:::

## Data Layer

::: code-group

```dart [destination_converter.dart]
```

```dart [destination_dto.dart]
```

```dart [destination_request.dart]
```

```dart [destination_response.dart]
```

```dart [destination_remote_data_source.dart]
```

```dart [destination_remote_data_source_impl.dart]
```

```dart [destination_repository_impl.dart]
```

:::

## Logic Layer

::: code-group

```dart [destination_state.dart]
```

```dart [destination_cubit.dart]
```

:::

## UI Layer

::: code-group

```dart [destination_view.dart]
```

```dart [destination_content.dart]
```

```dart [destination_error_feedback.dart]
```

```dart [destination_empty_feedback.dart]
```

```dart [destination_skeleton.dart]
```

:::

## Barrel

::: code-group

```dart [destination_feature.dart]
```

```dart [travel.dart]
```

:::