# moonbit-posterkit

`moonbit-posterkit` is a typed, data-driven MoonBit poster and cover generation toolkit.
It focuses on reusable poster templates, social-media presets, batch JSON rendering, validation-friendly CLI workflows, and SVG output that is easy to diff, test, and automate.

## Why This Project

MoonBit already has lower-level graphics, SVG, and layout-related packages in the ecosystem.
`moonbit-posterkit` sits one layer above them:

- preset-driven poster and cover composition
- reusable launch/editorial/event/quote/digest templates
- batch rendering from typed JSON jobs
- a native CLI for rendering, validation, catalog export, and pack emission
- catalog packs for repeated campaign scenarios

This avoids rebuilding generic graphics primitives while still filling a clear gap in MoonBit's application-layer tooling.

## Features

- typed poster document model
- social presets: square, story, thumbnail
- themes: warm-editorial, swiss-grid
- scene DSL: block, text, image slot
- layout helpers: stack, grid, anchor
- text flow helpers for Latin and CJK content
- built-in templates: `launch`, `editorial`, `event`, `quote`, `digest`
- registry APIs for templates, presets, themes, and campaign packs
- config pipeline: parse JSON -> validate batch -> render batch -> write SVG
- CLI commands: `batch`, `render`, `validate`, `emit-pack`, `list-*`, `catalog-*`
- sample campaign catalog packs for hackathon, quote-story, release, and digest flows

## Quick Start

Build and test:

```bash
moon check --target all
moon test --target all
moon fmt --check
moon info
```

Inspect the built-in inventory:

```bash
moon run --target native src/cli list-templates
moon run --target native src/cli list-presets
moon run --target native src/cli list-packs
```

Validate and render the bundled showcase batch:

```bash
moon run --target native src/cli validate examples/batches/hackathon-showcase.json
moon run --target native src/cli batch examples/batches/hackathon-showcase.json examples/rendered
```

Emit a built-in sample pack to JSON:

```bash
moon run --target native src/cli emit-pack quote-story-pack examples/batches/quote-story-pack.json
```

## Built-In Templates

- `launch`: release cards, product drops, hero-first announcements
- `editorial`: story cards, article covers, narrative recap layouts
- `event`: operational event posters and workshop promotion cards
- `quote`: pull-quote cards with portrait slots and attribution
- `digest`: recap layouts for release notes, weekly digests, and summary cards

## Package Map

- `src/core`: base types
- `src/theme`: theme palette and spacing
- `src/preset`: output size presets
- `src/scene`: poster DSL
- `src/layout`: layout primitives
- `src/textflow`: multiline text helpers
- `src/svg`: SVG renderer
- `src/template`: built-in poster templates
- `src/config`: typed batch config pipeline
- `src/registry`: built-in template/preset/theme metadata registry
- `src/catalog`: reusable sample campaign packs
- `src/catalog_meta`: derived metadata for campaign packs
- `src/manifest`: JSON and Markdown catalog exporters
- `src/cli_support`: testable CLI logic
- `src/cli`: executable entrypoint

## Repository Notes

- examples live in `examples/batches` and `examples/rendered`
- CI checks build, test, formatting, interface generation, and CLI smoke paths for validation, rendering, and pack emission
- source provenance is documented in `PROVENANCE.md`
- `moon info` generated interfaces are versioned on purpose for API review
- the current `src/**/*.mbt` + `src/**/*.mbti` footprint is above 4,000 lines for hackathon-scale deliverability

## License

Apache-2.0
