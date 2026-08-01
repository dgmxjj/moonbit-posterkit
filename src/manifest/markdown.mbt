///|
fn table_row(columns : Array[String]) -> String {
  "| " + columns.join(" | ") + " |"
}

///|
fn template_table() -> String {
  let rows = [
    "| Name | Default Preset | Default Theme | Summary |", "| --- | --- | --- | --- |",
  ]
  for info in @registry.list_templates() {
    rows.push(
      table_row([
        info.name,
        info.default_preset,
        info.default_theme,
        info.summary,
      ]),
    )
  }
  rows.join("\n")
}

///|
fn preset_table() -> String {
  let rows = [
    "| Name | Canvas | Margin | Ratio | Summary |", "| --- | --- | --- | --- | --- |",
  ]
  for info in @registry.list_presets() {
    rows.push(
      table_row([
        info.name,
        "\{info.width}x\{info.height}",
        info.safe_margin.to_string(),
        info.aspect_ratio,
        info.summary,
      ]),
    )
  }
  rows.join("\n")
}

///|
fn theme_table() -> String {
  let rows = [
    "| Name | Background | Accent | Body Size | Summary |", "| --- | --- | --- | --- | --- |",
  ]
  for info in @registry.list_themes() {
    rows.push(
      table_row([
        info.name,
        info.background,
        info.accent,
        info.body_size.to_string(),
        info.summary,
      ]),
    )
  }
  rows.join("\n")
}

///|
fn pack_table() -> String {
  let rows = [
    "| Name | Jobs | Templates | Presets | Themes | Summary |", "| --- | --- | --- | --- | --- | --- |",
  ]
  for info in @catalog_meta.list_packs() {
    rows.push(
      table_row([
        info.name,
        info.jobs.to_string(),
        info.templates.join(", "),
        info.presets.join(", "),
        info.themes.join(", "),
        info.summary,
      ]),
    )
  }
  rows.join("\n")
}

///|
pub fn catalog_markdown() -> String {
  [
    "# moonbit-posterkit Catalog",
    "",
    "## Templates",
    "",
    template_table(),
    "",
    "## Presets",
    "",
    preset_table(),
    "",
    "## Themes",
    "",
    theme_table(),
    "",
    "## Packs",
    "",
    pack_table(),
  ].join("\n")
}
