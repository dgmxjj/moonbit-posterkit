///|
test "contrast report distinguishes strong and weak color pairs" {
  let strong = contrast_report(Color::hex("#111111"), Color::hex("#ffffff"))
  let weak = contrast_report(Color::hex("#bbbbbb"), Color::hex("#ffffff"))
  inspect(contrast_rating_text(strong.rating), content="pass")
  inspect(contrast_rating_text(weak.rating), content="fail")
}

///|
test "built-in themes expose body contrast reports" {
  let warm = Theme::warm_editorial().body_contrast()
  let swiss = Theme::swiss_grid().accent_contrast()
  inspect(warm.foreground, content="#1f1a17")
  inspect(swiss.background, content="#fffdf6")
  inspect(warm.ratio > 100, content="true")
}
