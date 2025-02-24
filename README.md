# Notebook

Typst powered blogging site. Uses Typst HTML Export to generate static HTML files, as well as PDF files for each post.

## Workflow

1. Content is written in Typst files, in `src/[slug].typ`.
2. By using a custom template, they are exported to HTML files, and optionally PDF files.
3. Metadata is stored in `pages.json` which is loaded on the homepage.

## License

MIT License
