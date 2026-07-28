import { defineConfig } from 'vitepress'

const idSidebar = [
  {
    text: 'Pendahuluan',
    items: [
      { text: 'Getting Started', link: '/id/getting-started' },
      {
        text: 'Wikuy E2E',
        link: '/id/getting-started-wikuy',
      },
      {
        text: 'Wikuy CLI-Driven E2E',
        link: '/id/getting-started-cli-wikuy',
      },
    ],
  },
  {
    text: 'Konsep Arsitektur',
    collapsed: false,
    items: [
      { text: 'Architecture Overview', link: '/id/architecture/architecture' },
      { text: 'Foundations', link: '/id/architecture/foundations' },
      { text: 'Principles', link: '/id/architecture/principles' },
      { text: 'Dependency Rules', link: '/id/architecture/dependency-rules' },
      { text: 'Structure', link: '/id/architecture/structure' },
      { text: 'Structure Example', link: '/id/architecture/structure-example' },
      { text: 'Sequence Pattern', link: '/id/architecture/sequence-pattern' },
      {
        text: 'Layers',
        collapsed: true,
        items: [
          { text: 'App Layer', link: '/id/architecture/layers/app' },
          { text: 'UI Layer', link: '/id/architecture/layers/ui-layer' },
          { text: 'Logic Layer', link: '/id/architecture/layers/logic-layer' },
          { text: 'Domain Layer', link: '/id/architecture/layers/domain-layer' },
          { text: 'Data Layer', link: '/id/architecture/layers/data-layer' },
        ],
      },
    ],
  },
  {
    text: 'Conventions & Guides',
    collapsed: true,
    items: [
      { text: 'Coding Standards', link: '/id/conventions/coding-standards' },
      { text: 'Naming Conventions', link: '/id/conventions/naming-conventions' },
      { text: 'Commit Conventions', link: '/id/conventions/commit-conventions' },
      { text: 'Development Workflow', link: '/id/guides/development-workflow' },
      { text: 'Testing Strategy', link: '/id/guides/testing-strategy' },
      { text: 'Anti Patterns', link: '/id/guides/anti-patterns' },
    ],
  },
  {
    text: 'FSDA CLI',
    collapsed: false,
    items: [
      { text: 'Installation', link: '/id/cli/installation' },
      { text: 'Commands', link: '/id/cli/commands' },
      { text: 'Workflow', link: '/id/cli/workflow' },
      { text: 'UI Slice', link: '/id/cli/ui_slice' },
      { text: 'Cheat Sheet', link: '/id/cli/cheat_sheet_fsda_cli' },
    ],
  },
]

const enSidebar = [
  {
    text: 'Introduction',
    items: [
      { text: 'Getting Started', link: '/getting-started' },
      {
        text: 'Wikuy E2E',
        link: '/getting-started-wikuy',
      },
      {
        text: 'Wikuy CLI-Driven E2E',
        link: '/getting-started-cli-wikuy',
      },
    ],
  },
  {
    text: 'Architecture Concepts',
    collapsed: false,
    items: [
      { text: 'Architecture Overview', link: '/architecture/architecture' },
      { text: 'Foundations', link: '/architecture/foundations' },
      { text: 'Principles', link: '/architecture/principles' },
      {
        text: 'Dependency Rules',
        link: '/architecture/dependency-rules',
      },
      { text: 'Structure', link: '/architecture/structure' },
      {
        text: 'Structure Example',
        link: '/architecture/structure-example',
      },
      { text: 'Sequence Pattern', link: '/architecture/sequence-pattern' },
      {
        text: 'Layers',
        collapsed: true,
        items: [
          { text: 'App Layer', link: '/architecture/layers/app' },
          { text: 'UI Layer', link: '/architecture/layers/ui-layer' },
          { text: 'Logic Layer', link: '/architecture/layers/logic-layer' },
          {
            text: 'Domain Layer',
            link: '/architecture/layers/domain-layer',
          },
          { text: 'Data Layer', link: '/architecture/layers/data-layer' },
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
        link: '/conventions/coding-standards',
      },
      {
        text: 'Naming Conventions',
        link: '/conventions/naming-conventions',
      },
      {
        text: 'Commit Conventions',
        link: '/conventions/commit-conventions',
      },
      {
        text: 'Development Workflow',
        link: '/guides/development-workflow',
      },
      { text: 'Testing Strategy', link: '/guides/testing-strategy' },
      { text: 'Anti Patterns', link: '/guides/anti-patterns' },
    ],
  },
  {
    text: 'FSDA CLI',
    collapsed: false,
    items: [
      { text: 'Installation', link: '/cli/installation' },
      { text: 'Commands', link: '/cli/commands' },
      { text: 'Workflow', link: '/cli/workflow' },
      { text: 'UI Slice', link: '/cli/ui_slice' },
      { text: 'Cheat Sheet', link: '/cli/cheat_sheet_fsda_cli' },
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
  base: '/fsda/',
  title: 'FSDA',
  description: 'Feature Slice Driven Architecture',
  cleanUrls: true,
  locales: {
    root: {
      label: 'English',
      lang: 'en-US',
      description: 'Feature Slice Driven Architecture documentation',
      themeConfig: {
        ...sharedThemeConfig,
        langMenuLabel: 'Language',
        nav: [
          { text: 'Getting Started', link: '/getting-started' },
          { text: 'Architecture', link: '/architecture/architecture' },
          { text: 'CLI', link: '/cli/commands' },
        ],
        sidebar: enSidebar,
      },
    },
    id: {
      label: 'Indonesia',
      lang: 'id-ID',
      link: '/id/',
      description: 'Dokumentasi Feature Slice Driven Architecture',
      themeConfig: {
        ...sharedThemeConfig,
        langMenuLabel: 'Bahasa',
        nav: [
          { text: 'Getting Started', link: '/id/getting-started' },
          { text: 'Architecture', link: '/id/architecture/architecture' },
          { text: 'CLI', link: '/id/cli/commands' },
        ],
        sidebar: idSidebar,
      },
    },
  },
})