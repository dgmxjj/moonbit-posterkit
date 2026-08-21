///|
test "document analysis counts content and occupied areas" {
  let document = PosterDocument::empty(
      title="analysis",
      preset=@preset.PosterPreset::instagram_square(),
      theme=@theme.Theme::warm_editorial(),
    )
    .push(
      Element::Block(
        id="panel",
        rect={ x: 0, y: 0, width: 100, height: 200 },
        fill=@theme.Color::hex("#fff"),
        radius=4,
      ),
    )
    .push(
      Element::Text(
        id="title",
        content="Hello MoonBit",
        position={ x: 10, y: 20 },
        style=TextStyle::body(@theme.Theme::warm_editorial()),
        max_width=300,
      ),
    )
    .push(
      Element::ImageSlot(
        id="image",
        asset_id="hero",
        rect={ x: 10, y: 20, width: 50, height: 60 },
        label="Hero",
        fit=ImageFit::Cover,
      ),
    )
  let stats = analyze_document(document)
  inspect(stats.element_count, content="3")
  inspect(stats.block_count, content="1")
  inspect(stats.text_count, content="1")
  inspect(stats.image_slot_count, content="1")
  inspect(stats.text_characters, content="17")
  inspect(stats.occupied_area, content="23000")
}

///|
test "document analysis finds elements and sorts ids" {
  let document = PosterDocument::empty(
      title="find",
      preset=@preset.PosterPreset::instagram_square(),
      theme=@theme.Theme::warm_editorial(),
    )
    .push(
      Element::Text(
        id="zeta",
        content="z",
        position={ x: 1, y: 1 },
        style=TextStyle::body(@theme.Theme::warm_editorial()),
        max_width=10,
      ),
    )
    .push(
      Element::Text(
        id="alpha",
        content="a",
        position={ x: 1, y: 1 },
        style=TextStyle::body(@theme.Theme::warm_editorial()),
        max_width=10,
      ),
    )
  debug_inspect(element_ids_sorted(document), content="[\"alpha\", \"zeta\"]")
  inspect(find_element(document, "alpha") is Some(_), content="true")
}
