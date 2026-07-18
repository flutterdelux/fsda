# Retrieval + Stream + Param Blueprint

| Code | Sequence                      | Module       | Feature     | Feature Slice | Example Method           |
| ---- | ----------------------------- | ------------ | ----------- | ------------- | ------------------------ |
| Rsp  | Retrieval + Stream + Param    | subscription | payment     | status        | watchPaymentStatus()     |

## Shared

::: code-group

```dart [subscription_failure.dart]
```

```dart [subscription_failure_x.dart]
```

```dart [subscription_exception.dart]
```

:::

## L10n

::: code-group

```arb [subscription_en.arb]
```

```arb [subscription_id.arb]
```

:::

## Domain Layer

::: code-group

```dart [payment_enum.dart]
```

```dart [payment_entity.dart]
```

```dart [payment_param.dart]
```

```dart [payment_repository.dart]
```

```dart [payment_use_case.dart]
```

:::

## Data Layer

::: code-group

```dart [payment_converter.dart]
```

```dart [payment_dto.dart]
```

```dart [payment_request.dart]
```

```dart [payment_response.dart]
```

```dart [payment_remote_data_source.dart]
```

```dart [payment_remote_data_source_impl.dart]
```

```dart [payment_repository_impl.dart]
```

:::

## Logic Layer

::: code-group

```dart [payment_state.dart]
```

```dart [payment_cubit.dart]
```

:::

## UI Layer

::: code-group

```dart [payment_view.dart]
```

```dart [payment_content.dart]
```

```dart [payment_error_feedback.dart]
```

```dart [payment_empty_feedback.dart]
```

```dart [payment_skeleton.dart]
```

:::

## Barrel

::: code-group

```dart [payment_feature.dart]
```

```dart [payment.dart]
```

:::