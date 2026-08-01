///|
fn instagram_square_info() -> PresetInfo {
  let preset = @preset.PosterPreset::instagram_square()
  {
    name: preset.name,
    summary: "Balanced 1:1 social card for launch graphics, quote cards, and event promos.",
    width: preset.canvas.width,
    height: preset.canvas.height,
    safe_margin: preset.margin.left,
    aspect_ratio: preset.aspect_ratio_label(),
  }
}

///|
fn youtube_thumbnail_info() -> PresetInfo {
  let preset = @preset.PosterPreset::youtube_thumbnail()
  {
    name: preset.name,
    summary: "Wide 16:9 hero suitable for release thumbnails, cover banners, and livestream cards.",
    width: preset.canvas.width,
    height: preset.canvas.height,
    safe_margin: preset.margin.left,
    aspect_ratio: preset.aspect_ratio_label(),
  }
}

///|
fn social_story_info() -> PresetInfo {
  let preset = @preset.PosterPreset::social_story()
  {
    name: preset.name,
    summary: "Tall 9:16 story layout for teasers, editorial slides, and mobile-first updates.",
    width: preset.canvas.width,
    height: preset.canvas.height,
    safe_margin: preset.margin.left,
    aspect_ratio: preset.aspect_ratio_label(),
  }
}

///|
pub fn list_presets() -> Array[PresetInfo] {
  [instagram_square_info(), youtube_thumbnail_info(), social_story_info()]
}

///|
pub fn preset_names() -> Array[String] {
  ["instagram-square", "youtube-thumbnail", "social-story"]
}

///|
pub fn resolve_preset(name : String) -> @preset.PosterPreset? {
  match name {
    "instagram-square" => Some(@preset.PosterPreset::instagram_square())
    "youtube-thumbnail" => Some(@preset.PosterPreset::youtube_thumbnail())
    "social-story" => Some(@preset.PosterPreset::social_story())
    _ => None
  }
}

///|
pub fn resolve_preset_info(name : String) -> PresetInfo? {
  match name {
    "instagram-square" => Some(instagram_square_info())
    "youtube-thumbnail" => Some(youtube_thumbnail_info())
    "social-story" => Some(social_story_info())
    _ => None
  }
}
