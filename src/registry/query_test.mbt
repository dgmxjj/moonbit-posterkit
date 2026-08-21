///|
test "registry searches templates by name and summary" {
  inspect(template_search("digest").length(), content="1")
  inspect(template_search("hero").length(), content="1")
  inspect(preset_search("wide").length(), content="1")
}

///|
test "registry filters templates by supported output choices" {
  inspect(templates_for_preset("youtube-thumbnail").length(), content="2")
  inspect(templates_for_theme("swiss-grid").length(), content="5")
  inspect(registry_contains(RegistryKind::Template, "event"), content="true")
  inspect(registry_contains(RegistryKind::Preset, "missing"), content="false")
}

///|
test "registry summary reports inventory counts" {
  inspect(registry_summary(), content="templates=5,presets=3,themes=2")
}
