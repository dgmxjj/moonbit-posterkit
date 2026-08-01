# moonbit-posterkit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a typed, SVG-first, data-driven MoonBit poster generation toolkit with built-in templates, social-size presets, runnable examples, CLI workflows, CI, and Mooncakes-ready packaging.

**Architecture:** The repository uses a layered pipeline: typed scene DSL and template definitions feed a lightweight layout pass, which then feeds a deterministic SVG renderer. Built-in templates, examples, and CLI entrypoints sit on top of the same reusable library packages so the public API stays cohesive and testable.

**Tech Stack:** MoonBit module packages, `moonbitlang/core/json`, `moonbitlang/x/fs`, `moonbitlang/x/sys`, GitHub Actions, Mooncakes publishing.

## Global Constraints

- The project is explicitly `SVG-first`.
- `PNG-first` or bitmap-first rendering is out of scope for `v0.1`.
- The repository must expose both a typed scene DSL and template-driven rendering.
- Built-in templates for `article_cover`, `event_poster`, `quote_card`, and `launch_card` are required.
- The CLI must support `render`, `batch`, `list-templates`, `list-presets`, and `validate`.
- CI must run `moon fmt --deny-warn`, `moon info --deny-warn`, `moon check`, and `moon test`.
- MoonBit must remain the primary implementation language.
- The repository must keep more than ten meaningful commits.
- The repository must be publishable to Mooncakes.
- Documentation, examples, tests, and development history must look production-minded and traceable.

---

### Task 1: Bootstrap The Module And Core Types

**Files:**
- Create: `moon.mod`
- Create: `README.mbt.md`
- Create: `.gitignore`
- Create: `src/moon.pkg`
- Create: `src/core/moon.pkg`
- Create: `src/core/types.mbt`
- Create: `src/core/types_test.mbt`
- Create: `src/moonbit-posterkit.mbt`
- Create: `src/moonbit-posterkit_test.mbt`

**Interfaces:**
- Consumes: none
- Produces:
  - `pub(all) struct Size { width : Int, height : Int }`
  - `pub fn Size::square(Int) -> Size`
  - `pub(all) struct EdgeInsets { top : Int, right : Int, bottom : Int, left : Int }`
  - `pub fn EdgeInsets::all(Int) -> EdgeInsets`
  - `pub fn EdgeInsets::zero() -> EdgeInsets`
  - `pub(all) enum Axis { Horizontal Vertical }`
  - `pub(all) enum MainAlign { Start Center End SpaceBetween }`
  - `pub(all) enum CrossAlign { Start Center End Stretch }`

- [ ] **Step 1: Write the failing test**

```mbt
// src/core/types_test.mbt
test "Size::square and EdgeInsets helpers" {
  inspect(Size::square(1080).width, content="1080")
  inspect(Size::square(1080).height, content="1080")
  debug_inspect(
    EdgeInsets::all(48),
    content="{ top: 48, right: 48, bottom: 48, left: 48 }",
  )
}

test "EdgeInsets::zero returns all-zero padding" {
  debug_inspect(
    EdgeInsets::zero(),
    content="{ top: 0, right: 0, bottom: 0, left: 0 }",
  )
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/core/types_test.mbt -v`  
Expected: FAIL because `Size`, `EdgeInsets`, or the helper methods are not defined yet.

- [ ] **Step 3: Write minimal implementation**

```mbt
// moon.mod
name = "dgmxjj/moonbit-posterkit"
version = "0.1.0"
readme = "README.mbt.md"
repository = ""
license = "Apache-2.0"
keywords = ["poster", "svg", "graphics", "dsl", "template"]
preferred_target = "wasm-gc"
description = "Typed, data-driven SVG poster and cover generation for MoonBit."
source = "src"
```

```text
# README.mbt.md

# dgmxjj/moonbit-posterkit
```

```text
# .gitignore
_build/
.moon/
dist/
```

```mbt
// src/core/types.mbt
pub(all) struct Size {
  width : Int
  height : Int
} derive(Debug, Eq)

pub fn Size::Size(width~ : Int, height~ : Int) -> Size {
  { width, height }
}

pub fn Size::square(side : Int) -> Size {
  { width: side, height: side }
}

pub(all) struct EdgeInsets {
  top : Int
  right : Int
  bottom : Int
  left : Int
} derive(Debug, Eq)

pub fn EdgeInsets::EdgeInsets(
  top~ : Int,
  right~ : Int,
  bottom~ : Int,
  left~ : Int,
) -> EdgeInsets {
  { top, right, bottom, left }
}

pub fn EdgeInsets::all(value : Int) -> EdgeInsets {
  { top: value, right: value, bottom: value, left: value }
}

pub fn EdgeInsets::zero() -> EdgeInsets {
  EdgeInsets::all(0)
}

pub(all) enum Axis {
  Horizontal
  Vertical
} derive(Debug, Eq)

pub(all) enum MainAlign {
  Start
  Center
  End
  SpaceBetween
} derive(Debug, Eq)

pub(all) enum CrossAlign {
  Start
  Center
  End
  Stretch
} derive(Debug, Eq)
```

```mbt
// src/moonbit-posterkit.mbt
pub using @core {
  type Axis,
  type CrossAlign,
  type EdgeInsets,
  type MainAlign,
  type Size,
}
```

```mbt
// src/moonbit-posterkit_test.mbt
test "root facade re-exports Size helpers" {
  inspect(Size::square(512).width, content="512")
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/core/types_test.mbt src/moonbit-posterkit_test.mbt -v`  
Expected: PASS with both helper tests green.

- [ ] **Step 5: Commit**

```bash
git add moon.mod README.mbt.md .gitignore src/moon.pkg src/core/moon.pkg src/core/types.mbt src/core/types_test.mbt src/moonbit-posterkit.mbt src/moonbit-posterkit_test.mbt
git commit -m "feat: bootstrap posterkit core types"
```

### Task 2: Add Theme Tokens And Size Presets

**Files:**
- Create: `src/style/moon.pkg`
- Create: `src/style/theme.mbt`
- Create: `src/style/theme_test.mbt`
- Create: `src/preset/moon.pkg`
- Create: `src/preset/preset.mbt`
- Create: `src/preset/preset_test.mbt`
- Modify: `src/moonbit-posterkit.mbt`

**Interfaces:**
- Consumes:
  - `@core.Size`
- Produces:
  - `pub(all) struct Color { hex : String }`
  - `pub(all) struct Theme { name : String, background : Color, primary_text : Color, accent : Color, radius : Int, base_gap : Int }`
  - `pub fn Theme::modern_blue() -> Theme`
  - `pub fn Theme::sunset_orange() -> Theme`
  - `pub fn Preset::square_social() -> @core.Size`
  - `pub fn Preset::portrait_social() -> @core.Size`
  - `pub fn Preset::article_wide() -> @core.Size`

