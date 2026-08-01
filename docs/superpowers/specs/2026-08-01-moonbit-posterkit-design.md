# moonbit-posterkit Design

## Summary

`moonbit-posterkit` is a MoonBit-first, SVG-first, data-driven poster and cover generation library.
It is designed for social media cards, article covers, event posters, quote cards, and launch graphics.
The project should feel like a complete poster-generation toolkit rather than a generic drawing library.

The repository will center on a typed scene DSL, a lightweight poster-oriented layout engine, reusable theme and template definitions, deterministic SVG rendering, and a small CLI for single-shot and batch generation.

## Why This Project

The August 2026 MoonBit hackathon asks for projects that are practically useful, avoid heavy overlap with mature MoonBit ecosystem packages, include CI, tests, examples, documentation, and show long-term maintenance value.

Current Mooncakes ecosystem research shows strong building blocks already exist:

- Canvas and raster backends
- SVG and vector graphics libraries
- Layout kernels
- Text shaping and typography support
- Image codecs and image processing libraries
- General-purpose template engines

However, there is not a mature MoonBit package focused on poster or cover generation as a typed, reusable, data-driven DSL. This creates a good ecosystem gap: `moonbit-posterkit` can sit above the existing graphics stack and provide a real content-production workflow instead of re-implementing low-level rendering primitives.

## Product Definition

### One-Line Positioning

`moonbit-posterkit` is a typed MoonBit DSL and template system for generating SVG posters, covers, and social media graphics from structured data.

### Primary Use Cases

- Article and newsletter cover generation
- Event and meetup posters
- Quote cards
- Product launch and feature announcement cards
- Social media multi-size batch exports

### Non-Goals for v0.1

- Full design-tool editor core
- Browser-based visual editor
- Complete HTML/CSS layout engine
- Rich text engine with full browser-grade text layout
- PNG-first or bitmap-first rendering pipeline
- Full asset management platform

## Output Strategy

The project is explicitly `SVG-first`.

Reasons:

- SVG is a natural format for posters, covers, and social cards
- Output remains editable and inspectable
- Snapshot testing is practical because the output is text
- The renderer can stay deterministic
- It avoids over-expanding scope into raster-first rendering early

PNG export is not part of the first milestone. It may be documented later as an integration path via external tools or future optional backends.

## User Experience Goals

The project should support two layers of use:

### Layer 1: Typed Scene DSL

Advanced users can build poster scenes in MoonBit code using typed primitives and layout nodes.

### Layer 2: Template-Driven Rendering

Most users should be able to choose a built-in template, provide structured data, select a preset size, and render SVG without writing a custom layout tree from scratch.

This split is important. If the project only exposes a generic scene API, it risks feeling like a low-level drawing library. If it only exposes baked templates, it risks being too narrow. The repository needs both.

## Functional Scope

### Included in v0.1

#### Canvas and Presets

- Fixed-size poster canvas
- Width and height presets
- Common social and content sizes
- Named preset registry

#### Scene DSL

- `Scene`
- `Frame`
- `Stack`
- `Group`
- `Rect`
- `Text`
- `Image`
- `Badge`
- `Spacer`

These are enough to build meaningful posters without dragging in a full design engine.

#### Layout Model

- Vertical stacking
- Horizontal stacking
- Gap
- Padding
- Alignment
- Layer order
- Absolute positioning for a small subset of components
- Optional clipping inside image frames

The layout model should be intentionally smaller than flexbox. It should target poster composition, not general UI layout.

#### Text Blocks

- Title
- Subtitle
- Body or summary
- Caption
- Tag or label rows
- Date, author, metadata rows

Support should include:

- Font slot selection by theme
- Font size
- Weight token or style token
- Line height
- Max lines
- Ellipsis policy
- Alignment

#### Images

- Placeholder slots
- `cover` placement
- `contain` placement
- Focused crop hints
- Rounded corners
- Optional overlay or tint layer

#### Themes

- Color palette tokens
- Background tokens
- Text role tokens
- Radius tokens
- Shadow tokens
- Spacing scale

Themes should be declarative and reusable across templates.

#### Templates

Built-in templates for:

- `article_cover`
- `event_poster`
- `quote_card`
- `launch_card`

Each template should support at least three sizes where practical.

#### Data Binding

- Binding record-like input data into template fields
- Validation for required variables
- Defaults for optional fields
- Stable render errors for missing or malformed fields

#### Renderer

- Deterministic SVG string output
- Stable node ordering
- Stable attribute formatting
- Explicit escaping rules for text and attribute values

#### CLI

Minimal but real CLI commands:

- Render one SVG from one template and one input file
- Batch render multiple SVGs from one template and multiple inputs
- List built-in templates
- List built-in presets
- Validate input against a template schema

