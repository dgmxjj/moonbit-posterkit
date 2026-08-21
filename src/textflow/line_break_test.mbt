///|
test "split_lines preserves explicit empty lines" {
  debug_inspect(split_lines("one\n\ntwo"), content="[\"one\", \"\", \"two\"]")
}

///|
test "truncate_text reserves room for the ellipsis" {
  inspect(
    truncate_text("MoonBit PosterKit", max_chars=10, ellipsis="..."),
    content="MoonBit...",
  )
  inspect(truncate_text("MoonBit", max_chars=2, ellipsis="..."), content="..")
}

///|
test "measure_text reports line count height and truncation" {
  let style = @scene.TextStyle::body(@theme.Theme::warm_editorial())
  let measured = measure_text(
    "MoonBit poster generation toolkit",
    style,
    max_width=120,
    max_lines=2,
  )
  inspect(measured.lines.length(), content="2")
  inspect(measured.height, content="96")
  inspect(measured.truncated, content="true")
}
