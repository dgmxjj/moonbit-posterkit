///|
test "template registry exposes stable metadata and defaults" {
  inspect(list_templates().length(), content="5")
  inspect(
    match resolve_template_info("launch") {
      Some(info) => info.default_preset
      None => ""
    },
    content="instagram-square",
  )
  inspect(
    match resolve_template_info("editorial") {
      Some(info) => info.supported_themes[0]
      None => ""
    },
    content="swiss-grid",
  )
  inspect(
    match resolve_template_info("digest") {
      Some(info) => info.default_preset
      None => ""
    },
    content="youtube-thumbnail",
  )
}

///|
test "preset registry resolves canvas metadata and aspect ratios" {
  inspect(list_presets().length(), content="3")
  inspect(
    match resolve_preset_info("youtube-thumbnail") {
      Some(info) => info.aspect_ratio
      None => ""
    },
    content="16:9",
  )
  inspect(
    match resolve_preset("social-story") {
      Some(preset) => preset.canvas.height
      None => -1
    },
    content="1920",
  )
}

///|
test "theme registry resolves accent tokens and sizing" {
  inspect(list_themes().length(), content="2")
  inspect(
    match resolve_theme_info("warm-editorial") {
      Some(info) => info.accent
      None => ""
    },
    content="#ef7d57",
  )
  inspect(
    match resolve_theme("swiss-grid") {
      Some(theme) => theme.title_size
      None => -1
    },
    content="88",
  )
}
