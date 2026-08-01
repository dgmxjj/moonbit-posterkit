test "root facade re-exports Size helpers" {
  inspect(Size::square(512).width, content="512")
}
