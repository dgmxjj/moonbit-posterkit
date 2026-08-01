///|
pub fn build_catalog() -> RepositoryCatalog {
  {
    module_name: "dgmxjj/moonbit-posterkit",
    version: "0.1.0",
    description: "Typed, data-driven SVG poster and cover generation for MoonBit.",
    templates: @registry.list_templates(),
    presets: @registry.list_presets(),
    themes: @registry.list_themes(),
    packs: @catalog_meta.list_packs(),
  }
}

///|
pub fn catalog_json() -> String {
  build_catalog().to_json().stringify(indent=2)
}
