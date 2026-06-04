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
  tagline: 'Governance for Digital Clinical Infrastructure',
  favicon: 'img/favicon/favicon.svg',

  stylesheets: [
    {
      href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap',
      type: 'text/css',
    },
  ],

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
  projectName: 'careit', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'throw',

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
          routeBasePath: '/framework',
          editUrl: 'https://github.com/careitmodel/careit/tree/main/website/',
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
      image: 'img/social/careit-social-card.png',
      colorMode: {
        respectPrefersColorScheme: true,
      },
      navbar: {
        title: '',
        logo: {
          alt: 'My Site Logo',
          src: 'img/branding/careit-logo-compact.svg',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'careitSidebar',
            position: 'left',
            label: 'Framework',
          },
          {type: 'localeDropdown', position: 'right'},
          // {to: '/blog', label: 'Blog', position: 'left'},
          {
            href: 'https://github.com/careitmodel/careit',
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
              {label: 'Definition', to: '/framework/foundations/definition'},
              {label: 'Scope', to: '/framework/foundations/scope'},
              {label: 'Controlled Open', to: '/framework/foundations/controlled-open'},
              {label: 'Versions', to: '/framework/versions/current'},
            ],
          },
          {
            title: 'Framework',
            items: [
              {label: 'Principles', to: '/framework/principles/overview'},
              {label: 'Architecture', to: '/framework/architecture/overview'},
              {label: 'Maturity Model', to: '/framework/maturity-model/model'},
              {label: 'Artifacts', to: '/framework/artifacts/overview'},
            ],
          },
          {
            title: 'Adoption',
            items: [
              {label: 'Case: Mobile Monitoring', to: '/framework/adoption/case-mobile-monitoring'},
              {label: 'Implementation Guide', to: '/framework/adoption/implementation-guide'},
              {label: 'Adoption KPIs', to: '/framework/adoption/kpis'},
            ],
          },
          {
            title: 'Contribute',
            items: [
              {label: 'How to Contribute', to: '/framework/contribute/how-to-contribute'},
              {label: 'Contact', to: '/framework/contribute/contact'},
              {label: 'GitHub', href: 'https://github.com/careitmodel/careit'},
            ],
          },
          {
            title: 'Legal',
            items: [
              {label: 'Imprint', to: '/framework/legal/imprint'},
              {label: 'Privacy', to: '/framework/legal/privacy'},
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} CARE-IT Framework. Controlled Open.`,
      },
      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
      },
    }),
};

export default config;