#### Examples

- Single-file typed DSL example
- Template render example
- Batch social-card example
- End-to-end CLI example

#### Testing and CI

- Unit tests
- Snapshot tests for SVG output
- Template validation tests
- CLI smoke tests
- CI with formatting, info generation, check, and test

### Explicitly Excluded from v0.1

- Visual template editor
- Arbitrary vector path editing
- Full text shaping and multilingual typography engine ownership
- Complex flowing text across regions
- Runtime image downloading from remote URLs
- Animation or timeline output
- Binary asset packer

## Architecture

The render pipeline should be:

`Template/Data -> Scene Graph -> Layout Pass -> SVG Renderer`

This keeps the project understandable and testable.

### Core Principles

- Typed APIs first
- Deterministic rendering
- Minimal ownership of low-level graphics complexity
- Templates are built on top of the same scene system exposed to users
- Scene and layout are decoupled from SVG formatting details
- Public APIs should stay small and composable

## Repository Structure

The repository should use a multi-package MoonBit module layout.

```text
moonbit-posterkit/
  moon.mod
  README.md
  CHANGELOG.md
  LICENSE
  .gitignore
  .github/workflows/
  docs/
    design/
    examples/
    formats/
  examples/
    simple-cover/
    article-card/
    batch-social/
  cmd/
    posterkit/
  src/
    core/
    geom/
    style/
    scene/
    layout/
    text/
    image/
    template/
    preset/
    render/svg/
    data/
    cli_support/
  templates/
    article_cover/
    event_poster/
    quote_card/
    launch_card/
  testdata/
    fixtures/
    snapshots/
```

## Package Plan

### `@moonbit-posterkit/core`

Owns:

- public shared types
- dimensions
- edge insets
- alignment enums
- public error surface used widely

### `@moonbit-posterkit/geom`

Owns:

- `Point`
- `Size`
- `Rect`
- inset and offset helpers
- clipping math

### `@moonbit-posterkit/style`

Owns:

- colors
- gradients
- stroke and fill styles
- corner radii
- shadows
- theme tokens

### `@moonbit-posterkit/scene`

Owns:

- public scene node types
- `Scene`
- `Node`
- `Frame`
- `Stack`
- `Group`
- `Rect`
- `Text`
- `Image`
- `Badge`
- `Spacer`

This is the main typed DSL layer.

### `@moonbit-posterkit/layout`

Owns:

- poster-oriented layout solving
- stack measurement
- child positioning
- frame padding handling
- alignment handling

This is not a general UI engine. It should be intentionally narrow and deterministic.

### `@moonbit-posterkit/text`

Owns:

- text block specs
- wrapping heuristics
- line clamp logic
- metadata row composition helpers

The first release should use predictable heuristics rather than trying to exactly match a browser.

### `@moonbit-posterkit/image`

Owns:

- image source representation
- image placement policies
- crop mode
- image slot helpers

### `@moonbit-posterkit/template`

Owns:

- template definition
- template variable descriptors
- required field validation
- template render entrypoints

### `@moonbit-posterkit/preset`

Owns:

- named size presets
- built-in template registry
- theme registry

### `@moonbit-posterkit/render/svg`

Owns:

- scene to SVG conversion
- escaping rules
- element ordering
- formatting normalization

### `@moonbit-posterkit/data`

Owns:

- mapping structured input into template context
- basic JSON-friendly data access helpers

### `@moonbit-posterkit/cli_support`

Owns:

- CLI-facing parsing helpers
- file loading
- output path planning
- error display helpers

### Facade Package

The root public package should re-export the ergonomic surface needed by normal users so the package is easy to adopt from Mooncakes.

## Public API Direction

The user-facing surface should encourage two styles.

### Typed Composition

Users can construct posters directly in MoonBit:

```mbt
let scene =
  Poster::scene(
    size=Preset::x_post(),
    theme=Theme::modern_blue(),
    body=Stack::v(
      [
        Text::title("MoonBit PosterKit"),
        Text::subtitle("Data-driven SVG poster generation"),
        Image::cover("cover.png", height=360),
        Badge::row(["MoonBit", "SVG", "DSL"]),
      ],
      gap=24,
      padding=EdgeInsets::all(48),
    ),
  )
```

### Template Rendering

Users can render from built-in templates:

```mbt
let svg =
  Templates::article_cover().render({
    "title": "MoonBit PosterKit",
    "subtitle": "Data-driven SVG poster generation",
    "tags": ["MoonBit", "SVG", "DSL"],
    "cover": "cover.png",
  })
```

These APIs are illustrative and may evolve slightly during implementation, but the typed-scene-plus-template split is a hard requirement.

