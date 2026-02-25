// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'CARE-IT Framework',
  tagline: 'Governance für digitale Versorgungsinfrastruktur',
  favicon: 'img/favicon.ico',

  // Future flags, see https://docusaurus.io/docs/api/docusaurus-config#future
  future: {
    v4: true, // Improve compatibility with the upcoming Docusaurus v4
  },

  // Set the production url of your site here
  url: 'https://careitmodel.org',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',
  trailingSlash: true,

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'careitmodel', // Usually your GitHub org/user name.
  projectName: 'https://github.com/careitmodel/careit.git', // Usually your repo name.

  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'de'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: './sidebars.js',
          routeBasePath: '/', // Optional: Docs direkt auf Root statt /docs
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
      ],
    ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
  ({
      // Replace with your project's social card
    image: 'img/careit-social-card.png',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: '',
      logo: {
        alt: 'My Site Logo',
        src: 'img/careit-mark.svg',
      },
      items: [
      {
        type: 'docSidebar',
        sidebarId: 'careitSidebar',
        position: 'left',
        label: 'CARE-IT',
      },
          //{to: '/blog', label: 'Blog', position: 'left'},
      {
        href: 'https://github.com/facebook/docusaurus',
        label: 'GitHub',
        position: 'right',
      },
      ],
    },
    footer: {
      style: 'dark',
      links: [
      {
        title: 'Start',
        items: [
          { label: 'Definition', to: '/foundations/definition' },
          { label: 'Scope', to: '/foundations/scope' },
          { label: 'Controlled Open', to: '/foundations/controlled-open' },
          { label: 'Versions', to: '/versions/current' },
          ],
      },
      {
        title: 'Framework',
        items: [
          { label: 'Principles', to: '/principles/overview' },
          { label: 'Architecture', to: '/architecture/overview' },
          { label: 'Maturity Model', to: '/maturity-model/model' },
          { label: 'Artifacts', to: '/artifacts/overview' },
          ],
      },
      {
        title: 'Adoption',
        items: [
          { label: 'Case: Mobile Monitoring', to: '/adoption/case-mobile-monitoring' },
          { label: 'Implementation Guide', to: '/adoption/implementation-guide' },
          { label: 'Adoption KPIs', to: '/adoption/kpis' },
          ],
      },
      {
        title: 'Contribute',
        items: [
          { label: 'How to Contribute', to: '/contribute/how-to-contribute' },
          { label: 'Contact', to: '/contribute/contact' },
          { label: 'GitHub', href: 'https://github.com/careitmodel/careit.git' },
          ],
      },
      {
        title: 'Legal',
        items: [
          { label: 'Imprint', to: '/legal/imprint' },
          { label: 'Privacy', to: '/legal/privacy' },
          ],
      },
      ],
      copyright:
      `Copyright © ${new Date().getFullYear()} CARE-IT Framework. Controlled Open.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  }),
};

export default config;
