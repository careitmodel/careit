module.exports = {
  careitSidebar: [
    {
      type: 'category',
      label: 'Part I – Foundations',
      collapsed: false,
      items: [
        'foundations/executive-summary',
        'foundations/introduction',
        'foundations/definition',
        'foundations/scope',
        'foundations/controlled-open',
      ],
    },

    {
      type: 'category',
      label: 'Part II – Principles',
      collapsed: false,
      items: [
        'principles/overview',
        'principles/p1',
        'principles/p2',
        'principles/p3',
        'principles/p4',
        'principles/p5',
        'principles/p6',
        'principles/p7',
        'principles/p8',
      ],
    },

    {
      type: 'category',
      label: 'Part III – Maturity Model',
      collapsed: false,
      items: [
        'maturity-model/model',
        'maturity-model/profile',
        'maturity-model/indicators-principles',
        'maturity-model/indicators-domains',
        'maturity-model/evaluation-logic',
      ],
    },

    {
      type: 'category',
      label: 'Part IV – Architecture',
      collapsed: false,
      items: [
        'architecture/overview',
        'architecture/domains',
        {
          type: 'category',
          label: 'Domains in Detail',
          items: [
            'architecture/domains/d1',
            'architecture/domains/d2',
            'architecture/domains/d3',
            'architecture/domains/d4',
            'architecture/domains/d5',
            'architecture/domains/d6',
          ],
        },
        'architecture/reference-systembunds',
      ],
    },

    {
      type: 'category',
      label: 'Part V – Artifacts',
      collapsed: false,
      items: [
        'artifacts/overview',
        'artifacts/core-artifacts',
        'artifacts/impact-check',
        'artifacts/risk-impact-check',
        'artifacts/systembund',
        'artifacts/roles-matrix',
        'artifacts/lifecycle',
        'artifacts/innovation-canvas',
      ],
    },

    {
      type: 'category',
      label: 'Part VI – Adoption & Application',
      collapsed: false,
      items: [
        'adoption/case-mobile-monitoring',
        'adoption/implementation-guide',
        'adoption/kpis',
      ],
    },

    {
      type: 'category',
      label: 'Framework Governance',
      collapsed: true,
      items: [
        'framework-governance/governance',
      ],
    },

    {
      type: 'category',
      label: 'Contribute',
      collapsed: true,
      items: [
        'contribute/how-to-contribute',
        'contribute/contact',
      ],
    },

    {
      type: 'category',
      label: 'Versions',
      collapsed: true,
      items: [
        'versions/current',
        'versions/changelog',
      ],
    },

    {
      type: 'category',
      label: 'Appendix',
      collapsed: true,
      items: [
        'glossary',
        'references',
      ],
    },

    {
      type: 'category',
      label: 'Legal',
      collapsed: true,
      items: [
        'legal/imprint',
        'legal/privacy',
      ],
    },
  ],
};