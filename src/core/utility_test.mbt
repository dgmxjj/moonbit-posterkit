///|
test "integer utilities handle empty and inverted ranges" {
  inspect(clamp_int(5, 0, 3), content="3")
  inspect(clamp_int(5, 10, 2), content="5")
  inspect(sum_ints([1, 2, 3]), content="6")
  inspect(average_ints([]), content="0")
  debug_inspect(min_int([-3, 4, 2]), content="Some(-3)")
  debug_inspect(max_int([-3, 4, 2]), content="Some(4)")
}

///|
test "string utilities support report and filename formatting" {
  inspect(repeat_string("-", 4), content="----")
  inspect(
    join_non_empty(["", "MoonBit", " ", "SVG"], ","),
    content="MoonBit,SVG",
  )
  inspect(
    safe_filename("  release notes  ", "untitled"),
    content="release-notes",
  )
  inspect(safe_filename(" ", "untitled"), content="untitled")
}
