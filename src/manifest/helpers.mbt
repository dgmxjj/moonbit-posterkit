///|
pub(all) struct CatalogCounts {
  templates : Int
  presets : Int
  themes : Int
  packs : Int
} derive(Debug, Eq, ToJson)

///|
pub fn catalog_counts(catalog : RepositoryCatalog) -> CatalogCounts {
  {
    templates: catalog.templates.length(),
    presets: catalog.presets.length(),
    themes: catalog.themes.length(),
    packs: catalog.packs.length(),
  }
}

///|
pub fn catalog_is_complete(catalog : RepositoryCatalog) -> Bool {
  let counts = catalog_counts(catalog)
  counts.templates > 0 &&
  counts.presets > 0 &&
  counts.themes > 0 &&
  counts.packs > 0
}

///|
pub fn catalog_summary(catalog : RepositoryCatalog) -> String {
  let counts = catalog_counts(catalog)
  "module=" +
  catalog.module_name +
  ",version=" +
  catalog.version +
  ",templates=" +
  counts.templates.to_string() +
  ",presets=" +
  counts.presets.to_string() +
  ",themes=" +
  counts.themes.to_string() +
  ",packs=" +
  counts.packs.to_string()
}

///|
pub fn catalog_markdown_sections() -> Array[String] {
  ["Templates", "Presets", "Themes", "Packs"]
}

///|
pub fn catalog_has_section(markdown : String, section : String) -> Bool {
  markdown.contains("## " + section)
}
