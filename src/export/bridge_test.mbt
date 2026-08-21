///|
fn bridge_document() -> @scene.PosterDocument {
  @scene.PosterDocument::empty(
    title="Bridge",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  )
  .push(
    @scene.Element::Block(
      id="shell",
      rect={ x: 10, y: 10, width: 120, height: 80 },
      fill=@theme.Color::hex("#ef7d57"),
      radius=8,
    ),
  )
  .push(
    @scene.Element::ImageSlot(
      id="image",
      asset_id="asset",
      rect={ x: 20, y: 20, width: 40, height: 30 },
      label="Image",
      fit=@scene.ImageFit::Contain,
    ),
  )
}

///|
test "bridge renders a poster pdf" {
  let pdf = render_poster_pdf(bridge_document())
  inspect(pdf.has_prefix("%PDF-1.4"), content="true")
  inspect(pdf.contains("120 80 re f"), content="true")
}

///|
test "bridge renders a poster png" {
  let png = render_poster_png(bridge_document())
  inspect(png[0].to_int(), content="137")
  inspect(png.length() > 100, content="true")
}
