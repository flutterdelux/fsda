# app_core

Foundation package for stable core contracts and utilities used across apps, modules, or other shared packages.

&nbsp;

## Purpose

`app_core` stores the most basic resources that do not carry specific business feature ownership and do not depend on concrete technology implementations.

The goal is to provide a small, stable, and safe shared surface.

&nbsp;

## Typical Responsibilities

Examples of resources suitable for `app_core`:

* base contracts such as `Failure`, `Result`, `AsyncResult`, or `UseCase`
* small abstractions reused across modules
* core technology-agnostic utilities
* extensions/helpers that are very general and do not carry specific feature ownership

&nbsp;

## Good Candidates

Place resources in `app_core` when they:

* are reused by many modules or packages
* are stable and rarely change due to specific feature needs
* do not contain specific business capability
* do not depend on UI or concrete technology integration

&nbsp;

## Not For

`app_core` is not for:

* business features
* widgets or design system components
* repository implementation or datasource
* concrete technology configuration such as Http, Supabase, Firebase, and similar

&nbsp;

## Dependency Position

`app_core` should be one of the lowest shared foundations.

The smaller and more stable the `app_core` surface, the safer it is as dependency for App, Module, and other shared packages.

In current Flutter baseline, modules commonly depend on `app_core` to access shared contracts and abstractions across apps and modules.
