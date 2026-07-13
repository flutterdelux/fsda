import { defineConfig } from 'vitepress'

const idSidebar = [
  {
    text: 'Pendahuluan',
    items: [
      { text: 'Getting Started', link: '/getting-started' },
      {
        text: 'Wikuy Manual E2E (Tanpa CLI)',
        link: '/getting-started-manual-wikuy',
      },
      {
        text: 'Wikuy CLI-Driven E2E',
        link: '/getting-started-cli-wikuy',
      },
    ],
  },
  {
    text: 'Konsep Arsitektur',
    collapsed: false,
    items: [
      { text: 'Architecture Overview', link: '/architecture/architecture' },
      { text: 'Foundations', link: '/architecture/foundations' },
      { text: 'Principles', link: '/architecture/principles' },
      { text: 'Dependency Rules', link: '/architecture/dependency-rules' },
      { text: 'Structure', link: '/architecture/structure' },
      { text: 'Structure Example', link: '/architecture/structure-example' },
      { text: 'Sequence Pattern', link: '/architecture/sequence-pattern' },
      {
        text: 'Layers',
        collapsed: true,
        items: [
          { text: 'App Layer', link: '/architecture/layers/app' },
          { text: 'UI Layer', link: '/architecture/layers/ui-layer' },
          { text: 'Logic Layer', link: '/architecture/layers/logic-layer' },
          { text: 'Domain Layer', link: '/architecture/layers/domain-layer' },
          { text: 'Data Layer', link: '/architecture/layers/data-layer' },
        ],
      },
    ],
  },
  {
    text: 'Conventions & Guides',
    collapsed: true,
    items: [
      { text: 'Coding Standards', link: '/conventions/coding-standards' },
      { text: 'Naming Conventions', link: '/conventions/naming-conventions' },
      { text: 'Commit Conventions', link: '/conventions/commit-conventions' },
      { text: 'Development Workflow', link: '/guides/development-workflow' },
      { text: 'Testing Strategy', link: '/guides/testing-strategy' },
      { text: 'Anti Patterns', link: '/guides/anti-patterns' },
    ],
  },
  {
    text: 'FSDA CLI',
    collapsed: false,
    items: [
      { text: 'Commands', link: '/cli/commands' },
      { text: 'Workflow', link: '/cli/worflow' },
      { text: 'UI Slice', link: '/cli/ui_slice' },
      { text: 'Cheat Sheet', link: '/cli/cheat_sheet_fsda_cli' },
      { text: 'Local Dev', link: '/cli/local_dev' },
    ],
  },
]

const enSidebar = [
  {
    text: 'Introduction',
    items: [
      { text: 'Getting Started', link: '/en/getting-started' },
      {
        text: 'Wikuy Manual E2E (No CLI)',
        link: '/en/getting-started-manual-wikuy',
      },
      {
        text: 'Wikuy CLI-Driven E2E',
        link: '/en/getting-started-cli-wikuy',
      },
    ],
  },
  {
    text: 'Architecture Concepts',
    collapsed: false,
    items: [
      { text: 'Architecture Overview', link: '/en/architecture/architecture' },
      { text: 'Foundations', link: '/en/architecture/foundations' },
      { text: 'Principles', link: '/en/architecture/principles' },
      {
        text: 'Dependency Rules',
        link: '/en/architecture/dependency-rules',
      },
      { text: 'Structure', link: '/en/architecture/structure' },
      {
        text: 'Structure Example',
        link: '/en/architecture/structure-example',
      },
      { text: 'Sequence Pattern', link: '/en/architecture/sequence-pattern' },
      {
        text: 'Layers',
        collapsed: true,
        items: [
          { text: 'App Layer', link: '/en/architecture/layers/app' },
          { text: 'UI Layer', link: '/en/architecture/layers/ui-layer' },
          { text: 'Logic Layer', link: '/en/architecture/layers/logic-layer' },
          {
            text: 'Domain Layer',
            link: '/en/architecture/layers/domain-layer',
          },
          { text: 'Data Layer', link: '/en/architecture/layers/data-layer' },
        ],
      },
    ],
  },
  {
    text: 'Conventions & Guides',
    collapsed: true,
    items: [
      {
        text: 'Coding Standards',
        link: '/en/conventions/coding-standards',
      },
      {
        text: 'Naming Conventions',
        link: '/en/conventions/naming-conventions',
      },
      {
        text: 'Commit Conventions',
        link: '/en/conventions/commit-conventions',
      },
      {
        text: 'Development Workflow',
        link: '/en/guides/development-workflow',
      },
      { text: 'Testing Strategy', link: '/en/guides/testing-strategy' },
      { text: 'Anti Patterns', link: '/en/guides/anti-patterns' },
    ],
  },
  {
    text: 'FSDA CLI',
    collapsed: false,
    items: [
      { text: 'Commands', link: '/en/cli/commands' },
      { text: 'Workflow', link: '/en/cli/worflow' },
      { text: 'UI Slice', link: '/en/cli/ui_slice' },
      { text: 'Cheat Sheet', link: '/en/cli/cheat_sheet_fsda_cli' },
      { text: 'Local Dev', link: '/en/cli/local_dev' },
    ],
  },
]

const sharedThemeConfig = {
  socialLinks: [{ icon: 'github', link: 'https://github.com/flutterdelux/fsda' }],
  search: {
    provider: 'local' as const,
  },
}

export default defineConfig({
  title: 'FSDA',
  description: 'Feature Slice Driven Architecture',
  cleanUrls: true,
  locales: {
    root: {
      label: 'Indonesia',
      lang: 'id-ID',
      description: 'Dokumentasi Feature Slice Driven Architecture',
      themeConfig: {
        ...sharedThemeConfig,
        langMenuLabel: 'Bahasa',
        nav: [
          { text: 'Getting Started', link: '/getting-started' },
          { text: 'Architecture', link: '/architecture/architecture' },
          { text: 'CLI', link: '/cli/commands' },
        ],
        sidebar: idSidebar,
      },
    },
    en: {
      label: 'English',
      lang: 'en-US',
      link: '/en/',
      description: 'Feature Slice Driven Architecture documentation',
      themeConfig: {
        ...sharedThemeConfig,
        langMenuLabel: 'Language',
        nav: [
          { text: 'Getting Started', link: '/en/getting-started' },
          { text: 'Architecture', link: '/en/architecture/architecture' },
          { text: 'CLI', link: '/en/cli/commands' },
        ],
        sidebar: enSidebar,
      },
    },
  },
})