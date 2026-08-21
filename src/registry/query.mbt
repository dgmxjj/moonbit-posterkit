///|
pub(all) enum RegistryKind {
  Template
  Preset
  Theme
} derive(Debug, Eq)

///|
pub fn template_search(query : String) -> Array[TemplateInfo] {
  let needle = query.to_lower()
  list_templates().filter(info => {
    info.name.to_lower().contains(needle) ||
    info.summary.to_lower().contains(needle)
  })
}

///|
pub fn preset_search(query : String) -> Array[PresetInfo] {
  let needle = query.to_lower()
  list_presets().filter(info => {
    info.name.to_lower().contains(needle) ||
    info.summary.to_lower().contains(needle)
  })
}

///|
pub fn theme_search(query : String) -> Array[ThemeInfo] {
  let needle = query.to_lower()
  list_themes().filter(info => {
    info.name.to_lower().contains(needle) ||
    info.summary.to_lower().contains(needle)
  })
}

///|
pub fn templates_for_preset(preset : String) -> Array[TemplateInfo] {
  list_templates().filter(info => {
    info.supported_presets.any(name => name == preset)
  })
}

///|
pub fn templates_for_theme(theme : String) -> Array[TemplateInfo] {
  list_templates().filter(info => {
    info.supported_themes.any(name => name == theme)
  })
}

///|
pub fn registry_names(kind : RegistryKind) -> Array[String] {
  match kind {
    Template => template_names()
    Preset => preset_names()
    Theme => theme_names()
  }
}

///|
pub fn registry_contains(kind : RegistryKind, name : String) -> Bool {
  registry_names(kind).any(value => value == name)
}

///|
pub fn registry_summary() -> String {
  "templates=" +
  list_templates().length().to_string() +
  ",presets=" +
  list_presets().length().to_string() +
  ",themes=" +
  list_themes().length().to_string()
}
