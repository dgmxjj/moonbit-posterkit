///|
test "normalization creates safe stable ids and title fallback" {
  let document = PosterDocument::empty(
    title=" ",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  ).push(
    Element::Text(
      id=" Hero Title ",
      content="Hello",
      position={ x: 10, y: 10 },
      style=TextStyle::body(@theme.Theme::warm_editorial()),
      max_width=300,
    ),
  )
  let normalized = normalize_for_render(document)
  inspect(normalized.title, content="Untitled Poster")
  inspect(element_ids(normalized)[0], content="hero-title")
}

///|
test "normalization removes only empty text elements" {
  let document = PosterDocument::empty(
      title="Poster",
      preset=@preset.PosterPreset::instagram_square(),
      theme=@theme.Theme::warm_editorial(),
    )
    .push(
      Element::Text(
        id="empty",
        content=" ",
        position={ x: 1, y: 1 },
        style=TextStyle::body(@theme.Theme::warm_editorial()),
        max_width=100,
      ),
    )
    .push(
      Element::Block(
        id="panel",
        rect={ x: 0, y: 0, width: 10, height: 10 },
        fill=@theme.Color::hex("#fff"),
        radius=0,
      ),
    )
  inspect(normalize_for_render(document).elements.length(), content="1")
}
