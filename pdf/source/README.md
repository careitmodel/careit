# PDF Source Overrides

Most PDF content is generated from `website/docs` and the German i18n docs.

Use this directory only for pages where the website source needs MDX or React
components that are not suitable for Pandoc. Keep the same relative path as the
website doc so `pdf/pdf-order.txt` can stay stable.

Example:

- Website: `website/docs/04-architecture/overview.mdx`
- PDF: `pdf/source/en/04-architecture/overview.md`
- German PDF: `pdf/source/de/04-architecture/overview.md`
