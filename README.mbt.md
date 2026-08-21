# moonbit-posterkit

\`moonbit-posterkit\` is a typed MoonBit toolkit for deterministic SVG posters, covers, social cards, and campaign packs.

## Quick Start

~~~mbt check
let preset = @dgmxjj/moonbit-posterkit/preset.PosterPreset::instagram_square()
let theme = @dgmxjj/moonbit-posterkit/theme.Theme::warm_editorial()
let document = @dgmxjj/moonbit-posterkit/scene.PosterDocument::empty(
  title="MoonBit PosterKit",
  preset~,
  theme~,
)
let svg = @dgmxjj/moonbit-posterkit/svg.render_svg(document)
assert svg.contains("<svg")
~~~

The library provides scene elements, poster presets, themes, deterministic layout, CJK/Latin text flow, reusable templates, strict batch validation, SVG metrics, PNG/JPEG asset inspection, deterministic PNG/PDF export, and a native CLI.

## Package map

- \`core\`: geometry and constraints
- \`preset\`: canvas sizes and orientation helpers
- \`theme\`: palettes and contrast reports
- \`scene\`: document DSL, validation, analysis, normalization
- \`layout\`: stack, grid, flow, and envelope measurement
- \`textflow\`: wrapping and bounded text measurement
- \`template\`: built-in templates and content profiles
- \`config\`: JSON batches, strict validation, metrics, and output plans
- \`assets\`: PNG/JPEG metadata inspection and aspect-ratio fitting
- \`export\`: deterministic PNG encoding and single-page PDF export
- \`svg\`: stable SVG rendering and validation
- \`catalog\` and \`manifest\`: campaign packs and catalog exports
- \`quality\`: document, SVG, and batch audit reports

## Verification

~~~bash
moon check --deny-warn --target all
moon test --deny-warn --target all
moon fmt --check
moon info
~~~

See the root README for CLI examples, benchmark fixtures, provenance, and contribution guidance.

## License

Apache-2.0
