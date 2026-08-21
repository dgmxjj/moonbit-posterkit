# moonbit-posterkit

\`moonbit-posterkit\` is a typed, data-driven MoonBit toolkit for generating reusable SVG posters, covers, social cards, event graphics, quote cards, and campaign packs.

It combines a small poster-oriented scene DSL, deterministic layout helpers, template registries, strict batch validation, SVG rendering, and a native CLI. The output is text-based, inspectable, diffable, and suitable for automation.

## Features

- Typed \`PosterDocument\` and \`Element\` scene model
- Square, story, thumbnail, Open Graph, print, portrait, and landscape presets
- Warm editorial and Swiss grid themes with contrast reports
- Vertical/horizontal stack, grid, anchor, split, and constraint-based layout helpers
- CJK/Latin text wrapping, bounded measurement, line clamping, and truncation
- Launch, editorial, event, quote, and digest templates
- Campaign packs with catalog statistics and query helpers
- Strict configuration validation, output planning, duplicate-path detection, and batch metrics
- Deterministic SVG escaping, structural validation, render metrics, and snapshots
- Native CLI for rendering, validation, inspection, batch generation, catalog export, and benchmark runs

## Quick start

Install the current MoonBit stable toolchain, then run:

~~~bash
moon install
moon check --target all
moon test --target all
moon run --target native src/cli list-templates
moon run --target native src/cli validate examples/batches/hackathon-showcase.json
moon run --target native src/cli batch examples/batches/hackathon-showcase.json examples/rendered
~~~

Inspect and benchmark a batch:

~~~bash
moon run --target native src/cli inspect examples/batches/hackathon-showcase.json
moon run --target native src/cli validate --strict examples/batches/hackathon-showcase.json
moon run --target native src/cli benchmark examples/benchmarks/batch-10.json 3
~~~

## Package map

- \`src/core\`: shared geometry, constraints, and collection utilities
- \`src/preset\`: output dimensions and orientation helpers
- \`src/theme\`: colors, themes, contrast/accessibility reports
- \`src/scene\`: typed elements, validation, analysis, and normalization
- \`src/layout\`: grid, stack, anchor, flow, envelope, and overflow diagnostics
- \`src/textflow\`: wrapping, measurement, truncation, and paragraph profiles
- \`src/template\`: built-in templates, content profiles, and variants
- \`src/registry\`: template/preset/theme metadata and search queries
- \`src/config\`: JSON jobs, strict validation, batch metrics, and output plans
- \`src/svg\`: deterministic SVG rendering, escaping, metrics, and structural checks
- \`src/catalog\`: reusable campaign packs, statistics, and queries
- \`src/manifest\`: JSON/Markdown catalog export and catalog helpers
- \`src/cli_support\`: testable command parsing, filesystem operations, reports, and benchmark output
- \`src/quality\`: document, SVG, and batch quality checklists

## Configuration

Batch input is JSON with a \`jobs\` array. Each job selects a template, preset, theme, slug, and typed content fields. See \`examples/batches/\` for complete inputs and \`examples/rendered/\` for generated SVG output.

The pipeline is:

\`JSON -> typed batch -> strict validation -> output plan -> template -> scene -> layout -> SVG\`

Image fields are explicit slots. The library does not download remote assets or embed unknown-origin binary files.

## Benchmarks

Benchmark fixtures are committed under \`examples/benchmarks/\`. The CLI reports iteration count, job count, successful renders, SVG bytes per iteration, and measured repeated bytes. For wall-clock timings, run the command with the platform’s timing tool and record the exact MoonBit version and host. See [\`docs/benchmarks/README.md\`](docs/benchmarks/README.md).

The source scale is audited with a repository-local command and is not treated as a substitute for functionality. Test counts and performance numbers should always be taken from the command output of the current revision.

## Testing and CI

Local quality gates:

~~~bash
moon update
moon check --deny-warn --target all
moon test --deny-warn --target all
moon fmt --check
moon info
~~~

GitHub Actions runs the current stable MoonBit installer on Ubuntu, macOS, and Windows, then checks dependencies, all supported targets, formatting, generated interfaces, native coverage where the runner supports it, and CLI smoke paths. The publish workflow is manual and never stores credentials in the repository.

## Provenance and license

The implementation is MoonBit-first and uses repository-local deterministic examples. Source and asset provenance notes are maintained in [\`PROVENANCE.md\`](PROVENANCE.md). The project is licensed under Apache-2.0; see [\`LICENSE\`](LICENSE).

## Contributing

See [\`CONTRIBUTING.md\`](CONTRIBUTING.md) for development commands, test expectations, API compatibility guidance, and fixture rules.

