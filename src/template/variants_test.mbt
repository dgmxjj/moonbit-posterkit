///|
fn variant_content() -> TemplateContent {
  {
    eyebrow: "Release",
    title: "A typed visual system",
    subtitle: "Reusable layouts",
    body: "Templates keep composition stable while data changes.",
    cta: "Read more",
    footer: "MoonBit PosterKit",
    image_label: "Cover",
    image_asset_id: "cover",
  }
}

///|
test "content profiling reports useful density and asset information" {
  let profile = profile_content(variant_content())
  inspect(density_text(profile.density), content="balanced")
  inspect(profile.has_image, content="true")
  inspect(
    content_summary(variant_content()).contains("fields=8"),
    content="true",
  )
}

///|
test "story and wide variants select predictable presets" {
  let story = render_story_variant(
    theme=@theme.Theme::swiss_grid(),
    content=variant_content(),
  )
  let wide = render_wide_variant(
    theme=@theme.Theme::warm_editorial(),
    content=variant_content(),
  )
  inspect(story.preset.aspect_ratio_label(), content="9:16")
  inspect(wide.preset.aspect_ratio_label(), content="16:9")
}
