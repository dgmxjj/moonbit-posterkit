///|
fn warm_editorial_info() -> ThemeInfo {
  let theme = @theme.Theme::warm_editorial()
  {
    name: theme.name,
    summary: "Warm editorial palette with soft paper tones and orange accents for launch and event work.",
    background: theme.background.as_css(),
    foreground: theme.foreground.as_css(),
    accent: theme.accent.as_css(),
    padding: theme.padding.left,
    title_size: theme.title_size,
    body_size: theme.body_size,
  }
}

///|
fn swiss_grid_info() -> ThemeInfo {
  let theme = @theme.Theme::swiss_grid()
  {
    name: theme.name,
    summary: "Clean high-contrast system with grid-friendly spacing for stories, digests, and product cards.",
    background: theme.background.as_css(),
    foreground: theme.foreground.as_css(),
    accent: theme.accent.as_css(),
    padding: theme.padding.left,
    title_size: theme.title_size,
    body_size: theme.body_size,
  }
}

///|
pub fn list_themes() -> Array[ThemeInfo] {
  [warm_editorial_info(), swiss_grid_info()]
}

///|
pub fn theme_names() -> Array[String] {
  ["warm-editorial", "swiss-grid"]
}

///|
pub fn resolve_theme(name : String) -> @theme.Theme? {
  match name {
    "warm-editorial" => Some(@theme.Theme::warm_editorial())
    "swiss-grid" => Some(@theme.Theme::swiss_grid())
    _ => None
  }
}

///|
pub fn resolve_theme_info(name : String) -> ThemeInfo? {
  match name {
    "warm-editorial" => Some(warm_editorial_info())
    "swiss-grid" => Some(swiss_grid_info())
    _ => None
  }
}