## Built-In Template Set

### `article_cover`

Purpose:

- article hero image
- newsletter cover
- blog card

Fields:

- title
- subtitle
- tags
- cover image
- author or source

### `event_poster`

Purpose:

- meetup poster
- workshop announcement
- conference card

Fields:

- event name
- date
- location
- description
- call to action
- optional background image

### `quote_card`

Purpose:

- short quote share card
- social post graphic

Fields:

- quote text
- speaker
- role or attribution
- brand badge

### `launch_card`

Purpose:

- product release
- feature announcement

Fields:

- product name
- slogan
- feature tags
- screenshot or hero asset

## Preset Strategy

Built-in presets should cover:

- square social card
- portrait social post
- landscape share card
- article cover wide
- Open Graph friendly card
- A4 portrait poster

Preset values should be stable named objects, not ad hoc width-height tuples scattered across examples.

## Rendering Constraints

The SVG renderer should favor stability over cleverness.

Requirements:

- deterministic attribute ordering
- deterministic child ordering
- normalized numeric formatting
- explicit viewBox and width-height output
- stable escaping for text content
- stable ID generation or no generated IDs where possible

This is critical for snapshot tests and CI.

## Error Model

The project should expose explicit errors for:

- missing template variables
- invalid preset names
- unsupported image fit mode combinations
- invalid layout configuration
- invalid scene dimensions
- file loading failures in CLI mode

Error messages should be human-readable because the CLI is part of the evaluation surface.

## CLI Design

The first CLI should be intentionally small but demonstrably useful.

Commands:

- `posterkit render --template <name> --input <file> --out <file>`
- `posterkit batch --template <name> --input <file> --out-dir <dir>`
- `posterkit list-templates`
- `posterkit list-presets`
- `posterkit validate --template <name> --input <file>`

CLI scope is there to prove usability, support examples, and strengthen hackathon deliverability.

## Testing Strategy

The project should follow TDD during implementation.

### Unit Tests

For:

- geometry helpers
- spacing and alignment logic
- image placement calculations
- template validation
- preset registry

### Snapshot Tests

For:

- SVG output of built-in templates
- SVG output of low-level typed scenes

### Example Tests

For:

- examples compile and render

### CLI Tests

For:

- command parsing
- render smoke path
- validate path

## Documentation Strategy

The repository must read like a real project.

Required documentation:

- top-level README with project positioning and examples
- example gallery section
- template usage docs
- preset reference
- DSL quick start
- CLI usage
- format and output notes
- explicit non-goals and current limitations

## CI and Quality Gates

The hackathon requirements emphasize CI, runnable tests, examples, and MoonBit hygiene.

The repository should include CI checks for:

- `moon fmt --deny-warn`
- `moon info --deny-warn`
- `moon check`
- `moon test`

If the toolchain version must be pinned or documented for MoonBit `0.10.3`, that requirement should be reflected in CI configuration and README installation notes during implementation.

## Hackathon Delivery Requirements

The final repository must satisfy these project-wide constraints:

- MoonBit is the primary implementation language
- repository is public and accessible
- clear, complete README
- project purpose, major functions, and usage documented
- runnable examples included
- CI configured
- runnable tests included
- project builds successfully
- release published to Mooncakes
- development history is traceable
- project has clear boundaries and maintenance value
- third-party code and assets comply with open-source license requirements

Development artifacts should also intentionally support evaluation:

- meaningful git history with more than ten useful commits
- design notes
- example assets and outputs
- changelog entries

## Source and License Constraints

The implementation should avoid vague provenance.

Rules:

- do not introduce unknown-origin assets
- document font and image asset provenance
- use OSI-recognized licensing
- if external reference code is studied, note the source in design or docs
- do not represent borrowed implementation as original without attribution

## Scope Control

The project should land in a mature but controlled v0.1 shape.

To stay on schedule, the implementation should prioritize:

- typed scene DSL
- deterministic lightweight layout
- SVG renderer
- four built-in templates
- preset registry
- CLI render path
- tests and CI

Features that tempt scope growth, such as visual editing, PNG rendering, advanced typography, and broad third-party asset support, should be deferred.

## Success Criteria

The project is successful for the hackathon if:

- a new user can install or clone it and render a poster quickly
- examples work and are documented
- templates feel reusable rather than one-off demos
- the typed DSL is coherent
- generated SVG output is stable and testable
- the repository looks production-minded
- the package is distinct from existing low-level graphics packages
- the codebase is large enough to look substantial without becoming incoherent

## Implementation Direction

The next step after this spec is to write a detailed implementation plan that breaks the repository into small, test-driven tasks with explicit file paths, tests, commands, and commit boundaries.
