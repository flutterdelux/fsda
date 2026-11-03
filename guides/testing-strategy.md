# Testing Strategy

This document defines a practical testing strategy for FSDA projects.

## Objective

Testing in FSDA is used to:

* verify business behavior
* protect architecture boundaries
* make sequence implementation predictable
* reduce regression risk as modules grow

## Testing References

Design tests according to each layer's responsibility, Use Case sequence contracts, feature-slice boundaries, and App composition.

## FSDA Testing Principles

Use these principles as the default baseline:

* Test by ownership boundary. Keep assertions near the layer that owns the behavior.
* Keep test ownership explicit: one production unit file should have one dedicated test file when practical.
* Validate contract, not implementation details.
* Keep tests deterministic and fast by default.
* Add integration depth only where composition risk exists.

## Pilot Baseline (Travel / Destination / Popular)

The first concrete FSDA testing pilot covers the `getPopularDestination` Use Case and the `popular` Logic/UI slice in the travel/destination feature.

Use this as a reference baseline for future slices:

| Scope | Coverage Focus | Example Test Shape |
| --- | --- | --- |
| Module Domain | use case contract forwarding and failure behavior | `domain/usecases/*_use_case_test.dart` |
| Module Data | datasource parsing, repository mapping, exception translation | `data/datasources/*_impl_test.dart`, `data/repositories/*_impl_test.dart` |
| Module Logic | state transitions (loading, loaded, empty, failure) per slice | `logic/<logic_slice>/*_cubit_test.dart` |
| Module UI | widget behavior per owned widget file | `ui/<ui_slice>/widgets/*_test.dart` and `ui/<ui_slice>/widgets/parts/*_test.dart` |
| App Integration | App-owned UI/Logic/Use Case composition, DI, and route smoke | `test/modules/.../*_widget_test.dart`, `test/modules/.../*_di_test.dart` |

## Layer-Based Testing Matrix

| Layer | Main Focus | Preferred Tests | Avoid |
| --- | --- | --- | --- |
| Domain | Business rules and contracts | Unit tests for use cases, contract expectations, and entity behavior when business logic exists | Framework/UI assertions |
| Data | Mapping and technical translation | Unit/contract tests for DTO-Entity mapping, request/response mapping, exception to failure translation, repository behavior | UI and state-flow assertions |
| Logic | State orchestration | Unit tests for state transitions and use case orchestration | Data-source implementation assertions |
| UI | Presentation behavior | Widget tests for rendering, interactions, loading/empty/error visuals | Repository and transport assertions |
| App | Composition wiring | Integration or smoke tests for routes, DI wiring, module composition, localization composition | Re-testing low-level business rules |

## Test Type Portfolio

Use test types according to risk and scope:

* Unit test: default for Domain, Data, and Logic behavior.
* Widget test: default for UI presentation and interactions.
* Integration test: used for app composition paths and cross-module user flows.
* Smoke test: minimal confidence checks for startup, routing, and critical page entry.

## Layer-Based Testing

Use this baseline approach:

* Domain: unit tests for use cases, contract behavior, and business rules
* Data: tests for mapping, error translation, repository behavior, and technical adapters
* Logic: tests for state transitions and orchestration in each relevant slice
* UI: widget tests for presentation and interactions in each relevant UI part
* App: integration or smoke tests for composition, routes, dependency wiring, and callback/event dispatch to Logic

### Entity Test Policy

Entity tests are conditional by behavior.

Mandatory when the entity contains:

* constructor or factory invariants/validation
* domain methods, computed properties, or derived rules
* custom equality/normalization beyond generator defaults
* critical business rules with regression risk

Optional when the entity is:

* a pure field-only data contract (anemic model)
* covered only by tests that would repeat generator behavior without adding business protection

In early test rollout, it is valid to prioritize higher-risk boundaries first (use case, data translation, logic state, UI state, app wiring), then add entity tests when entity behavior evolves.

## Sequence Contract and Feature Slice Testing

A sequence is a Use Case-to-Data contract. Test each Use Case according to its flow/signature, independently of the Logic/UI slice name. At minimum, verify:

