///|
fn svg_document() -> @scene.PosterDocument {
  @scene.PosterDocument::empty(
    title="metrics",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  )
  .push(
    @scene.Element::Block(
      id="panel",
      rect={ x: 10, y: 10, width: 100, height: 100 },
      fill=@theme.Color::hex("#ffffff"),
      radius=4,
    ),
  )
  .push(
    @scene.Element::Text(
      id="title",
      content="<MoonBit & SVG>",
      position={ x: 20, y: 40 },
      style=@scene.TextStyle::body(@theme.Theme::warm_editorial()),
      max_width=300,
    ),
  )
  .push(
    @scene.Element::ImageSlot(
      id="cover",
      asset_id="cover&1",
      rect={ x: 10, y: 120, width: 100, height: 80 },
      label="Cover",
      fit=@scene.ImageFit::Contain,
    ),
  )
}

///|
test "svg escaping protects text and attributes" {
  inspect(escape_text("<a & b>"), content="&lt;a &amp; b&gt;")
  inspect(escape_attribute("quote\""), content="quote&quot;")
  let (svg, metrics) = render_svg_with_metrics(svg_document())
  inspect(svg.contains("&lt;MoonBit &amp; SVG&gt;"), content="true")
  inspect(metrics.element_count, content="3")
  inspect(metrics.text_count, content="1")
  inspect(metrics.image_slot_count, content="1")
  inspect(metrics.block_count, content="1")
  inspect(metrics.bytes > 0, content="true")
}
