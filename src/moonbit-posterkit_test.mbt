test "root facade re-exports Size helpers" {
  inspect(Size::square(512).width, content="512")
}

test "root facade re-exports poster themes and presets" {
  inspect(Theme::warm_editorial().name, content="warm-editorial")
  inspect(PosterPreset::instagram_square().canvas.height, content="1080")
}

test "root facade re-exports scene helpers and svg renderer" {
  let document = PosterDocument::empty(
    title="teaser",
    preset=PosterPreset::instagram_square(),
    theme=Theme::warm_editorial(),
  )
  inspect(render_svg(document).contains("<svg"), content="true")
}

test "root facade re-exports layout and textflow helpers" {
  inspect(
    wrap_text("MoonBit poster generation toolkit", max_chars=12).length(),
    content="4",
  )
  inspect(
    stack_vertical(
      region=Rect::{ x: 0, y: 0, width: 640, height: 300 },
      item_heights=[100, 80],
      gap=20,
    )
    .length(),
    content="2",
  )
}

test "root facade re-exports built-in templates" {
  let document = render_template(
    template="launch",
    preset=PosterPreset::instagram_square(),
    theme=Theme::warm_editorial(),
    content=TemplateContent::{
      eyebrow: "MoonBit Hackathon 2026",
      title: "MoonBit PosterKit",
      subtitle: "Data-driven poster generation DSL",
      body: "Compose reusable layouts and templates in MoonBit.",
      cta: "Build once, render everywhere",
      footer: "mooncakes.io / github",
      image_label: "Replace Cover Art",
      image_asset_id: "cover-art",
    },
  )
  inspect(document.elements.length() >= 6, content="true")
}

test "root facade re-exports config rendering helpers" {
  let batch = BatchJob::{
    jobs: [
      PosterJob::{
        slug: "launch-square",
        template: "launch",
        preset: "instagram-square",
        theme: "warm-editorial",
        content: TemplateContent::{
          eyebrow: "MoonBit Hackathon 2026",
          title: "MoonBit PosterKit",
          subtitle: "Data-driven poster generation DSL",
          body: "Compose reusable layouts and templates in MoonBit.",
          cta: "Build once, render everywhere",
          footer: "mooncakes.io / github",
          image_label: "Replace Cover Art",
          image_asset_id: "cover-art",
        },
      },
    ],
  }
  inspect(
    match render_batch(batch) {
      Ok(rendered) => rendered.length()
      Err(_) => -1
    },
    content="1",
  )
}
