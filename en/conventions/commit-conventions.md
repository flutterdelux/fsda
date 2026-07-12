# Commit Conventions

This document defines baseline commit conventions for FSDA.

&nbsp;

## Purpose

Commit conventions keep repository history readable, traceable, and review-friendly.

&nbsp;

## General Rules

Use commits that:

* focus on one primary concern
* explain change intent briefly
* do not mix refactor, formatting, and major behavior changes without clear reason

&nbsp;

## Recommended Format

Recommended format:

```text
<type>: <summary>
```

Examples:

```text
docs: clarify cross-feature dependency rules
fix: align param naming in structure docs
refactor: simplify module shared placement examples
```

&nbsp;

## Suggested Types

Use the most representative type:

* `feat` for new capability
* `fix` for bug fix or incorrect behavior
* `docs` for documentation changes
* `refactor` for internal structure changes without external behavior change
* `test` for adding or fixing tests
* `chore` for general maintenance work
* `build` for build, tooling, or dependency setup changes

&nbsp;

## Scope Guidance

If needed, summary may mention the changed boundary.

Examples:

```text
docs: refine app composition workflow
fix: align domain failure placement
refactor: simplify note list page example
```

&nbsp;

## What To Avoid

Avoid commits such as:

* `update`
* `fix bug`
* `misc`
* `final`

Also avoid oversized commits that combine too many unrelated concerns.

&nbsp;

## Documentation Changes

If a change touches architecture rules, naming, dependency, or structure, use explicit summaries so normative changes are easy to find in commit history.