* Async/sync Use Cases: forwarded input (if any), result or `void`, and failure behavior.
* Stream Use Cases: emissions, failure emissions, and cancellation/close where lifecycle applies.
* Param Use Cases: mapping of Param values to repository/data contracts.
* Return Use Cases: result payloads, including DTO-to-Entity mapping at the responsible boundary.

Pagination, specific limits, offline-first behavior, and state transformation are tested at the layer that owns them. For example, pagination/load-more and a limit of `5` belong in tests for the Logic part that builds parameters; cache/fallback behavior belongs in Data tests; loading/loaded/error state belongs in Logic tests; rendering and callbacks belong in UI tests.

When a Logic part calls multiple Use Cases, test orchestration for each success/failure path. A form Logic part with no Use Case is tested for input, local validation, and state transitions. UI is tested without direct Logic access, using callbacks and data as its boundaries.

## Recommended Test File Structure

Mirror production ownership to improve discoverability.

```text
modules/
└── <module>/
		└── test/
				└── src/
						└── features/
								└── <feature>/
										├── domain/usecases/<use_case_name>_test.dart
										├── data/repositories/<feature>_repository_impl_test.dart
										├── logic/<logic_slice>/<feature>_<logic_slice>_cubit_test.dart
										└── ui/<ui_slice>/views/<feature>_<ui_slice>_view_test.dart

apps/
└── <app>/
		├── test/
		│   └── app/<module>_route_test.dart
		└── integration_test/
				└── <feature>_<slice>_flow_test.dart
```

## Test Naming Conventions

Use naming that mirrors production files:

* `<production_file_name>_test.dart`
* `group` name follows `<Feature><Slice>` when possible
* test title follows BDD style: `Given <context>, When <action>, Then <expected>`
* split long BDD messages into multi-line string segments for readability

BDD style improves readability of intent and expected behavior.

Recommended examples:

* Unit test: `Given valid username, When login is called, Then should return success`
* Widget test: `Given showLoading is true, When screen is pumped, Then loading indicator should be visible`

Example:

```dart
group('DestinationListCubit', () {
	test(
		'Given valid input, '
		'When getList is called, '
		'Then loaded state is emitted',
		() async {
			// ...
		},
	);
});
```

## Service Locator Testing Policy

When using GetIt in tests:

* Do not mock the service locator object itself.
* Keep `sl` real, then `reset()` per test lifecycle.
* Register test doubles only for collaborators that matter to the scenario.
* For app composition tests, verify registration and resolution separately from business flow tests.

## Test Double Strategy

Use test doubles intentionally:

* Fake: for simple deterministic collaborators.
* Mock: only when interaction verification matters.
* Stub: for fixed return behavior.

Avoid mocking value objects such as Params, Entities, or basic enums.

## Definition of Done per Layer Slice and Feature Flow

A feature flow is test-complete when its implemented layer parts and Use Case contracts satisfy these minimum checks:

* [ ] Domain: use case success/failure behavior is covered.
* [ ] Domain: entity behavior is covered when the entity contains business logic or invariants.
* [ ] Data: DTO mapping/parsing and response contract parsing are covered when those units exist.
* [ ] Data: datasource success/failure paths are covered when datasource is part of the slice.
* [ ] Data: repository mapping and exception-to-failure translation are covered.
* [ ] Logic: state transitions for the slice scenarios are covered.
* [ ] UI: critical widget states/interactions are covered per owned widget file, including `parts/` widgets when they define visual or interaction contracts.
* [ ] App: DI registration/resolution, route/page composition, and UI callback-to-Logic dispatch are covered when the flow introduces App wiring.
* [ ] Use Case sequence contract: signature, input/result, failure, and stream lifecycle are covered as applicable.

## CI Quality Gate Recommendations

Start with pragmatic gates and tighten gradually:

* Run unit and widget tests for changed modules on every pull request.
* Run integration/smoke tests for changed app composition paths.
* Validate architecture/dependency rules as part of CI.
* Add coverage floor per layer as a trend guard, not as vanity metric.

