# Retrieval + Param Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rp   | Retrieval + Param             | product      | product     | detail        | getProductDetail()       |


## Shared

::: code-group

```dart [product_failure.dart]
```

```dart [product_failure_x.dart]
```

```dart [product_exception.dart]
```

:::

## L10n

::: code-group

```dart [product_en.arb]
```

```dart [product_id.arb]
```

:::

## Domain Layer

::: code-group

```dart [product_entity.dart]
```

```dart [product_enum.dart]
```

```dart [product_param.dart]
```

```dart [product_repository.dart]
```

```dart [product_use_case.dart]
```

:::

## Data Layer

::: code-group

```dart [product_converter.dart]
```

```dart [product_data_source.dart]
```

```dart [product_data_source_impl.dart]
```

```dart [product_dto.dart]
```

```dart [product_repository_impl.dart]
```

```dart [product_request.dart]
```

```dart [product_response.dart]
```

:::

## Logic Layer

::: code-group

```dart [product_state.dart]
```

```dart [product_cubit.dart]
```

:::

## UI Layer

::: code-group

```dart [product_view.dart]
```

```dart [product_content.dart]
```

```dart [product_error_feedback.dart]
```

```dart [product_empty_feedback.dart]
```

```dart [product_skeleton.dart]
```

:::

## Barrel

::: code-group

```dart [product_feature.dart]
```

```dart [product.dart]
```

:::