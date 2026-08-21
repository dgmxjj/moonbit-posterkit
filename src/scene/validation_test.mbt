///|
test "scene validation reports duplicate ids and empty asset slots" {
  let theme = @theme.Theme::warm_editorial()
  let document = PosterDocument::empty(
      title="",
      preset=@preset.PosterPreset::instagram_square(),
      theme~,
    )
    .push(
      Element::Block(
        id="panel",
        rect=Rect::{ x: 0, y: 0, width: 200, height: 100 },
        fill=@theme.Color::hex("#ffffff"),
        radius=0,
      ),
    )
    .push(
      Element::ImageSlot(
        id="panel",
        asset_id="",
        rect=Rect::{ x: 10, y: 10, width: 0, height: 10 },
        label="",
        fit=ImageFit::Contain,
      ),
    )
  let diagnostics = validate_document(document, strict=true)
  inspect(diagnostics.length(), content="5")
  inspect(diagnostic_code(diagnostics[0]), content="empty-title")
  inspect(diagnostic_code(diagnostics[1]), content="duplicate-element-id")
}

///|
test "valid scene has no diagnostics" {
  let document = PosterDocument::empty(
    title="poster",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  ).push(
    Element::Text(
      id="title",
      content="Hello",
      position=Point::at(100, 100),
      style=TextStyle::body(@theme.Theme::warm_editorial()),
      max_width=500,
    ),
  )
  inspect(validate_document(document, strict=true).length(), content="0")
}
