pub(all) struct Color {
  css : String
} derive(Debug, Eq)

pub(all) struct Theme {
  name : String
  background : Color
  foreground : Color
  accent : Color
  muted : Color
  padding : @core.EdgeInsets
  title_size : Int
  body_size : Int
  caption_size : Int
} derive(Debug, Eq)

pub fn Color::hex(raw : String) -> Color {
  if raw.has_prefix("#") {
    { css: raw }
  } else {
    { css: "#" + raw }
  }
}

pub fn Color::as_css(color : Color) -> String {
  color.css
}

pub fn Theme::warm_editorial() -> Theme {
  {
    name: "warm-editorial",
    background: Color::hex("#f8f0e3"),
    foreground: Color::hex("#1f1a17"),
    accent: Color::hex("#ef7d57"),
    muted: Color::hex("#7c6f64"),
    padding: @core.EdgeInsets::all(96),
    title_size: 96,
    body_size: 34,
    caption_size: 24,
  }
}

pub fn Theme::swiss_grid() -> Theme {
  {
    name: "swiss-grid",
    background: Color::hex("#fffdf6"),
    foreground: Color::hex("#111111"),
    accent: Color::hex("#0057ff"),
    muted: Color::hex("#7b7b7b"),
    padding: @core.EdgeInsets::all(84),
    title_size: 88,
    body_size: 32,
    caption_size: 22,
  }
}
