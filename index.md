---
layout: home

hero:
  name: "FSDA"
  text: "Feature Slice Driven Architecture"
  tagline: "A pragmatic, rule-driven Flutter architecture focused on consistency, discoverability, and long-term maintainability."
  image:
    src: /logo.png
    alt: FSDA Logo
  actions:
    - theme: brand
      text: Getting Started
      link: /en/getting-started
    - theme: alt
      text: View Architecture
      link: /en/architecture/architecture

features:
  - title: Rule-Driven
    details: Reduce ambiguity with explicit structure rules, dependency direction, and naming conventions.
  - title: Discoverability First
    details: Designed so developers can quickly find where code should be written or located.
  - title: Modular Monorepo
    details: Supports multi-application architecture (Apps, Modules, Shared Packages) within one ecosystem.
  - title: CLI Powered
    details: Automates generation of structure, feature, and module with fsda_cli.
---

## Why FSDA?

Many architectures explain principles, but only a few provide specific implementation guidance. This often leads to:

- Inconsistent project structures between developers
- Unstable naming conventions
- Ambiguous layer responsibility
- Easy architectural drift

FSDA is built to solve those problems.

## High-Level Overview

This architecture is divided into three major boundaries:

### 1. Shared Packages
Independent foundations used across the system (`app_core`, `app_ui`, `app_l10n`, `infra_...`).

### 2. Modules
Primary business boundaries containing domain-related features, reusable across multiple apps.

### 3. Apps
Composition layer that assembles modules and shared packages into runnable applications.
