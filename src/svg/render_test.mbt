fn demo_document() -> @scene.PosterDocument {
  @scene.PosterDocument::empty(
    title="launch",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  )
  .push(
    @scene.Element::Block(
      id="panel",
      rect=@scene.Rect::{ x: 96, y: 96, width: 888, height: 888 },
      fill=@theme.Color::hex("#fffaf2"),
      radius=32,
    ),
  )
  .push(
    @scene.Element::Text(
      id="headline",
      content="MoonBit PosterKit",
      position=@scene.Point::at(140, 220),
      style=@scene.TextStyle::display(@theme.Theme::warm_editorial()),
      max_width=720,
    ),
  )
  .push(
    @scene.Element::ImageSlot(
      id="hero",
      asset_id="cover-art",
      rect=@scene.Rect::{ x: 140, y: 360, width: 800, height: 440 },
      label="Replace Me",
      fit=@scene.ImageFit::Cover,
    ),
  )
}

test "render_svg emits svg root and background" {
  let svg = render_svg(demo_document())
  inspect(svg.contains("<svg"), content="true")
  inspect(svg.contains("viewBox=\"0 0 1080 1080\""), content="true")
  inspect(svg.contains("fill=\"#f8f0e3\""), content="true")
}

test "render_svg includes text and image placeholders" {
  let svg = render_svg(demo_document())
  inspect(svg.contains("MoonBit PosterKit"), content="true")
  inspect(svg.contains("data-asset-id=\"cover-art\""), content="true")
  inspect(svg.contains("Replace Me"), content="true")
}
