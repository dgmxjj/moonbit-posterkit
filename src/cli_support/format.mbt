///|
fn format_template(info : @registry.TemplateInfo) -> String {
  "\{info.name} | preset: \{info.default_preset} | theme: \{info.default_theme} | \{info.summary}"
}

///|
fn format_preset(info : @registry.PresetInfo) -> String {
  "\{info.name} | \{info.width}x\{info.height} | margin \{info.safe_margin} | ratio \{info.aspect_ratio} | \{info.summary}"
}

///|
fn format_theme(info : @registry.ThemeInfo) -> String {
  "\{info.name} | accent \{info.accent} | body \{info.body_size} | \{info.summary}"
}

///|
fn format_pack(info : @catalog_meta.PackInfo) -> String {
  let templates = info.templates.join(",")
  let presets = info.presets.join(",")
  let themes = info.themes.join(",")
  "\{info.name} | jobs \{info.jobs} | templates \{templates}" +
  " | presets \{presets} | themes \{themes}"
}

///|
pub fn template_listing_output() -> String {
  @registry.list_templates().map(format_template).join("\n")
}

///|
pub fn preset_listing_output() -> String {
  @registry.list_presets().map(format_preset).join("\n")
}

///|
pub fn theme_listing_output() -> String {
  @registry.list_themes().map(format_theme).join("\n")
}

///|
pub fn pack_listing_output() -> String {
  @catalog_meta.list_packs().map(format_pack).join("\n")
}

///|
pub fn validation_output(summary : @config.ValidationSummary) -> String {
  let slugs = summary.slugs.join(", ")
  let templates = summary.templates.join(", ")
  let presets = summary.presets.join(", ")
  let themes = summary.themes.join(", ")
  [
    "Valid batch: \{summary.total_jobs} job(s)",
    "Slugs: \{slugs}",
    "Templates: \{templates}",
    "Presets: \{presets}",
    "Themes: \{themes}",
  ].join("\n")
}

///|
pub fn emit_pack_json(name : String) -> Result[String, CliError] {
  match @catalog_meta.resolve_pack(name) {
    Some(pack) => Ok(@catalog.flatten_jobs(pack).to_json().stringify(indent=2))
    None => Err(CliError::UnknownPack(name~))
  }
}

///|
pub fn catalog_json_output() -> String {
  @manifest.catalog_json()
}

///|
pub fn catalog_markdown_output() -> String {
  @manifest.catalog_markdown()
}
