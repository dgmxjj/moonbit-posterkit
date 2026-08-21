///|
test "paragraph profile recognizes lines words and CJK" {
  let profile = profile_paragraph("MoonBit 海报\n可测试输出")
  inspect(profile.lines, content="2")
  inspect(profile.has_cjk, content="true")
  inspect(profile.has_explicit_breaks, content="true")
  inspect(profile.characters > 10, content="true")
}

///|
test "text fit and line height are deterministic" {
  let style = @scene.TextStyle::body(@theme.Theme::warm_editorial())
  inspect(line_height_for(style, 3), content="144")
  inspect(text_fits_lines("short", style, 400, 3), content="true")
}
