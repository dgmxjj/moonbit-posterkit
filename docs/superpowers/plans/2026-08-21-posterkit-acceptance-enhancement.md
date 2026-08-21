# Posterkit Acceptance Enhancement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Extend \`dgmxjj/moonbit-posterkit\` into a production-oriented SVG-first MoonBit poster toolkit with real measurement, layout, validation, batch, benchmark, tests, documentation, CI, and Mooncakes release evidence while preserving all existing public APIs.

**Architecture:** Add capability in focused package-local layers. \`core\` owns shared value types, \`layout\` and \`textflow\` own deterministic measurement, \`scene\` owns document diagnostics, \`config\` owns strict validation and batch metrics, \`svg\` owns stable serialization, and \`cli_support\` owns filesystem-facing commands. Existing constructors, enums, commands, and output behavior remain valid; new behavior is additive.

**Tech Stack:** MoonBit stable toolchain, \`moonbitlang/x\`, MoonBit tests, deterministic SVG fixtures, GitHub Actions, native CLI smoke tests, \`moon info\`, and Mooncakes publishing through the authenticated MoonBit toolchain.

## Global Constraints

- Do not modify \`docs/application.md\`; it is a read-only proposal input.
- Preserve existing public APIs and existing CLI command semantics.
- MoonBit remains the primary implementation language; no filler code or unverified metrics.
- Keep fixtures deterministic and repository-local; no network access at test runtime.
- Use Apache-2.0-compatible code and document external sources or generated artifacts.
- Count implementation, tests, and interfaces separately; report only measured line counts.
- Do not put internal proposal, acceptance, applicant, or contributor-process language in README files.
- Every implementation task follows write test -> run failing test -> implement -> run targeted tests -> format/check.
- Keep \`docs/application.md\` out of all commits unless explicitly requested.

## File Map

| Area | Files | Responsibility |
| --- | --- | --- |
| Shared geometry | \`src/core/types.mbt\`, new \`geometry.mbt\`, tests | Sizes, rectangles, constraints, safe arithmetic. |
| Layout | \`src/layout/layout.mbt\`, new measurement/diagnostic files and tests | Deterministic stack/grid/anchor measurement. |
| Scene validation | \`src/scene/validation.mbt\`, tests | IDs, geometry, layer and asset-slot validation. |
| Text flow | \`src/textflow/textflow.mbt\`, new line-break file and tests | Wrapping, line clamp, truncation, text metrics. |
| SVG | \`src/svg/svg.mbt\`, new style file and tests | Stable escaping, style serialization, render metrics. |
| Config/batch | \`src/config/*.mbt\`, new diagnostics/metrics files and tests | Strict validation, errors, batch summaries. |
| CLI | \`src/cli_support/*\`, \`src/cli/main.mbt\` | Strict validation, inspect, benchmark, smoke paths. |
| Evidence/docs | \`examples/benchmarks\`, \`docs/benchmarks\`, README files, changelog | Reproducible usage and measured benchmark output. |
| Automation | \`.github/workflows/test.yml\`, \`.github/workflows/publish.yml\` | Stable-toolchain CI and safe manual release. |

## Task 1: Verified Baseline

**Files:** No source changes; command output only.

**Interfaces:** Consumes the current repository and produces a baseline record without creating a repository artifact.

- [ ] Record \`git status --short --branch\`, \`git log --oneline --decorate -12\`, \`git remote show origin\`, and \`moon version --all\`.
- [ ] Run \`moon install\`, \`moon check --target all\`, \`moon test --target all\`, \`moon fmt --check\`, and \`moon info\`. Record failures before changing code.
- [ ] Count tracked \`src/**/*.mbt\` and \`src/**/*.mbti\) while excluding \`_build\`, \`.mooncakes\`, and generated build directories. Keep the count in the work log until final verification.
- [ ] Leave the user’s existing \`docs/application.md\` change untouched. Do not commit a baseline file.

## Task 2: Safe Geometry and Measurement Primitives

**Files:**
- Modify: \`src/core/types.mbt\`
- Create: \`src/core/geometry.mbt\`, \`src/core/geometry_test.mbt\`
- Test: \`src/core/types_test.mbt\`

**Interfaces:** Add, without changing existing values:

~~~mbt
pub(all) struct Constraints {
  min_width : Int
  max_width : Int
  min_height : Int
  max_height : Int
}
pub(all) struct RectOverflow {
  left : Int
  top : Int
  right : Int
  bottom : Int
}
pub fn Constraints::unbounded() -> Constraints
pub fn Constraints::tight(size : Size) -> Constraints
pub fn Constraints::constrain(self : Constraints, size : Size) -> Size
pub fn Rect::size(self : Rect) -> Size
pub fn Rect::translate(self : Rect, delta : Point) -> Rect
pub fn Rect::overflow(self : Rect, region : Rect) -> RectOverflow
~~~

- [ ] Write tests for tight/unbounded constraints, negative inputs, translation, insets smaller than zero, and overflow on each edge.
- [ ] Run \`moon test src/core --filter 'geometry|types'\` and confirm the new tests fail before implementation.
- [ ] Implement normalized constraints and additive rectangle helpers. Preserve legacy \`Rect::inset\` behavior; add a separately named safe helper when needed.
- [ ] Run \`moon test src/core\`, \`moon check src/core\`, and \`moon fmt\`.
- [ ] Commit \`feat: add safe geometry and constraint primitives\`.

## Task 3: Deterministic Layout Measurement and Diagnostics

**Files:**
- Modify: \`src/layout/layout.mbt\`, \`src/layout/moon.pkg\`
- Create: \`src/layout/measure.mbt\`, \`src/layout/diagnostics.mbt\`, \`src/layout/measure_test.mbt\`, \`src/layout/diagnostics_test.mbt\`

**Interfaces:** Add:

~~~mbt
pub(all) enum LayoutWarning {
  NegativeGap(value~ : Int)
  ClippedChild(index~ : Int, overflow~ : @core.RectOverflow)
  EmptyRegion
  InvalidGrid
} derive(Debug, Eq)

pub(all) struct LayoutResult {
  frames : Array[@scene.Rect]
  warnings : Array[LayoutWarning]
  used : @core.Size
} derive(Debug, Eq)

pub fn measure_stack_vertical(
  region~ : @scene.Rect,
  item_heights~ : Array[Int],
  gap~ : Int,
  constraints~ : @core.Constraints,
) -> LayoutResult
pub fn measure_grid(
  region~ : @scene.Rect,
  spec~ : @scene.GridSpec,
  constraints~ : @core.Constraints,
) -> LayoutResult
~~~

- [ ] Add tests for empty regions, zero children, negative gaps, clipping, grid remainder distribution, oversized padding, invalid row/column counts, and stable frame order.
- [ ] Run \`moon test src/layout\` and confirm the new tests fail.
- [ ] Implement new measurement functions using core helpers; keep \`stack_vertical\`, \`grid\`, and \`anchor\` signatures intact.
- [ ] Run \`moon test src/layout\`, \`moon check src/layout\`, and \`moon fmt --check\`.
- [ ] Commit \`feat: add deterministic layout measurement diagnostics\`.

## Task 4: Scene and Asset-Slot Validation

**Files:**
- Modify: \`src/scene/scene.mbt\`, \`src/scene/moon.pkg\`
- Create: \`src/scene/validation.mbt\`, \`src/scene/validation_test.mbt\`

**Interfaces:** Add:

~~~mbt
pub(all) enum SceneDiagnostic {
  EmptyTitle
  EmptyElementId(index~ : Int)
  DuplicateElementId(id~ : String)
  InvalidRect(id~ : String)
  EmptyAssetId(id~ : String)
  EmptyImageLabel(id~ : String)
  TextOutsideCanvas(id~ : String)
} derive(Debug, Eq)

pub fn validate_document(
  document : @scene.PosterDocument,
  strict~ : Bool,
) -> Array[SceneDiagnostic]
pub fn element_ids(document : @scene.PosterDocument) -> Array[String]
~~~

- [ ] Write black-box tests using existing public constructors for empty titles, duplicate IDs, invalid rectangles, missing asset IDs, text outside the preset canvas, and valid documents.
- [ ] Run \`moon test src/scene --filter 'validation'\` and confirm failure before implementation.
- [ ] Traverse elements in array order and emit deterministic diagnostics. Strict mode reports structural violations; no file reads or network fetches are introduced.
- [ ] Run \`moon test src/scene\`, \`moon check src/scene\`, and \`moon fmt --check\`.
- [ ] Commit \`feat: validate scene structure and asset slots\`.

## Task 5: Bounded Text Measurement and Truncation

**Files:**
- Modify: \`src/textflow/textflow.mbt\`, \`src/textflow/moon.pkg\`, \`src/textflow/textflow_test.mbt\`
- Create: \`src/textflow/line_break.mbt\`, \`src/textflow/line_break_test.mbt\`

**Interfaces:** Add:

~~~mbt
pub(all) struct TextMeasure {
  lines : Array[String]
  width : Int
  height : Int
  truncated : Bool
} derive(Debug, Eq)

pub fn measure_text(
  content : String,
  style : @scene.TextStyle,
  max_width~ : Int,
  max_lines~ : Int,
) -> TextMeasure
pub fn truncate_text(content : String, max_chars~ : Int, ellipsis~ : String) -> String
pub fn split_lines(content : String) -> Array[String]
~~~

- [ ] Add tests for whitespace-only strings, repeated spaces, explicit newlines, punctuation, mixed CJK/Latin, emoji-safe characters, max width 1, max lines 0/1, and exact-fit overflow.
- [ ] Run \`moon test src/textflow\` and confirm the new tests fail.
- [ ] Preserve current \`wrap_text\` behavior for existing callers; make truncation deterministic and report whether output was truncated.
- [ ] Run package tests, dependent checks, and \`moon fmt --check\`.
- [ ] Commit \`feat: add bounded text measurement and truncation\`.

## Task 6: Stable SVG Styles, Escaping, and Metrics

**Files:**
- Modify: \`src/svg/svg.mbt\`, \`src/svg/moon.pkg\`, \`src/svg/render_test.mbt\`
- Create: \`src/svg/style.mbt\`, \`src/svg/style_test.mbt\`

**Interfaces:** Add:

~~~mbt
pub(all) struct SvgMetrics {
  element_count : Int
  text_count : Int
  image_slot_count : Int
  bytes : Int
} derive(Debug, Eq)

pub fn render_svg_with_metrics(
  document : @scene.PosterDocument,
) -> (String, SvgMetrics)
pub fn escape_text(value : String) -> String
pub fn escape_attribute(value : String) -> String
~~~

- [ ] Write tests for \`&\`, \`<\`, \`>\`, quotes in attributes, empty elements, negative/large coordinates, style colors, stable ordering, and metric counts.
- [ ] Run \`moon test src/svg\` and verify new tests fail while existing fixtures identify compatibility constraints.
- [ ] Factor stable escaping and formatting into additive helpers; preserve existing \`render_svg\` output for current fixtures.
- [ ] Run \`moon test src/svg\`, \`moon check --target all\`, and \`moon fmt --check\`.
- [ ] Commit \`feat: add stable svg metrics and escaping helpers\`.

## Task 7: Strict Config Validation and Batch Metrics

**Files:**
- Modify: \`src/config/config.mbt\`, \`src/config/moon.pkg\`, \`src/config/config_test.mbt\`
- Create: \`src/config/diagnostics.mbt\`, \`src/config/batch_metrics.mbt\`, \`src/config/diagnostics_test.mbt\`, \`src/config/batch_metrics_test.mbt\`

**Interfaces:** Add:

~~~mbt
pub(all) struct BatchMetrics {
  total : Int
  succeeded : Int
  failed : Int
  total_svg_bytes : Int
  average_svg_bytes : Int
} derive(Debug, Eq, ToJson)

pub(all) struct ValidationIssue {
  job_index : Int
  field : String
  code : String
  message : String
} derive(Debug, Eq, ToJson)

pub fn validate_batch_strict(
  batch : BatchJob,
) -> Result[ValidationSummary, Array[ValidationIssue]]
pub fn render_batch_with_metrics(
  batch : BatchJob,
) -> Result[(Array[RenderedPoster], BatchMetrics), ConfigError]
~~~

- [ ] Test empty batches, empty/duplicate slugs, unknown names, invalid fields, stable issue order, zero-success metrics, mixed batch metrics, and byte-count correctness.
- [ ] Run \`moon test src/config\` and confirm new tests fail.
- [ ] Keep existing \`validate_batch\` and \`render_batch\` behavior intact; add strict diagnostics and a separate metrics path.
- [ ] Run package/dependent tests and \`moon check --target all\`.
- [ ] Commit \`feat: add strict batch diagnostics and render metrics\`.

## Task 8: Inspect, Strict Validate, and Benchmark CLI

**Files:**
- Modify: \`src/cli_support/cli_support.mbt\`, \`parse.mbt\`, \`run.mbt\`, \`format.mbt\`, \`moon.pkg\`, \`src/cli/main.mbt\`
- Create: \`src/cli_support/benchmark.mbt\`, \`inspect.mbt\`, tests, and fixtures in \`examples/benchmarks/\`

**Interfaces:** Add command variants \`Inspect(input~ : String)\`, \`Benchmark(input~ : String, iterations~ : Int)\`, and \`ValidateStrict(input~ : String)\` while retaining existing variants.

- [ ] Write parser/formatter tests for missing arguments, \`--strict\`, default/invalid iterations, and stable JSON/text output; run \`moon test src/cli_support\` and confirm failure.
- [ ] Implement \`inspect\` without writing files, strict validation through structured diagnostics, and benchmark aggregation with total/average/min/max duration, throughput, SVG bytes, and failures.
- [ ] Keep timing in native CLI code if a target lacks a timer API; keep pure aggregation testable.
- [ ] Add deterministic fixtures for small, mixed-CJK, and 10/50-task batches.
- [ ] Run native smoke tests: \`moon run --target native src/cli validate --strict examples/batches/hackathon-showcase.json\`; \`inspect\`; and \`benchmark ... --iterations 3\`.
- [ ] Commit \`feat: add strict inspection and benchmark cli commands\`.

## Task 9: Expand Reusable Template and Catalog Coverage

**Files:**
- Modify: \`src/template/template.mbt\`, tests, \`src/catalog/catalog.mbt\`, tests, \`src/catalog_meta/packs.mbt\`
- Create: \`src/template/variants.mbt\`, tests, and batch examples \`release-matrix.json\`, \`event-series.json\`

- [ ] Write contract tests for materially different portrait, landscape, dense-metadata, and image-slot variants, including required/default fields, deterministic SVG, and long/CJK content.
- [ ] Run template/catalog tests and confirm only new tests fail.
- [ ] Implement a small set of variants using shared helpers; do not duplicate large template bodies or change existing names/output contracts.
- [ ] Render examples with the native CLI, inspect SVG text, and ensure no local absolute paths.
- [ ] Commit \`feat: expand reusable poster template catalog\`.

## Task 10: Reproducible Benchmarks and Mature Documentation

**Files:**
- Create: \`docs/benchmarks/README.md\`, \`docs/benchmarks/latest-native.txt\`, \`CHANGELOG.md\`, \`CONTRIBUTING.md\`
- Modify: \`README.md\`, \`README.mbt.md\`, \`PROVENANCE.md\`

- [ ] Run fixed benchmark fixtures on native and record exact MoonBit version, OS, command, iterations, total/average/min/max timing, throughput, SVG bytes, and failures.
- [ ] Rewrite README into positioning, features, install/quick start, package/API map, CLI, configuration/templates, benchmarks, tests/CI, provenance, contribution, and license sections.
- [ ] Remove internal competition/process language and stale \`0.10.3\` claims. Do not state source counts or performance numbers until command output verifies them.
- [ ] Run all README/test extraction checks supported by the installed toolchain and commit \`docs: document production workflows and benchmarks\`.

## Task 11: Upgrade CI and Publish Workflow

**Files:** \`.github/workflows/test.yml\`, \`.github/workflows/publish.yml\`, \`.gitignore\`

- [ ] Align test workflow with the community template: three OS matrix, official installer, \`moon version --all\`, \`moon update\`, \`moon check --target all\`, \`moon test --target all\`, format diff check, and \`moon info\` diff check.
- [ ] On Ubuntu add \`moon test --deny-warn --target native --enable-coverage\`, coverage summary/analyze when supported, and CLI smoke commands. Do not hide unsupported-tool failures.
- [ ] Update publish workflow to the stable installer, \`moon update\`, full prepublish checks, secret-backed credentials, cleanup, and manual dispatch only.
- [ ] Validate YAML locally if a parser is available and inspect Windows/Unix shell differences.
- [ ] Commit \`ci: align checks with current MoonBit stable workflows\`.

## Task 12: Final Verification, Self-Review, Publish, and Push

**Files:** Only final defect fixes in files above; never \`docs/application.md\`.

- [ ] Run \`moon install\`, \`moon update\`, \`moon check --deny-warn --target all\`, \`moon test --deny-warn --target all\`, native coverage tests, \`moon fmt --check\`, \`moon fmt\`, \`moon info\`, and \`git diff --exit-code\`. Any failure requires root-cause investigation before a fix.
- [ ] Run strict validation, inspect, benchmark, render, batch, pack emission, and catalog export against committed fixtures. Review generated artifacts and clean only temporary files in the workspace.
- [ ] Count implementation/test/interface lines excluding build/cache paths; inspect hygiene, \`git log\`, \`git remote show origin\`, and default branch. If effective scale is below 8,000, do not invent lines; identify a missing approved capability or report the shortfall.
- [ ] Apply the published \`osc2026-guide\` checklist to structure, README, license, history, default branch, source scale, CI, examples, provenance, Mooncakes readiness, and GitHub-only hackathon scope. Separate facts from uncertain remote facts.
- [ ] Verify \`moon login\` and publish with the authenticated stable toolchain after all local gates pass. Capture actual output; bump version only if the toolchain requires it and record the reason.
- [ ] Commit only final project files with \`chore: finalize hackathon acceptance release\`; confirm \`docs/application.md\` is absent from the commit.
- [ ] Push \`main\) to origin and verify with \`git ls-remote --heads origin main\`, \`git log origin/main -1 --oneline\`, and \`gh auth status\`.

## Plan Self-Review

- Coverage: measurement, layout, diagnostics, text, SVG, config, CLI, templates, benchmarks, tests, README, CI, publication, source-scale audit, and remote verification each have dedicated tasks.
- Placeholder scan: no TBD/TODO or undefined future work is used as an implementation step; commands and file paths are explicit.
- Type consistency: new \`Constraints\`, \`RectOverflow\`, \`LayoutResult\`, \`SceneDiagnostic\`, \`TextMeasure\`, \`SvgMetrics\`, \`BatchMetrics\`, and \`ValidationIssue\` names are introduced once and consumed later without changing existing types.
- Scope: all tasks support the approved SVG-first poster toolkit; PNG/PDF, editor UI, remote asset fetching, and unrelated refactors remain excluded.
- Safety: the proposal document is never modified; generated artifacts stay within the workspace; credentials are never committed.

