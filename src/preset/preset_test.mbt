test "instagram square preset exposes expected canvas and safe area" {
  let preset = PosterPreset::instagram_square()
  inspect(preset.canvas.width, content="1080")
  inspect(preset.canvas.height, content="1080")
  debug_inspect(
    preset.safe_area(),
    content="{ top: 96, right: 96, bottom: 96, left: 96 }",
  )
}

test "youtube thumbnail preset keeps widescreen aspect ratio" {
  let preset = PosterPreset::youtube_thumbnail()
  inspect(preset.canvas.width, content="1280")
  inspect(preset.canvas.height, content="720")
  inspect(preset.aspect_ratio_label(), content="16:9")
}
