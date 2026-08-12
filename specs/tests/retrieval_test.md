# Retrieval Test (R)

| Code | Sequence | Blueprint | Test Document |
| --- | --- | --- | --- |
| R | Retrieval | travel / destination / popular | Retrieval automated test examples |

This document provides automated testing examples derived from the Retrieval blueprint implementation.

All code snippets in this document are copied from tests that already exist in `fsda-examples/FSDA-Base/`.
For full scenarios and full setup, open the referenced test files in that repository.

Flow for developer usage:

1. Read sequence to understand interaction flow.
2. Read blueprint to understand implementation shape and boundary contracts.
3. Read this test document to implement automated tests derived from that blueprint.

## Shared

### travel_failure.dart

`TravelFailure` is a pure enum without behavior.

Testing policy:

* no dedicated unit test is required for the enum alone
* behavior using this enum is validated through `travel_failure_x_test.dart` and `travel_exception_test.dart`

### travel_failure_x.dart

Test file:

* `fsda-examples/FSDA-Base/modules/travel/test/src/shared/ui/extensions/travel_failure_x_test.dart`

Example:

```dart
testWidgets('Given destinationNotFound failure, '
    'When localize is called, '
    'Then localized message is returned', (tester) async {
  late String localized;

  await tester.pumpWidget(
    _buildTestApp(
      Builder(
        builder: (context) {
          localized = TravelFailure.destinationNotFound.localize(context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );

  expect(localized, 'Destination not found');
});
```

### travel_exception.dart

Test file:

* `fsda-examples/FSDA-Base/modules/travel/test/src/shared/data/errors/travel_exception_test.dart`

Example:

```dart
test(
  'Given AppException input, '
  'When fromException is called, '
  'Then same exception instance is returned',
  () {
    final appException = const TravelException.destinationNotFound();
    final actual = TravelException.fromException(appException);
    expect(actual, same(appException));
  },
);
```

## L10n

L10n behavior in this blueprint is validated through widget tests that consume localized strings.

Test files:

* `fsda-examples/FSDA-Base/modules/travel/test/src/shared/ui/extensions/travel_failure_x_test.dart`
* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/destination_popular_empty_feedback_test.dart`
* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/destination_popular_error_feedback_test.dart`
* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/destination_popular_section_test.dart`

Example:

```dart
await tester.pumpAndSettle();

expect(find.text('No Destination Found'), findsOneWidget);
expect(find.text('No destination found at the moment'), findsOneWidget);
expect(find.text('Refresh'), findsOneWidget);

await tester.tap(find.text('Refresh'));
await tester.pumpAndSettle();
```

## Domain Layer

### destination_entity.dart

`DestinationEntity` is a field-only data contract in the current retrieval pilot.

Testing policy:

* direct entity unit test is optional
* entity mapping correctness is validated by DTO/repository tests

### destination_repository.dart

Repository contract is validated through use case and repository implementation tests.

### destination_use_case.dart

Test file:

* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/domain/usecases/destination_popular_use_case_test.dart`

Example:

```dart
test(
  'Given repository returns success, When call is executed, Then success result is returned',
  () async {
    final expected = <DestinationEntity>[DestinationFixture.entity()];
    when(
      repository.getDestinationPopular(),
    ).thenAnswer((_) async => Result.success(expected));

    final result = await useCase();

    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, expected);
    verify(repository.getDestinationPopular()).called(1);
  },
);
```

## Data Layer

### destination_dto.dart

Test file:

* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/data/dtos/destination_dto_test.dart`

Coverage focus:

* `fromJson`
* `toEntity`

### destination_popular_response.dart

Coverage focus is included via datasource and mapping tests that parse API response payload.

### destination_remote_data_source.dart and destination_remote_data_source_impl.dart

Test file:

* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/data/datasources/destination_remote_data_source_impl_test.dart`

Coverage focus:

* success parse path
* null/invalid data path
* non-200 response failure path

### destination_repository_impl.dart

Test file:

* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/data/repositories/destination_repository_impl_test.dart`

Coverage focus:

* dto to entity mapping
* exception to failure translation
* logger interaction on warning/error paths

## Logic Layer

### destination_popular_state.dart and destination_popular_cubit.dart

Test file:

* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/logic/popular/destination_popular_cubit_test.dart`

Coverage focus:

* initial -> loading -> loaded(data)
* initial -> loading -> loaded(empty)
* initial -> loading -> failure

## UI Layer

Test files (module):

* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/destination_popular_content_test.dart`
* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/destination_popular_empty_feedback_test.dart`
* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/destination_popular_error_feedback_test.dart`
* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/destination_popular_section_test.dart`
* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/destination_popular_skeleton_test.dart`
* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/parts/destination_popular_item_test.dart`
* `fsda-examples/FSDA-Base/modules/travel/test/src/features/destination/ui/popular/widgets/parts/destination_popular_item_skeleton_test.dart`

Implementation-in-app coverage (base_app):

* `fsda-examples/FSDA-Base/apps/base_app/test/modules/travel/features/destination/pages/destination_page_widget_test.dart`

Example for app-level orchestration:

```dart
testWidgets(
  'Given loaded data, '
  'When destination item is tapped, '
  'Then success snackbar is shown',
  (tester) async {
    final data = <DestinationEntity>[_destination(id: 1, name: 'Bromo')];
    stateController.add(
      DestinationPopularState.loaded(data: data),
    );
    await tester.pump();

    await tester.tap(find.text('Bromo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Destination tapped: Bromo'), findsOneWidget);
  },
);
```

## Barrel

### destination_feature.dart and travel.dart

Barrel exports are compile-time contracts.

Testing policy:

* no dedicated runtime test required only for re-export declarations
* export validity is covered indirectly because test files import through public package API (`package:travel/travel.dart`) and compile successfully

## App Composition Addendum (Outside Module Blueprint)

Although not part of module blueprint headings, app wiring is required for completed FSDA implementation.

Test file:

* `fsda-examples/FSDA-Base/apps/base_app/test/modules/travel/travel_di_test.dart`

Coverage focus:

* DI registration is present
* resolved types match expected concrete implementations
