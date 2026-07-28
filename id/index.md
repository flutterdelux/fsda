---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "FSDA"
  text: "Feature Slice Driven Architecture"
  tagline: "A pragmatic, rule-driven Flutter architecture focused on consistency, discoverability, and long-term maintainability."
  image:
    src: /images/logo.png
    alt: FSDA Logo
  actions:
    - theme: brand
      text: Getting Started
      link: /getting-started
    - theme: alt
      text: View Architecture
      link: /architecture/architecture

features:
  - title: Rule-Driven
    details: Mengurangi ambiguitas melalui aturan struktur, dependency, dan konvensi yang eksplisit.
  - title: Discoverability First
    details: Didesain agar developer dapat dengan cepat menemukan di mana sebuah kode harus ditulis atau dicari.
  - title: Modular Monorepo
    details: Mendukung arsitektur multi-aplikasi (Apps, Modules, Shared Packages) dalam satu ekosistem.
  - title: CLI Powered
    details: Automasi pembuatan struktur, feature, dan module secara presisi menggunakan fsda_cli.
---

## Why FSDA?

Banyak arsitektur menjelaskan prinsip, namun sedikit yang menjelaskan implementasi secara spesifik. Akibatnya:
* Struktur proyek berbeda-beda antar developer
* Naming convention tidak konsisten
* Tanggung jawab layer menjadi ambigu
* Architectural drift mudah terjadi

**FSDA hadir untuk mengatasi masalah tersebut.**

<br>

## High-Level Overview

Konsep arsitektur ini membagi proyek ke dalam tiga lapisan utama:

### 1. Shared Packages
Fondasi independen yang digunakan bersama oleh seluruh sistem (`app_core`, `app_ui`, `app_l10n`, `infra_...`).

### 2. Modules
Boundary bisnis utama yang berisi *feature-feature* dalam domain yang sama dan dapat digunakan kembali oleh banyak aplikasi.

### 3. Apps
Lapisan komposisi yang bertugas menyusun berbagai *modules* dan *shared packages* menjadi sebuah aplikasi utuh yang siap berjalan.