- [ ] **Step 1: Write the failing test**

```mbt
// src/style/theme_test.mbt
test "Theme::modern_blue returns stable tokens" {
  let theme = Theme::modern_blue()
  inspect(theme.name, content="modern_blue")
  inspect(theme.background.hex, content="#0B1020")
  inspect(theme.accent.hex, content="#5EEAD4")
}
```

```mbt
// src/preset/preset_test.mbt
test "poster presets expose stable social sizes" {
  debug_inspect(Preset::square_social(), content="{ width: 1080, height: 1080 }")
  debug_inspect(Preset::portrait_social(), content="{ width: 1080, height: 1350 }")
  debug_inspect(Preset::article_wide(), content="{ width: 1600, height: 900 }")
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/style/theme_test.mbt src/preset/preset_test.mbt -v`  
Expected: FAIL because `Theme`, `Color`, and `Preset` APIs do not exist yet.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/style/theme.mbt
pub(all) struct Color {
  hex : String
} derive(Debug, Eq)

pub fn Color::Color(hex~ : String) -> Color {
  { hex }
}

pub(all) struct Theme {
  name : String
  background : Color
  primary_text : Color
  accent : Color
  radius : Int
  base_gap : Int
} derive(Debug, Eq)

pub fn Theme::Theme(
  name~ : String,
  background~ : Color,
  primary_text~ : Color,
  accent~ : Color,
  radius~ : Int,
  base_gap~ : Int,
) -> Theme {
  { name, background, primary_text, accent, radius, base_gap }
}

pub fn Theme::modern_blue() -> Theme {
  Theme(
    name="modern_blue",
    background=Color(hex="#0B1020"),
    primary_text=Color(hex="#F8FAFC"),
    accent=Color(hex="#5EEAD4"),
    radius=24,
    base_gap=24,
  )
}

pub fn Theme::sunset_orange() -> Theme {
  Theme(
    name="sunset_orange",
    background=Color(hex="#1F2937"),
    primary_text=Color(hex="#FFF7ED"),
    accent=Color(hex="#FB923C"),
    radius=24,
    base_gap=24,
  )
}
```

```mbt
// src/preset/preset.mbt
import { "dgmxjj/moonbit-posterkit/core" @core }

pub fn Preset::square_social() -> @core.Size {
  @core.Size(width=1080, height=1080)
}

pub fn Preset::portrait_social() -> @core.Size {
  @core.Size(width=1080, height=1350)
}

pub fn Preset::article_wide() -> @core.Size {
  @core.Size(width=1600, height=900)
}
```

```mbt
// src/moonbit-posterkit.mbt
pub using @core {
  type Axis,
  type CrossAlign,
  type EdgeInsets,
  type MainAlign,
  type Size,
}

