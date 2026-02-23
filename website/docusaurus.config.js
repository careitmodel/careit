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

  onBrokenLinks: 'throw',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
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
    image: 'img/docusaurus-social-card.jpg',
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
          { label: 'Definition', to: '/definition' },
          { label: 'Scope', to: '/scope' },
          { label: 'Controlled Open', to: '/controlled-open' },
          { label: 'Versionen', to: '/versions/current' },
          ],
      },
      {
        title: 'Framework',
        items: [
          { label: 'Grundprinzipien', to: '/principles/overview' },
          { label: 'Architektur', to: '/architecture/overview' },
          { label: 'Reifegradmodell', to: '/maturity/model' },
          { label: 'KPIs', to: '/governance/kpis' },
          { label: 'Artefakte', to: '/artifacts/overview' },
          ],
      },
      {
        title: 'Anwendung',
        items: [
          { label: 'Fallbeispiel: Mobiles Monitoring', to: '/application/case-mobile-monitoring' },
          { label: 'Implementation Guide', to: '/application/implementation-guide' },
          ],
      },
      {
        title: 'Mitwirkung',
        items: [
          { label: 'Mitmachen', to: '/contribute/how-to-contribute' },
          { label: 'Kontakt', to: '/contribute/contact' },
          { label: 'GitHub', href: 'https://github.com/careitmodel/careit.git' },
          ],
      },
      {
        title: 'Rechtliches',
        items: [
          { label: 'Impressum', to: '/legal/imprint' },
          { label: 'Datenschutz', to: '/legal/privacy' },
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