Suggested initial coverage floor (adjust by team maturity):

* Domain: 85%+
* Data: 75%+
* Logic: 80%+
* UI: 60%+ on critical surfaces

## Rollout Plan For Projects Without Tests Yet

Use incremental rollout:

1. Finalize this strategy and shared templates.
2. Pilot one real feature flow (for example: `travel/destination/popular`).
3. Stabilize checklist and naming from pilot learnings.
4. Expand module by module, covering relevant Use Case contracts and Logic/UI parts.
5. Enforce CI gates after baseline coverage is realistic.

## Test Case Template

Use this template for consistency:

```text
Title:
Given:
When:
Then:
Expected State:
Notes:
```

## Multi-Package Coverage Workflow

In FSDA workspaces, module and app live in different folders.

Run coverage per package first, then remove generated sources from each package report:

```bash
cd <workspace>/modules/<module>
flutter test --coverage
lcov --ignore-errors unused --remove coverage/lcov.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/lcov.info

cd <workspace>/apps/<app>
flutter test --coverage
lcov --ignore-errors unused --remove coverage/lcov.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/lcov.info
```

Optional per-package HTML report:

```bash
cd <workspace>/modules/<module>
genhtml coverage/lcov.info -o coverage/html --ignore-errors empty,unused
open coverage/html/index.html
```

Optional combined summary (filtered):

```bash
cd <workspace>
mkdir -p coverage
lcov -a modules/<module>/coverage/lcov.info -a apps/<app>/coverage/lcov.info -o coverage/combined.info
lcov --ignore-errors unused --remove coverage/combined.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/combined.info
lcov --summary coverage/combined.info
```

Optional combined HTML report:

```bash
cd <workspace>
genhtml coverage/combined.info -o coverage/combined_html --source-directory apps/<app> --source-directory modules/<module> --ignore-errors empty,unused
open coverage/combined_html/index.html
```

Concrete example in `fsda-examples/FSDA-Base`:

```bash
cd /Users/flutter-delux/fsda/fsda-examples/FSDA-Base/modules/travel
flutter test --coverage
lcov --ignore-errors unused --remove coverage/lcov.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/lcov.info

cd /Users/flutter-delux/fsda/fsda-examples/FSDA-Base/apps/base_app
flutter test --coverage
lcov --ignore-errors unused --remove coverage/lcov.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/lcov.info

cd /Users/flutter-delux/fsda/fsda-examples/FSDA-Base
mkdir -p coverage
lcov -a modules/travel/coverage/lcov.info -a apps/base_app/coverage/lcov.info -o coverage/combined.info
lcov --ignore-errors unused --remove coverage/combined.info 'lib/src/generated/*' 'lib/**/*.freezed.dart' 'lib/**/*.g.dart' -o coverage/combined.info
lcov --summary coverage/combined.info
genhtml coverage/combined.info -o coverage/combined_html --source-directory apps/base_app --source-directory modules/travel --ignore-errors empty,unused
open coverage/combined_html/index.html
```

Notes:

* Placeholders like `<module_lcov.info>` must be replaced with real file paths and should not be run literally.
* Keep glob patterns quoted so shell does not expand them before `lcov` reads the filters.
* To check available coverage files, run: `find modules apps -type f -path "*/coverage/lcov.info" | sort`.
* In monorepo layouts, use `--source-directory` for each package root so `genhtml` can resolve `lib/...` entries correctly.
* If a pattern has no matches (for example no `freezed` files yet), `lcov` may emit an `unused` warning; this is safe.
* Prefer HTML per package, and use combined report for numeric summary.
* If a module depends on UI packages that use Material icons, set `flutter.uses-material-design: true` in that module `pubspec.yaml` to avoid warnings when running tests from module root.

## References

* Follow the layer rules and Use Case contracts described in [Sequence Pattern](../architecture/sequence-pattern.md), together with test examples available in the repository.

## What To Prioritize

Prioritize tests on:

* boundaries that frequently change
* error translation from Data to Domain
* state transitions in Logic
* critical App composition flows