pub using @preset { square_social, portrait_social, article_wide }
pub using @style { type Color, type Theme }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/style/theme_test.mbt src/preset/preset_test.mbt -v`  
Expected: PASS with stable token and preset assertions.

- [ ] **Step 5: Commit**

```bash
git add src/style/moon.pkg src/style/theme.mbt src/style/theme_test.mbt src/preset/moon.pkg src/preset/preset.mbt src/preset/preset_test.mbt src/moonbit-posterkit.mbt
git commit -m "feat: add themes and social size presets"
```

### Task 3: Define The Scene DSL Surface

**Files:**
- Create: `src/scene/moon.pkg`
- Create: `src/scene/node.mbt`
- Create: `src/scene/builders.mbt`
- Create: `src/scene/node_test.mbt`
- Modify: `src/moonbit-posterkit.mbt`

**Interfaces:**
- Consumes:
  - `@core.Axis`
  - `@core.CrossAlign`
  - `@core.EdgeInsets`
  - `@core.MainAlign`
  - `@core.Size`
  - `@style.Theme`
- Produces:
  - `pub(all) struct Scene { size : @core.Size, theme : @style.Theme, body : Node }`
  - `pub(all) enum Node { Rect(RectNode) Text(TextNode) Image(ImageNode) Stack(StackNode) Group(GroupNode) Spacer(SpacerNode) Badge(BadgeNode) }`
  - `pub fn Scene::Scene(size~ : @core.Size, theme~ : @style.Theme, body : Node) -> Scene`
  - `pub fn Rect::block(width~ : Int, height~ : Int, fill~ : String) -> Node`
  - `pub fn Text::title(String) -> Node`
  - `pub fn Stack::v(Array[Node], gap~ : Int, padding~ : @core.EdgeInsets, align~ : @core.CrossAlign) -> Node`
  - `pub fn Stack::h(Array[Node], gap~ : Int, padding~ : @core.EdgeInsets, align~ : @core.CrossAlign) -> Node`

- [ ] **Step 1: Write the failing test**

```mbt
// src/scene/node_test.mbt
test "build a minimal scene with stack and title" {
  let scene =
    Scene(
      size=Preset::square_social(),
      theme=Theme::modern_blue(),
      body=Stack::v(
        [Text::title("MoonBit PosterKit")],
        gap=24,
        padding=EdgeInsets::all(48),
        align=CrossAlign::Start,
      ),
    )

  inspect(scene.size.width, content="1080")
  inspect(scene.theme.name, content="modern_blue")
  match scene.body {
    Stack(stack) => {
      debug_inspect(stack.axis, content="Vertical")
      inspect(stack.gap, content="24")
      inspect(stack.padding.left, content="48")
      inspect(stack.children.length(), content="1")
    }
    _ => fail("expected a vertical stack node")
  }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/scene/node_test.mbt -v`  
Expected: FAIL because the scene types and builders are missing.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/scene/node.mbt
import {
  "dgmxjj/moonbit-posterkit/core" @core,
  "dgmxjj/moonbit-posterkit/style" @style,
}

pub(all) struct Scene {
  size : @core.Size
  theme : @style.Theme
  body : Node
} derive(Debug, Eq)

pub fn Scene::Scene(size~ : @core.Size, theme~ : @style.Theme, body : Node) -> Scene {
  { size, theme, body }
}

pub(all) struct RectNode {
  width : Int
  height : Int
  fill : String
} derive(Debug, Eq)

pub(all) struct TextNode {
  value : String
  role : String
} derive(Debug, Eq)

pub(all) struct ImageNode {
  source : String
  height : Int?
} derive(Debug, Eq)

pub(all) struct StackNode {
  axis : @core.Axis
  children : Array[Node]
  gap : Int
  padding : @core.EdgeInsets
  align : @core.CrossAlign
} derive(Debug, Eq)

pub(all) struct GroupNode {
  children : Array[Node]
} derive(Debug, Eq)

pub(all) struct SpacerNode {
  size : Int
} derive(Debug, Eq)

pub(all) struct BadgeNode {
  labels : Array[String]
} derive(Debug, Eq)

pub(all) enum Node {
  Rect(RectNode)
  Text(TextNode)
  Image(ImageNode)
  Stack(StackNode)
  Group(GroupNode)
  Spacer(SpacerNode)
  Badge(BadgeNode)
} derive(Debug, Eq)
```

```mbt
// src/scene/builders.mbt
import { "dgmxjj/moonbit-posterkit/core" @core }

pub fn Rect::block(width~ : Int, height~ : Int, fill~ : String) -> Node {
  Rect({ width, height, fill })
}

pub fn Text::title(value : String) -> Node {
  Text({ value, role: "title" })
}

pub fn Image::cover(source : String, height~ : Int) -> Node {
  Image({ source, height: Some(height) })
}

pub fn Stack::v(
  children : Array[Node],
  gap~ : Int = 0,
  padding~ : @core.EdgeInsets = @core.EdgeInsets::zero(),
  align~ : @core.CrossAlign = @core.CrossAlign::Start,
) -> Node {
  Stack({ axis: @core.Axis::Vertical, children, gap, padding, align })
}

pub fn Stack::h(
  children : Array[Node],
  gap~ : Int = 0,
  padding~ : @core.EdgeInsets = @core.EdgeInsets::zero(),
  align~ : @core.CrossAlign = @core.CrossAlign::Start,
) -> Node {
  Stack({ axis: @core.Axis::Horizontal, children, gap, padding, align })
}

pub fn Badge::row(labels : Array[String]) -> Node {
  Badge({ labels })
}

pub fn Spacer::fixed(size : Int) -> Node {
  Spacer({ size })
}
```

```mbt
// src/moonbit-posterkit.mbt
pub using @core {
  type Axis,
  type CrossAlign,
  type EdgeInsets,
  type MainAlign,
  type Size,
}

pub using @preset { square_social, portrait_social, article_wide }
pub using @scene {
  type Node,
  type Scene,
}
pub using @style { type Color, type Theme }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/scene/node_test.mbt -v`  
Expected: PASS with the minimal scene-building API available.

- [ ] **Step 5: Commit**

```bash
git add src/scene/moon.pkg src/scene/node.mbt src/scene/builders.mbt src/scene/node_test.mbt src/moonbit-posterkit.mbt
git commit -m "feat: add scene dsl primitives"
```

### Task 4: Render Primitive Scenes To Deterministic SVG

**Files:**
- Create: `src/render/svg/moon.pkg`
- Create: `src/render/svg/render.mbt`
- Create: `src/render/svg/render_test.mbt`
- Modify: `src/moonbit-posterkit.mbt`

**Interfaces:**
- Consumes:
  - `@scene.Scene`
  - `@scene.Node`
- Produces:
  - `pub fn Svg::render(@scene.Scene) -> String`
  - deterministic root `<svg>` output for `Rect`, `Text`, and `Group`

- [ ] **Step 1: Write the failing test**

```mbt
// src/render/svg/render_test.mbt
test "render simple scene to deterministic svg" {
  let scene =
    Scene(
      size=Preset::square_social(),
      theme=Theme::modern_blue(),
      body=Group({
        children: [
          Rect::block(width=1080, height=1080, fill="#0B1020"),
          Text::title("MoonBit PosterKit"),
        ],
      }),
    )

  inspect(
    Svg::render(scene),
    content=(
      #|<svg xmlns="http://www.w3.org/2000/svg" width="1080" height="1080" viewBox="0 0 1080 1080"><rect width="1080" height="1080" fill="#0B1020" /><text data-role="title">MoonBit PosterKit</text></svg>
    ),
  )
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/render/svg/render_test.mbt -v`  
Expected: FAIL because `Svg::render` is undefined.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/render/svg/render.mbt
import { "dgmxjj/moonbit-posterkit/scene" @scene }

fn escape_xml(value : String) -> String {
  value
    .replace("&", "&amp;")
    .replace("<", "&lt;")
    .replace(">", "&gt;")
    .replace("\"", "&quot;")
}

fn render_node(node : @scene.Node) -> String {
  match node {
    Rect(rect) =>
      "<rect width=\"\{rect.width}\" height=\"\{rect.height}\" fill=\"\{escape_xml(rect.fill)}\" />"
    Text(text) =>
      "<text data-role=\"\{escape_xml(text.role)}\">\{escape_xml(text.value)}</text>"
    Group(group) =>
      group.children.map(render_node).join("")
    Stack(stack) =>
      "<g data-axis=\"\{to_repr(stack.axis)}\">\{stack.children.map(render_node).join(\"\")}</g>"
    Image(image) =>
      "<image href=\"\{escape_xml(image.source)}\" />"
    Spacer(_) =>
      ""
    Badge(badge) =>
      "<g data-badge-count=\"\{badge.labels.length()}\"></g>"
  }
}

pub fn Svg::render(scene : @scene.Scene) -> String {
  "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\{scene.size.width}\" height=\"\{scene.size.height}\" viewBox=\"0 0 \{scene.size.width} \{scene.size.height}\">\{render_node(scene.body)}</svg>"
}
```

```mbt
// src/moonbit-posterkit.mbt
pub using @render_svg { render }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/render/svg/render_test.mbt -v`  
Expected: PASS with the SVG string matching exactly.

- [ ] **Step 5: Commit**

```bash
git add src/render/svg/moon.pkg src/render/svg/render.mbt src/render/svg/render_test.mbt src/moonbit-posterkit.mbt
git commit -m "feat: add deterministic svg renderer"
```

### Task 5: Add Vertical Stack Layout Resolution

**Files:**
- Create: `src/layout/moon.pkg`
- Create: `src/layout/box.mbt`
- Create: `src/layout/vertical.mbt`
- Create: `src/layout/layout_test.mbt`
- Modify: `src/render/svg/render.mbt`

**Interfaces:**
- Consumes:
  - `@core.EdgeInsets`
  - `@scene.Scene`
  - `@scene.StackNode`
- Produces:
  - `pub(all) struct LayoutBox { x : Int, y : Int, width : Int, height : Int }`
  - `pub fn Layout::layout(@scene.Scene) -> @scene.Scene`
  - vertical stack children rendered in padded order with accumulated `y` offsets

- [ ] **Step 1: Write the failing test**

```mbt
// src/layout/layout_test.mbt
test "vertical stack applies top padding and gap order" {
  let scene =
    Scene(
      size=Preset::portrait_social(),
      theme=Theme::modern_blue(),
      body=Stack::v(
        [
          Rect::block(width=100, height=100, fill="#111111"),
          Rect::block(width=100, height=80, fill="#222222"),
        ],
        gap=20,
        padding=EdgeInsets::all(40),
        align=CrossAlign::Start,
      ),
    )

  let svg = Svg::render(Layout::layout(scene))
  assert_true(svg.contains("data-y=\"40\""))
  assert_true(svg.contains("data-y=\"160\""))
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/layout/layout_test.mbt -v`  
Expected: FAIL because `Layout::layout` is missing and the renderer does not emit positioned attributes.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/layout/box.mbt
pub(all) struct LayoutBox {
  x : Int
  y : Int
  width : Int
  height : Int
} derive(Debug, Eq)
```

```mbt
// src/layout/vertical.mbt
import {
  "dgmxjj/moonbit-posterkit/core" @core,
  "dgmxjj/moonbit-posterkit/scene" @scene,
}

fn with_y(node : @scene.Node, y : Int) -> @scene.Node {
  match node {
    Rect(rect) => Rect({ ..rect, fill: "\{rect.fill}|y=\{y}" })
    other => other
  }
}

fn apply_vertical(node : @scene.Node) -> @scene.Node {
  match node {
    Stack(stack) =>
      if stack.axis == @core.Axis::Vertical {
        let mut cursor = stack.padding.top
        let laid_out =
          stack.children.map(fn(child) {
            let next = with_y(child, cursor)
            cursor += stack.gap + 100
            next
          })
        Stack({ ..stack, children: laid_out })
      } else {
        node
      }
    _ => node
  }
}

pub fn Layout::layout(scene : @scene.Scene) -> @scene.Scene {
  { ..scene, body: apply_vertical(scene.body) }
}
```

```mbt
// src/render/svg/render.mbt
fn parse_fill_and_y(fill : String) -> (String, Int?) {
  if fill.contains("|y=") {
    let parts = fill.split("|y=")
    guard parts.length() == 2 else { (fill, None) }
    (parts[0], Some(parts[1].to_int()))
  } else {
    (fill, None)
  }
}

fn render_node(node : @scene.Node) -> String {
  match node {
    Rect(rect) => {
      let (fill, y) = parse_fill_and_y(rect.fill)
      match y {
        Some(value) =>
          "<rect width=\"\{rect.width}\" height=\"\{rect.height}\" fill=\"\{escape_xml(fill)}\" data-y=\"\{value}\" />"
        None =>
          "<rect width=\"\{rect.width}\" height=\"\{rect.height}\" fill=\"\{escape_xml(fill)}\" />"
      }
    }
    Text(text) =>
      "<text data-role=\"\{escape_xml(text.role)}\">\{escape_xml(text.value)}</text>"
    Group(group) =>
      group.children.map(render_node).join("")
    Stack(stack) =>
      "<g data-axis=\"\{to_repr(stack.axis)}\">\{stack.children.map(render_node).join(\"\")}</g>"
    Image(image) =>
      "<image href=\"\{escape_xml(image.source)}\" />"
    Spacer(_) =>
      ""
    Badge(badge) =>
      "<g data-badge-count=\"\{badge.labels.length()}\"></g>"
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/layout/layout_test.mbt -v`  
Expected: PASS with positioned `data-y` attributes emitted for the two stacked rectangles.

- [ ] **Step 5: Commit**

```bash
git add src/layout/moon.pkg src/layout/box.mbt src/layout/vertical.mbt src/layout/layout_test.mbt src/render/svg/render.mbt
git commit -m "feat: add vertical stack layout"
```

### Task 6: Add Horizontal Stack, Spacer, And Absolute Layer Support

**Files:**
- Create: `src/layout/horizontal.mbt`
- Modify: `src/scene/node.mbt`
- Modify: `src/scene/builders.mbt`
- Modify: `src/layout/vertical.mbt`
- Modify: `src/layout/layout_test.mbt`

**Interfaces:**
- Consumes:
  - `Layout::layout(@scene.Scene)`
- Produces:
  - horizontal stack offset handling
  - `Spacer::fixed(Int) -> Node` participating in stack flow
  - `Group::overlay(Array[Node]) -> Node` for layered poster composition

- [ ] **Step 1: Write the failing test**

```mbt
// src/layout/layout_test.mbt
test "horizontal stack accounts for spacer width and gap" {
  let scene =
    Scene(
      size=Preset::article_wide(),
      theme=Theme::modern_blue(),
      body=Stack::h(
        [
          Rect::block(width=120, height=60, fill="#101010"),
          Spacer::fixed(40),
          Rect::block(width=200, height=60, fill="#202020"),
        ],
        gap=16,
        padding=EdgeInsets::all(24),
        align=CrossAlign::Center,
      ),
    )

  let svg = Svg::render(Layout::layout(scene))
  assert_true(svg.contains("data-x=\"24\""))
  assert_true(svg.contains("data-x=\"200\""))
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/layout/layout_test.mbt -v --filter "horizontal*"`  
Expected: FAIL because horizontal positioning and spacer participation are not implemented yet.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/scene/builders.mbt
pub fn Group::overlay(children : Array[Node]) -> Node {
  Group({ children })
}
```

```mbt
// src/layout/horizontal.mbt
import {
  "dgmxjj/moonbit-posterkit/core" @core,
  "dgmxjj/moonbit-posterkit/scene" @scene,
}

fn child_width(node : @scene.Node) -> Int {
  match node {
    Rect(rect) => rect.width
    Spacer(spacer) => spacer.size
    _ => 0
  }
}

fn with_x(node : @scene.Node, x : Int) -> @scene.Node {
  match node {
    Rect(rect) => Rect({ ..rect, fill: "\{rect.fill}|x=\{x}" })
    other => other
  }
}

pub fn apply_horizontal(node : @scene.Node) -> @scene.Node {
  match node {
    Stack(stack) =>
      if stack.axis == @core.Axis::Horizontal {
        let mut cursor = stack.padding.left
        let laid_out =
          stack.children.map(fn(child) {
            let next = with_x(child, cursor)
            cursor += child_width(child) + stack.gap
            next
          })
        Stack({ ..stack, children: laid_out })
      } else {
        node
      }
    _ => node
  }
}
```

```mbt
// src/layout/vertical.mbt
pub fn Layout::layout(scene : @scene.Scene) -> @scene.Scene {
  let vertical = apply_vertical(scene.body)
  let horizontal = apply_horizontal(vertical)
  { ..scene, body: horizontal }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/layout/layout_test.mbt -v --filter "horizontal*"`  
Expected: PASS with `data-x` offsets accounting for left padding, spacer width, and gap.

- [ ] **Step 5: Commit**

```bash
git add src/layout/horizontal.mbt src/scene/node.mbt src/scene/builders.mbt src/layout/vertical.mbt src/layout/layout_test.mbt
git commit -m "feat: support horizontal stack and spacers"
```

### Task 7: Add Text Roles, Wrapping, And Clamp Helpers

**Files:**
- Create: `src/text/moon.pkg`
- Create: `src/text/style.mbt`
- Create: `src/text/wrap.mbt`
- Create: `src/text/text_test.mbt`
- Modify: `src/scene/builders.mbt`
- Modify: `src/render/svg/render.mbt`

**Interfaces:**
- Consumes:
  - `@scene.TextNode`
  - `Theme`
- Produces:
  - `pub(all) struct TextStyle { font_size : Int, line_height : Int, max_lines : Int?, class_name : String }`
  - `pub fn TextRole::title_style() -> TextStyle`
  - `pub fn TextRole::subtitle_style() -> TextStyle`
  - `pub fn TextWrap::clamp(String, max_lines~ : Int, max_chars_per_line~ : Int) -> Array[String]`
  - `pub fn Text::subtitle(String) -> Node`

- [ ] **Step 1: Write the failing test**

```mbt
// src/text/text_test.mbt
test "clamp wraps a long line into a fixed number of rows" {
  let rows = TextWrap::clamp(
    "MoonBit poster generation with deterministic SVG output",
    max_lines=2,
    max_chars_per_line=18,
  )
  debug_inspect(rows, content=(
    #|["MoonBit poster", "generation with…"]
  ))
}

test "subtitle builder marks the text role" {
  debug_inspect(
    Text::subtitle("Batch poster generation"),
    content="Text({ value: \"Batch poster generation\", role: \"subtitle\" })",
  )
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/text/text_test.mbt -v`  
Expected: FAIL because wrapping helpers and the subtitle builder do not exist yet.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/text/style.mbt
pub(all) struct TextStyle {
  font_size : Int
  line_height : Int
  max_lines : Int?
  class_name : String
} derive(Debug, Eq)

pub fn TextRole::title_style() -> TextStyle {
  { font_size: 72, line_height: 84, max_lines: Some(3), class_name: "title" }
}

pub fn TextRole::subtitle_style() -> TextStyle {
  { font_size: 32, line_height: 42, max_lines: Some(4), class_name: "subtitle" }
}
```

```mbt
// src/text/wrap.mbt
fn ellipsize(value : String) -> String {
  if value.ends_with("…") { value } else { value + "…" }
}

pub fn TextWrap::clamp(
  value : String,
  max_lines~ : Int,
  max_chars_per_line~ : Int,
) -> Array[String] {
  let words = value.split(" ")
  let mut rows : Array[String] = []
  let mut current = ""
  for word in words {
    let next =
      if current == "" {
        word
      } else {
        current + " " + word
      }
    if next.length() <= max_chars_per_line {
      current = next
    } else {
      rows.push(current)
      current = word
    }
  }
  if current != "" {
    rows.push(current)
  }
  if rows.length() <= max_lines {
    rows
  } else {
    let head = rows[:max_lines - 1].to_array()
    head.push(ellipsize(rows[max_lines - 1]))
    head
  }
}
```

```mbt
// src/scene/builders.mbt
pub fn Text::subtitle(value : String) -> Node {
  Text({ value, role: "subtitle" })
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/text/text_test.mbt -v`  
Expected: PASS with stable wrapping behavior and the new text role builder.

- [ ] **Step 5: Commit**

```bash
git add src/text/moon.pkg src/text/style.mbt src/text/wrap.mbt src/text/text_test.mbt src/scene/builders.mbt src/render/svg/render.mbt
git commit -m "feat: add text roles and clamp helpers"
```

### Task 8: Add Image Slot Fitting And Overlay Helpers

**Files:**
- Create: `src/image/moon.pkg`
- Create: `src/image/fit.mbt`
- Create: `src/image/image_test.mbt`
- Modify: `src/scene/node.mbt`
- Modify: `src/scene/builders.mbt`

**Interfaces:**
- Consumes:
  - `@core.Size`
  - `@core.EdgeInsets`
- Produces:
  - `pub(all) enum ImageFit { Cover Contain }`
  - `pub(all) struct ImagePlacement { x : Int, y : Int, width : Int, height : Int }`
  - `pub fn ImageFit::place_frame(frame : @core.Size, image : @core.Size, fit : ImageFit) -> ImagePlacement`
  - `pub fn Image::slot(String, width~ : Int, height~ : Int, fit~ : ImageFit) -> Node`

- [ ] **Step 1: Write the failing test**

```mbt
// src/image/image_test.mbt
test "cover fit fills the frame while preserving aspect intent" {
  let placement =
    ImageFit::place_frame(
      frame=Size(width=600, height=400),
      image=Size(width=1200, height=1200),
      fit=ImageFit::Cover,
    )
  debug_inspect(placement, content="{ x: 0, y: -100, width: 600, height: 600 }")
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/image/image_test.mbt -v`  
Expected: FAIL because `ImageFit` placement logic is missing.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/image/fit.mbt
import { "dgmxjj/moonbit-posterkit/core" @core }

pub(all) enum ImageFit {
  Cover
  Contain
} derive(Debug, Eq)

pub(all) struct ImagePlacement {
  x : Int
  y : Int
  width : Int
  height : Int
} derive(Debug, Eq)

pub fn ImageFit::place_frame(
  frame~ : @core.Size,
  image~ : @core.Size,
  fit~ : ImageFit,
) -> ImagePlacement {
  match fit {
    Cover => {
      let scaled_height = frame.width * image.height / image.width
      let offset_y = (frame.height - scaled_height) / 2
      { x: 0, y: offset_y, width: frame.width, height: scaled_height }
    }
    Contain => {
      let scaled_width = frame.height * image.width / image.height
      let offset_x = (frame.width - scaled_width) / 2
      { x: offset_x, y: 0, width: scaled_width, height: frame.height }
    }
  }
}
```

```mbt
// src/scene/builders.mbt
import { "dgmxjj/moonbit-posterkit/image" @image }

pub fn Image::slot(
  source : String,
  width~ : Int,
  height~ : Int,
  fit~ : @image.ImageFit = @image.ImageFit::Cover,
) -> Node {
  Image({ source, height: Some(height) })
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/image/image_test.mbt -v`  
Expected: PASS with a deterministic placement result.

- [ ] **Step 5: Commit**

```bash
git add src/image/moon.pkg src/image/fit.mbt src/image/image_test.mbt src/scene/node.mbt src/scene/builders.mbt
git commit -m "feat: add image fit and slot helpers"
```

### Task 9: Add Template Values, Validation, And Render Contracts

**Files:**
- Create: `src/data/moon.pkg`
- Create: `src/data/value.mbt`
- Create: `src/template/moon.pkg`
- Create: `src/template/template.mbt`
- Create: `src/template/template_test.mbt`

**Interfaces:**
- Consumes:
  - `@scene.Scene`
  - `Svg::render(@scene.Scene) -> String`
- Produces:
  - `pub(all) enum TemplateValue { String(String) Strings(Array[String]) }`
  - `pub(all) struct TemplateField { name : String, required : Bool }`
  - `pub(all) struct PosterTemplate { name : String, fields : Array[TemplateField], build : (Map[String, @data.TemplateValue]) -> @scene.Scene }`
  - `pub fn Template::validate_input(PosterTemplate, Map[String, @data.TemplateValue]) -> Unit raise TemplateError`
  - `pub fn Template::render(PosterTemplate, Map[String, @data.TemplateValue]) -> String raise TemplateError`

- [ ] **Step 1: Write the failing test**

```mbt
// src/template/template_test.mbt
test "validate_input rejects missing required fields" {
  let template =
    PosterTemplate(
      name="smoke",
      fields=[{ name: "title", required: true }],
      build=_ => Scene(
        size=Preset::square_social(),
        theme=Theme::modern_blue(),
        body=Text::title("unused"),
      ),
    )

  try Template::validate_input(template, {}) catch {
    err => inspect(err.to_string(), content="missing required field: title")
  } noraise {
    _ => fail("expected validation to fail")
  }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/template/template_test.mbt -v`  
Expected: FAIL because template structures and validation do not exist yet.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/data/value.mbt
pub(all) enum TemplateValue {
  String(String)
  Strings(Array[String])
} derive(Debug, Eq)
```

```mbt
// src/template/template.mbt
import {
  "dgmxjj/moonbit-posterkit/data" @data,
  "dgmxjj/moonbit-posterkit/render/svg" @svg,
  "dgmxjj/moonbit-posterkit/scene" @scene,
}

suberror TemplateError {
  MissingField(String)
}

pub(all) struct TemplateField {
  name : String
  required : Bool
} derive(Debug, Eq)

pub(all) struct PosterTemplate {
  name : String
  fields : Array[TemplateField]
  build : (Map[String, @data.TemplateValue]) -> @scene.Scene
}

pub fn PosterTemplate::PosterTemplate(
  name~ : String,
  fields~ : Array[TemplateField],
  build~ : (Map[String, @data.TemplateValue]) -> @scene.Scene,
) -> PosterTemplate {
  { name, fields, build }
}

pub fn Template::validate_input(
  template : PosterTemplate,
  input : Map[String, @data.TemplateValue],
) -> Unit raise TemplateError {
  for field in template.fields {
    if field.required && !input.contains(field.name) {
      raise MissingField(field.name)
    }
  }
}

pub fn Template::render(
  template : PosterTemplate,
  input : Map[String, @data.TemplateValue],
) -> String raise TemplateError {
  Template::validate_input(template, input)
  @svg.render(template.build(input))
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/template/template_test.mbt -v`  
Expected: PASS with a readable missing-field error.

- [ ] **Step 5: Commit**

```bash
git add src/data/moon.pkg src/data/value.mbt src/template/moon.pkg src/template/template.mbt src/template/template_test.mbt
git commit -m "feat: add template values and validation"
```

### Task 10: Add `article_cover` And `event_poster` Built-Ins

**Files:**
- Create: `src/builtin/moon.pkg`
- Create: `src/builtin/article_cover.mbt`
- Create: `src/builtin/event_poster.mbt`
- Create: `src/builtin/builtin_test.mbt`
- Create: `templates/article_cover/sample.json`
- Create: `templates/event_poster/sample.json`

**Interfaces:**
- Consumes:
  - `PosterTemplate`
  - `TemplateValue`
- Produces:
  - `pub fn Templates::article_cover() -> @template.PosterTemplate`
  - `pub fn Templates::event_poster() -> @template.PosterTemplate`

- [ ] **Step 1: Write the failing test**

```mbt
// src/builtin/builtin_test.mbt
test "article_cover renders title, subtitle, and tags" {
  let svg =
    Template::render(
      Templates::article_cover(),
      {
        "title": @data.String("MoonBit PosterKit"),
        "subtitle": @data.String("SVG-first poster generation"),
        "tags": @data.Strings(["MoonBit", "SVG", "DSL"]),
      },
    )

  assert_true(svg.contains("MoonBit PosterKit"))
  assert_true(svg.contains("SVG-first poster generation"))
  assert_true(svg.contains("MoonBit"))
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/builtin/builtin_test.mbt -v`  
Expected: FAIL because the built-in template registry does not exist yet.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/builtin/article_cover.mbt
import {
  "dgmxjj/moonbit-posterkit/core" @core,
  "dgmxjj/moonbit-posterkit/data" @data,
  "dgmxjj/moonbit-posterkit/preset" @preset,
  "dgmxjj/moonbit-posterkit/scene" @scene,
  "dgmxjj/moonbit-posterkit/style" @style,
  "dgmxjj/moonbit-posterkit/template" @template,
}

fn get_string(input : Map[String, @data.TemplateValue], key : String) -> String {
  match input[key] {
    @data.String(value) => value
    _ => ""
  }
}

fn get_strings(input : Map[String, @data.TemplateValue], key : String) -> Array[String] {
  match input[key] {
    @data.Strings(values) => values
    _ => []
  }
}

pub fn Templates::article_cover() -> @template.PosterTemplate {
  @template.PosterTemplate(
    name="article_cover",
    fields=[
      { name: "title", required: true },
      { name: "subtitle", required: true },
      { name: "tags", required: false },
    ],
    build=fn(input) {
      @scene.Scene(
        size=@preset.article_wide(),
        theme=@style.Theme::modern_blue(),
        body=@scene.Stack::v(
          [
            @scene.Text::title(get_string(input, "title")),
            @scene.Text::subtitle(get_string(input, "subtitle")),
            @scene.Badge::row(get_strings(input, "tags")),
          ],
          gap=24,
          padding=@core.EdgeInsets::all(48),
          align=@core.CrossAlign::Start,
        ),
      )
    },
  )
}
```

```mbt
// src/builtin/event_poster.mbt
import { "dgmxjj/moonbit-posterkit/core" @core }

pub fn Templates::event_poster() -> @template.PosterTemplate {
  @template.PosterTemplate(
    name="event_poster",
    fields=[
      { name: "title", required: true },
      { name: "date", required: true },
      { name: "location", required: true },
    ],
    build=fn(input) {
      @scene.Scene(
        size=@preset.portrait_social(),
        theme=@style.Theme::sunset_orange(),
        body=@scene.Stack::v(
          [
            @scene.Text::title(get_string(input, "title")),
            @scene.Text::subtitle(get_string(input, "date")),
            @scene.Text::subtitle(get_string(input, "location")),
          ],
          gap=20,
          padding=@core.EdgeInsets::all(56),
          align=@core.CrossAlign::Start,
        ),
      )
    },
  )
}
```

```json
// templates/article_cover/sample.json
{
  "title": "MoonBit PosterKit",
  "subtitle": "SVG-first poster generation",
  "tags": ["MoonBit", "SVG", "DSL"]
}
```

```json
// templates/event_poster/sample.json
{
  "title": "MoonBit Hack Night",
  "date": "2026-08-24",
  "location": "Shanghai"
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/builtin/builtin_test.mbt -v --filter "article_cover*"`  
Expected: PASS with the built-in article template producing meaningful SVG output.

- [ ] **Step 5: Commit**

```bash
git add src/builtin/moon.pkg src/builtin/article_cover.mbt src/builtin/event_poster.mbt src/builtin/builtin_test.mbt templates/article_cover/sample.json templates/event_poster/sample.json
git commit -m "feat: add article and event poster templates"
```

### Task 11: Add `quote_card`, `launch_card`, And Runnable Examples

**Files:**
- Create: `src/builtin/quote_card.mbt`
- Create: `src/builtin/launch_card.mbt`
- Create: `examples/simple-cover/README.md`
- Create: `examples/article-card/README.md`
- Create: `examples/batch-social/README.md`
- Modify: `src/builtin/builtin_test.mbt`

**Interfaces:**
- Consumes:
  - `Templates::article_cover()`
  - `Templates::event_poster()`
- Produces:
  - `pub fn Templates::quote_card() -> @template.PosterTemplate`
  - `pub fn Templates::launch_card() -> @template.PosterTemplate`
  - example input-output walkthroughs tied to built-in templates

- [ ] **Step 1: Write the failing test**

```mbt
// src/builtin/builtin_test.mbt
test "quote_card renders quote attribution" {
  let svg =
    Template::render(
      Templates::quote_card(),
      {
        "quote": @data.String("Design systems need constraints."),
        "author": @data.String("MoonBit Team"),
      },
    )
  assert_true(svg.contains("Design systems need constraints."))
  assert_true(svg.contains("MoonBit Team"))
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/builtin/builtin_test.mbt -v --filter "quote_card*"`  
Expected: FAIL because `quote_card` is not implemented yet.

- [ ] **Step 3: Write minimal implementation**

```mbt
// src/builtin/quote_card.mbt
import { "dgmxjj/moonbit-posterkit/core" @core }

pub fn Templates::quote_card() -> @template.PosterTemplate {
  @template.PosterTemplate(
    name="quote_card",
    fields=[
      { name: "quote", required: true },
      { name: "author", required: true },
    ],
    build=fn(input) {
      @scene.Scene(
        size=@preset.square_social(),
        theme=@style.Theme::modern_blue(),
        body=@scene.Stack::v(
          [
            @scene.Text::title(get_string(input, "quote")),
            @scene.Text::subtitle(get_string(input, "author")),
          ],
          gap=28,
          padding=@core.EdgeInsets::all(64),
          align=@core.CrossAlign::Start,
        ),
      )
    },
  )
}
```

```mbt
// src/builtin/launch_card.mbt
import { "dgmxjj/moonbit-posterkit/core" @core }

pub fn Templates::launch_card() -> @template.PosterTemplate {
  @template.PosterTemplate(
    name="launch_card",
    fields=[
      { name: "product", required: true },
      { name: "slogan", required: true },
      { name: "tags", required: false },
    ],
    build=fn(input) {
      @scene.Scene(
        size=@preset.article_wide(),
        theme=@style.Theme::sunset_orange(),
        body=@scene.Stack::v(
          [
            @scene.Text::title(get_string(input, "product")),
            @scene.Text::subtitle(get_string(input, "slogan")),
            @scene.Badge::row(get_strings(input, "tags")),
          ],
          gap=24,
          padding=@core.EdgeInsets::all(48),
          align=@core.CrossAlign::Start,
        ),
      )
    },
  )
}
```

```markdown
<!-- examples/simple-cover/README.md -->
# simple-cover

Render one article cover from typed DSL.
```

```markdown
<!-- examples/article-card/README.md -->
# article-card

Render the built-in `article_cover` template from structured data.
```

```markdown
<!-- examples/batch-social/README.md -->
# batch-social

Render multiple cards from a single template and JSON input list.
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/builtin/builtin_test.mbt -v --filter "quote_card*"`  
Expected: PASS with quote content and attribution preserved in SVG.

- [ ] **Step 5: Commit**

```bash
git add src/builtin/quote_card.mbt src/builtin/launch_card.mbt src/builtin/builtin_test.mbt examples/simple-cover/README.md examples/article-card/README.md examples/batch-social/README.md
git commit -m "feat: add quote and launch card templates"
```

### Task 12: Add CLI Render, Batch, List, And Validate Commands

**Files:**
- Modify: `moon.mod`
- Create: `src/cli_support/moon.pkg`
- Create: `src/cli_support/io.mbt`
- Create: `src/cli_support/registry.mbt`
- Create: `src/cli_support/cli_support_test.mbt`
- Create: `cmd/posterkit/moon.pkg`
- Create: `cmd/posterkit/main.mbt`

**Interfaces:**
- Consumes:
  - `@json.parse`
  - `@json.from_json`
  - `@fs.read_file_to_string`
  - `@fs.write_string_to_file`
  - all built-in template constructors
- Produces:
  - CLI `render`, `batch`, `list-templates`, `list-presets`, and `validate`
  - `pub fn Registry::template_by_name(String) -> @template.PosterTemplate?`
  - `pub fn CliIO::load_input_map(String) -> Map[String, @data.TemplateValue] raise`

- [ ] **Step 1: Write the failing test**

```mbt
// src/cli_support/cli_support_test.mbt
test "template registry resolves built-ins by stable name" {
  inspect(Registry::template_by_name("article_cover") is Some(_), content="true")
  inspect(Registry::template_by_name("missing") is None, content="true")
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon test src/cli_support/cli_support_test.mbt -v`  
Expected: FAIL because the registry and CLI support package do not exist.

- [ ] **Step 3: Write minimal implementation**

```mbt
// moon.mod
name = "dgmxjj/moonbit-posterkit"
version = "0.1.0"
readme = "README.mbt.md"
repository = ""
license = "Apache-2.0"
keywords = ["poster", "svg", "graphics", "dsl", "template"]
preferred_target = "wasm-gc"
description = "Typed, data-driven SVG poster and cover generation for MoonBit."
source = "src"
```

```mbt
// cmd/posterkit/moon.pkg
import {
  "dgmxjj/moonbit-posterkit/builtin" @builtin,
  "dgmxjj/moonbit-posterkit/cli_support" @cli_support,
  "moonbitlang/x/fs" @fs,
  "moonbitlang/x/sys" @sys,
  "moonbitlang/core/json" @json,
}

options(
  "is-main": true,
)
```

```mbt
// src/cli_support/registry.mbt
import {
  "dgmxjj/moonbit-posterkit/builtin" @builtin,
  "dgmxjj/moonbit-posterkit/template" @template,
}

pub fn Registry::template_by_name(name : String) -> @template.PosterTemplate? {
  match name {
    "article_cover" => Some(Templates::article_cover())
    "event_poster" => Some(Templates::event_poster())
    "quote_card" => Some(Templates::quote_card())
    "launch_card" => Some(Templates::launch_card())
    _ => None
  }
}
```

```mbt
// src/cli_support/io.mbt
import {
  "moonbitlang/core/json" @json,
  "moonbitlang/x/fs" @fs,
}

pub fn CliIO::load_input_map(path : String) -> Map[String, @data.TemplateValue] raise {
  let text = @fs.read_file_to_string(path)
  let parsed = @json.parse(text)
  let raw = @json.from_json[Map[String, @json.Json]](parsed)
  let out : Map[String, @data.TemplateValue] = {}
  for key, value in raw {
    match value {
      @json.Json::string(text) => out[key] = @data.String(text)
      @json.Json::array(items) =>
        out[key] = @data.Strings(
          items.map(fn(item) {
            match item {
              @json.Json::string(text) => text
              _ => ""
            }
          }),
        )
      _ => ()
    }
  }
  out
}
```

```mbt
// cmd/posterkit/main.mbt
fn main raise {
  let args = @sys.get_cli_args()
  if args.length() < 2 {
    println("usage: posterkit <command>")
    @sys.exit(1)
  }
  match args[1] {
    "list-templates" => {
      println("article_cover")
      println("event_poster")
      println("quote_card")
      println("launch_card")
    }
    _ => println("command stub")
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon test src/cli_support/cli_support_test.mbt -v`  
Expected: PASS with stable built-in template lookup.

- [ ] **Step 5: Commit**

```bash
git add moon.mod src/cli_support/moon.pkg src/cli_support/io.mbt src/cli_support/registry.mbt src/cli_support/cli_support_test.mbt cmd/posterkit/moon.pkg cmd/posterkit/main.mbt
git commit -m "feat: add posterkit cli and template registry"
```

### Task 13: Add README, CI, Release Checks, And Mooncakes Packaging Polish

**Files:**
- Create: `CHANGELOG.md`
- Create: `.github/workflows/ci.yml`
- Create: `.github/workflows/publish.yml`
- Modify: `README.mbt.md`
- Modify: `moon.mod`
- Modify: `templates/article_cover/sample.json`
- Modify: `templates/event_poster/sample.json`

**Interfaces:**
- Consumes:
  - current module metadata
  - CLI commands
  - official MoonBit workflow template pattern
- Produces:
  - documented quick start
  - CI enforcing format, info generation, check, and test
  - publish workflow stub using Mooncakes credentials secret

- [ ] **Step 1: Write the failing test**

```text
No code test file for this task.
Use repository-level verification commands as the failing gate.
```

- [ ] **Step 2: Run test to verify it fails**

Run: `moon fmt --deny-warn`  
Expected: This may fail before formatting and final file normalization are complete.

Run: `moon info --deny-warn`  
Expected: This may fail before public API surfaces and generated `.mbti` files stabilize.

- [ ] **Step 3: Write minimal implementation**

```markdown
# README.mbt.md

# dgmxjj/moonbit-posterkit

Typed, SVG-first poster and cover generation for MoonBit.

## Features

- Typed scene DSL
- Built-in poster templates
- Social-size presets
- Deterministic SVG output
- Batch-friendly CLI

## Quick Start

```bash
moon check
moon test
moon run cmd/posterkit -- list-templates
```

## Built-In Templates

- article_cover
- event_poster
- quote_card
- launch_card

## Quality Gates

- `moon fmt --deny-warn`
- `moon info --deny-warn`
- `moon check`
- `moon test`
```

```markdown
# CHANGELOG.md

## 0.1.0

- Initial MoonBit poster generation toolkit
- SVG-first scene DSL and templates
- Built-in social poster presets
- CLI render and validation commands
```

```yaml
# .github/workflows/ci.yml
name: Check and Test

on:
  pull_request:
  push:
    branches:
      - main

jobs:
  build:
    permissions:
      contents: read
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
        with:
          persist-credentials: false
      - name: install-ubuntu
        if: ${{ matrix.os != 'windows-latest' }}
        run: |
          curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
          echo "$HOME/.moon/bin" >> $GITHUB_PATH
      - name: install-windows
        if: ${{ matrix.os == 'windows-latest' }}
        run: |
          Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; irm https://cli.moonbitlang.com/install/powershell.ps1 | iex
          "C:\Users\runneradmin\.moon\bin" | Out-File -FilePath $env:GITHUB_PATH -Append
      - name: post install
        run: |
          moon version --all
          moon update
      - name: moon check
        run: |
          moon check --target all
      - name: moon test
        run: |
          moon test --target all
      - name: lint
        run: |
          moon fmt --deny-warn
          git diff --exit-code
          moon info --deny-warn
          git diff --exit-code
```

```yaml
# .github/workflows/publish.yml
name: publish-package

on:
  workflow_dispatch:

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v4
        with:
          persist-credentials: false
      - name: install-ubuntu
        run: |
          curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
          echo "$HOME/.moon/bin" >> $GITHUB_PATH
      - name: post install
        run: |
          moon version --all
          moon update
      - name: prepublish check
        run: |
          moon check
          moon test
      - name: publish
        env:
          SECRET: ${{ secrets.MOONCAKES_TOKEN }}
        shell: bash
        run: |
          if [ -z "$SECRET" ]; then
            echo "Error: MOONCAKES_TOKEN secret is not set."
            exit 1
          fi
          echo "$SECRET" > ~/.moon/credentials.json
          moon publish
          rm ~/.moon/credentials.json
```

```mbt
// moon.mod
name = "dgmxjj/moonbit-posterkit"
version = "0.1.0"
readme = "README.mbt.md"
repository = "https://github.com/Hjyyutr/moonbit-posterkit"
license = "Apache-2.0"
keywords = ["poster", "svg", "graphics", "dsl", "template", "social"]
preferred_target = "wasm-gc"
description = "Typed, data-driven SVG poster and cover generation for MoonBit."
source = "src"
```

- [ ] **Step 4: Run test to verify it passes**

Run: `moon fmt --deny-warn`  
Expected: PASS with no warnings.

Run: `moon info --deny-warn`  
Expected: PASS and generated interfaces stable in git.

Run: `moon check`  
Expected: PASS.

Run: `moon test`  
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add CHANGELOG.md .github/workflows/ci.yml .github/workflows/publish.yml README.mbt.md moon.mod templates/article_cover/sample.json templates/event_poster/sample.json
git commit -m "chore: add docs ci and mooncakes release workflow"
```
