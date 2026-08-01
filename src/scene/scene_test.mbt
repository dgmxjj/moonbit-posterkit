///|
test "PosterDocument::empty starts with no elements" {
  let document = PosterDocument::empty(
    title="launch",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  )
  inspect(document.elements.length(), content="0")
}

///|
test "PosterDocument::push appends blocks and text elements" {
  let base = PosterDocument::empty(
    title="launch",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  )
  let with_block = base.push(
    Element::Block(
      id="panel",
      rect=Rect::{ x: 96, y: 96, width: 888, height: 888 },
      fill=@theme.Color::hex("#ffffff"),
      radius=32,
    ),
  )
  let poster = with_block.push(
    Element::Text(
      id="headline",
      content="MoonBit PosterKit",
      position=Point::at(140, 200),
      style=TextStyle::display(@theme.Theme::warm_editorial()),
      max_width=720,
    ),
  )
  inspect(poster.elements.length(), content="2")
}
