fn demo_content() -> TemplateContent {
  {
    eyebrow: "MoonBit Hackathon 2026",
    title: "MoonBit PosterKit",
    subtitle: "Data-driven poster generation DSL",
    body: "Compose reusable layouts, typography, image slots, and presets with typed MoonBit APIs.",
    cta: "Build once, render everywhere",
    footer: "mooncakes.io / github",
    image_label: "Replace Cover Art",
    image_asset_id: "cover-art",
  }
}

fn has_image_slot(document : @scene.PosterDocument, asset_id : String) -> Bool {
  document.elements.any(element =>
    match element {
      @scene.Element::ImageSlot(asset_id=id, ..) => id == asset_id
      _ => false
    })
}

test "launch template creates a reusable social poster" {
  let document = render_template(
    template="launch",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
    content=demo_content(),
  )
  inspect(document.title, content="MoonBit PosterKit")
  inspect(document.elements.length() >= 6, content="true")
  inspect(has_image_slot(document, "cover-art"), content="true")
}

test "editorial template supports swiss-grid stories" {
  let document = render_template(
    template="editorial",
    preset=@preset.PosterPreset::social_story(),
    theme=@theme.Theme::swiss_grid(),
    content=demo_content(),
  )
  inspect(document.preset.canvas.height, content="1920")
  inspect(document.theme.name, content="swiss-grid")
  inspect(has_image_slot(document, "cover-art"), content="true")
}

test "event template places operational details into the footer zone" {
  let document = render_template(
    template="event",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
    content=demo_content(),
  )
  inspect(document.elements.length() >= 7, content="true")
  inspect(has_image_slot(document, "cover-art"), content="true")
}
