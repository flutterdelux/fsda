# app_ui

Foundation package for design system, visual primitives, and shared UI components used across applications.

## Purpose

`app_ui` maintains visual and interaction consistency without forcing features to store generic presentation components inside business boundaries.

## Typical Responsibilities

Examples of resources suitable for `app_ui`:

* theme, color tokens, typography, spacing tokens
* shared widgets/visual primitives reused across modules
* reusable feedback components like loading, empty state, and error presentation
* UI helpers that belong to design system

## Good Candidates

Place resources in `app_ui` when they:

* are reusable across multiple modules or apps
* do not carry specific business feature ownership
* focus on presentation, styling, or common interaction patterns

## Not For

`app_ui` is not for:

* app page composition
* widgets highly specific to one business feature
* business orchestration
* datasource, repository, or use case

## Dependency Position

`app_ui` sits at shared UI foundation level.

Module UI may depend on `app_ui` to keep presentation consistency without pulling unnecessary business dependencies.

In current Flutter baseline, modules commonly depend on `app_ui` for standard UI needs across apps/modules.
