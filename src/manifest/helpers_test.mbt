///|
test "catalog helpers report a complete generated catalog" {
  let catalog = @manifest.RepositoryCatalog::{
    module_name: "dgmxjj/moonbit-posterkit",
    version: "0.1.0",
    description: "poster toolkit",
    templates: @registry.list_templates(),
    presets: @registry.list_presets(),
    themes: @registry.list_themes(),
    packs: @catalog_meta.list_packs(),
  }
  inspect(@manifest.catalog_is_complete(catalog), content="true")
  inspect(
    @manifest.catalog_summary(catalog).contains("templates=5"),
    content="true",
  )
  let markdown = @manifest.catalog_markdown()
  inspect(@manifest.catalog_has_section(markdown, "Templates"), content="true")
  inspect(@manifest.catalog_markdown_sections().length(), content="4")
}
