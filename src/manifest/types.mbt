///|
pub(all) struct RepositoryCatalog {
  module_name : String
  version : String
  description : String
  templates : Array[@registry.TemplateInfo]
  presets : Array[@registry.PresetInfo]
  themes : Array[@registry.ThemeInfo]
  packs : Array[@catalog_meta.PackInfo]
} derive(Debug, Eq, ToJson)
