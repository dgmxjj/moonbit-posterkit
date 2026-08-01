///|
fn launch_info() -> TemplateInfo {
  {
    name: "launch",
    summary: "Hero-driven release template with headline, body copy, call to action, and image slot.",
    default_preset: "instagram-square",
    default_theme: "warm-editorial",
    supported_presets: ["instagram-square", "youtube-thumbnail", "social-story"],
    supported_themes: ["warm-editorial", "swiss-grid"],
  }
}

///|
fn editorial_info() -> TemplateInfo {
  {
    name: "editorial",
    summary: "Storytelling template that balances cover imagery, kicker text, and long-form editorial copy.",
    default_preset: "social-story",
    default_theme: "swiss-grid",
    supported_presets: ["social-story", "instagram-square"],
    supported_themes: ["swiss-grid", "warm-editorial"],
  }
}

///|
fn event_info() -> TemplateInfo {
  {
    name: "event",
    summary: "Operational event card for title, schedule, venue notes, and speaker or venue imagery.",
    default_preset: "instagram-square",
    default_theme: "warm-editorial",
    supported_presets: ["instagram-square", "social-story"],
    supported_themes: ["warm-editorial", "swiss-grid"],
  }
}

///|
fn quote_info() -> TemplateInfo {
  {
    name: "quote",
    summary: "Quotation-led social card with a portrait slot, speaker attribution, and supporting context.",
    default_preset: "instagram-square",
    default_theme: "warm-editorial",
    supported_presets: ["instagram-square", "social-story"],
    supported_themes: ["warm-editorial", "swiss-grid"],
  }
}

///|
fn digest_info() -> TemplateInfo {
  {
    name: "digest",
    summary: "Editorial digest layout for weekly recaps, release notes, and summary-first campaign cards.",
    default_preset: "youtube-thumbnail",
    default_theme: "swiss-grid",
    supported_presets: ["youtube-thumbnail", "instagram-square", "social-story"],
    supported_themes: ["swiss-grid", "warm-editorial"],
  }
}

///|
pub fn list_templates() -> Array[TemplateInfo] {
  [launch_info(), editorial_info(), event_info(), quote_info(), digest_info()]
}

///|
pub fn template_names() -> Array[String] {
  ["launch", "editorial", "event", "quote", "digest"]
}

///|
pub fn resolve_template_name(name : String) -> String? {
  match name {
    "digest" => Some(name)
    "launch" => Some(name)
    "editorial" => Some(name)
    "event" => Some(name)
    "quote" => Some(name)
    _ => None
  }
}

///|
pub fn resolve_template_info(name : String) -> TemplateInfo? {
  match name {
    "digest" => Some(digest_info())
    "launch" => Some(launch_info())
    "editorial" => Some(editorial_info())
    "event" => Some(event_info())
    "quote" => Some(quote_info())
    _ => None
  }
}
