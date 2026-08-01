test "Color::hex normalizes missing hash prefix" {
  inspect(Color::hex("f25f5c").as_css(), content="#f25f5c")
  inspect(Color::hex("#247ba0").as_css(), content="#247ba0")
}

test "warm editorial theme exposes a readable palette" {
  let theme = Theme::warm_editorial()
  inspect(theme.name, content="warm-editorial")
  inspect(theme.background.as_css(), content="#f8f0e3")
  inspect(theme.foreground.as_css(), content="#1f1a17")
  inspect(theme.accent.as_css(), content="#ef7d57")
  inspect(theme.padding.left, content="96")
}

test "swiss grid theme exposes cool contrast colors" {
  let theme = Theme::swiss_grid()
  inspect(theme.name, content="swiss-grid")
  inspect(theme.background.as_css(), content="#fffdf6")
  inspect(theme.accent.as_css(), content="#0057ff")
  inspect(theme.padding.left, content="84")
}
