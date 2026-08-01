test "Size::square and EdgeInsets helpers" {
  inspect(Size::square(1080).width, content="1080")
  inspect(Size::square(1080).height, content="1080")
  debug_inspect(
    EdgeInsets::all(48),
    content="{ top: 48, right: 48, bottom: 48, left: 48 }",
  )
}

test "EdgeInsets::zero returns all-zero padding" {
  debug_inspect(
    EdgeInsets::zero(),
    content="{ top: 0, right: 0, bottom: 0, left: 0 }",
  )
}
