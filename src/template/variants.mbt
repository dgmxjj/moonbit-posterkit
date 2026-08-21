///|
pub(all) enum ContentDensity {
  Sparse
  Balanced
  Dense
} derive(Debug, Eq)

///|
pub(all) struct ContentProfile {
  characters : Int
  non_empty_fields : Int
  density : ContentDensity
  has_image : Bool
} derive(Debug, Eq)

///|
fn field_lengths(content : TemplateContent) -> Array[Int] {
  [
    content.eyebrow.char_length(),
    content.title.char_length(),
    content.subtitle.char_length(),
    content.body.char_length(),
    content.cta.char_length(),
    content.footer.char_length(),
    content.image_label.char_length(),
    content.image_asset_id.char_length(),
  ]
}

///|
pub fn profile_content(content : TemplateContent) -> ContentProfile {
  let lengths = field_lengths(content)
  let characters = lengths.fold(init=0, (sum, value) => sum + value)
  let non_empty_fields = lengths.filter(value => value > 0).length()
  let density = if characters < 120 {
    Sparse
  } else if characters < 360 {
    Balanced
  } else {
    Dense
  }
  {
    characters,
    non_empty_fields,
    density,
    has_image: content.image_asset_id.trim().length() > 0,
  }
}

///|
pub fn density_text(density : ContentDensity) -> String {
  match density {
    Sparse => "sparse"
    Balanced => "balanced"
    Dense => "dense"
  }
}

///|
pub fn content_summary(content : TemplateContent) -> String {
  let profile = profile_content(content)
  let image = if profile.has_image { "yes" } else { "no" }
  "characters=" +
  profile.characters.to_string() +
  ",fields=" +
  profile.non_empty_fields.to_string() +
  ",density=" +
  density_text(profile.density) +
  ",image=" +
  image
}

///|
pub fn render_compact(
  template~ : String,
  preset~ : @preset.PosterPreset,
  theme~ : @theme.Theme,
  content~ : TemplateContent,
) -> @scene.PosterDocument {
  let profile = profile_content(content)
  match profile.density {
    Sparse => render_template(template~, preset~, theme~, content~)
    Balanced => render_template(template~, preset~, theme~, content~)
    Dense => render_template(template="digest", preset~, theme~, content~)
  }
}

///|
pub fn render_story_variant(
  theme~ : @theme.Theme,
  content~ : TemplateContent,
) -> @scene.PosterDocument {
  render_template(
    template="editorial",
    preset=@preset.PosterPreset::social_story(),
    theme~,
    content~,
  )
}

///|
pub fn render_wide_variant(
  theme~ : @theme.Theme,
  content~ : TemplateContent,
) -> @scene.PosterDocument {
  render_template(
    template="digest",
    preset=@preset.PosterPreset::youtube_thumbnail(),
    theme~,
    content~,
  )
}
