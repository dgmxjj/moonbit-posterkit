fn sample_json() -> Json {
  {
    "jobs": [
      {
        "slug": "launch-square",
        "template": "launch",
        "preset": "instagram-square",
        "theme": "warm-editorial",
        "content": {
          "eyebrow": "MoonBit Hackathon 2026",
          "title": "MoonBit PosterKit",
          "subtitle": "Data-driven poster generation DSL",
          "body": "Compose reusable layouts, typography, image slots, and presets with typed MoonBit APIs.",
          "cta": "Build once, render everywhere",
          "footer": "mooncakes.io / github",
          "image_label": "Replace Cover Art",
          "image_asset_id": "cover-art",
        },
      },
    ],
  }
}

fn render_count(result : Result[Array[RenderedPoster], ConfigError]) -> Int {
  match result {
    Ok(posters) => posters.length()
    Err(_) => -1
  }
}

fn first_svg_contains(
  result : Result[Array[RenderedPoster], ConfigError],
  text : String,
) -> Bool {
  match result {
    Ok(posters) => posters[0].svg.contains(text)
    Err(_) => false
  }
}

fn unknown_theme_name(result : Result[RenderedPoster, ConfigError]) -> String {
  match result {
    Err(UnknownTheme(name~)) => name
    _ => ""
  }
}

test "parse_batch decodes typed poster jobs from json" {
  let raw = sample_json().stringify()
  inspect(
    match parse_batch(raw) {
      Ok(batch) => batch.jobs.length()
      Err(_) => -1
    },
    content="1",
  )
}

test "render_batch produces svg payloads" {
  let raw = sample_json().stringify()
  let batch = match parse_batch(raw) {
    Ok(batch) => batch
    Err(_) => { jobs: [] }
  }
  let rendered = render_batch(batch)
  inspect(render_count(rendered), content="1")
  inspect(first_svg_contains(rendered, "MoonBit PosterKit"), content="true")
  inspect(first_svg_contains(rendered, "data-asset-id=\"cover-art\""), content="true")
}

test "render_job rejects unknown themes with a typed error" {
  let job = PosterJob::{
    slug: "broken",
    template: "launch",
    preset: "instagram-square",
    theme: "unknown-theme",
    content: @template.TemplateContent::{
      eyebrow: "MoonBit Hackathon 2026",
      title: "MoonBit PosterKit",
      subtitle: "Data-driven poster generation DSL",
      body: "Compose reusable layouts and templates in MoonBit.",
      cta: "Build once, render everywhere",
      footer: "mooncakes.io / github",
      image_label: "Replace Cover Art",
      image_asset_id: "cover-art",
    },
  }
  inspect(unknown_theme_name(render_job(job)), content="unknown-theme")
}
