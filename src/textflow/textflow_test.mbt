///|
fn second_line_y(element : @scene.Element) -> Int {
  match element {
    Text(position~, ..) => position.y
    _ => -1
  }
}

///|
fn second_line_content(element : @scene.Element) -> String {
  match element {
    Text(content~, ..) => content
    _ => ""
  }
}

///|
test "wrap_text keeps latin words intact when possible" {
  let lines = wrap_text("MoonBit poster generation toolkit", max_chars=12)
  debug_inspect(
    lines,
    content="[\"MoonBit\", \"poster\", \"generation\", \"toolkit\"]",
  )
}

///|
test "wrap_text chunks cjk content by character budget" {
  let lines = wrap_text("海报生成工具包", max_chars=4)
  debug_inspect(lines, content="[\"海报生成\", \"工具包\"]")
}

///|
test "paragraph_to_elements emits vertically stacked text nodes" {
  let elements = paragraph_to_elements(
    id_prefix="body",
    region=@scene.Rect::{ x: 0, y: 0, width: 140, height: 260 },
    content="MoonBit poster generation toolkit",
    style=@scene.TextStyle::body(@theme.Theme::warm_editorial()),
  )
  inspect(elements.length(), content="4")
  inspect(second_line_content(elements[1]), content="poster")
  inspect(second_line_y(elements[1]), content="48")
}
