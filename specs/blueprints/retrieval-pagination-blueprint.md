# Retrieval + Pagination Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rpag | Retrieval + Pagination        | location     | city        | list          | getCityList()            |


## Shared

::: code-group

```dart [location_failure.dart]
```

```dart [location_failure_x.dart]
```

```dart [location_exception.dart]
```

:::

## L10n

::: code-group

```arb [location_en.arb]
```

```arb [location_id.arb]
```

:::

## Domain Layer

::: code-group

```dart [city_enum.dart]
```

```dart [city_entity.dart]
```

```dart [city_param.dart]
```

```dart [city_repository.dart]
```

```dart [city_use_case.dart]
```

:::

## Data Layer

::: code-group

```dart [city_converter.dart]
```

```dart [city_dto.dart]
```

```dart [city_request.dart]
```

```dart [city_response.dart]
```

```dart [city_remote_data_source.dart]
```

```dart [city_remote_data_source_impl.dart]
```

```dart [city_repository_impl.dart]
```

:::

## Logic Layer

::: code-group

```dart [city_state.dart]
```

```dart [city_cubit.dart]
```

:::

## UI Layer

::: code-group

```dart [city_view.dart]
```

```dart [city_content.dart]
```

```dart [city_error_feedback.dart]
```

```dart [city_empty_feedback.dart]
```

```dart [city_skeleton.dart]
```

:::

## Barrel

::: code-group

```dart [city_feature.dart]
```

```dart [city.dart]
```

:::