///|
test "render batch metrics count rendered svg bytes" {
  let content = @template.TemplateContent::{
    eyebrow: "News",
    title: "Metrics",
    subtitle: "Measured output",
    body: "Batch rendering",
    cta: "Run",
    footer: "MoonBit",
    image_label: "Cover",
    image_asset_id: "asset",
  }
  let result = render_batch_with_metrics({
    jobs: [
      {
        slug: "metrics",
        template: "launch",
        preset: "instagram-square",
        theme: "warm-editorial",
        content,
      },
    ],
  })
  match result {
    Ok((posters, metrics)) => {
      inspect(posters.length(), content="1")
      inspect(metrics.succeeded, content="1")
      inspect(metrics.failed, content="0")
      inspect(metrics.total_svg_bytes > 0, content="true")
      inspect(
        metrics.average_svg_bytes,
        content=metrics.total_svg_bytes.to_string(),
      )
    }
    Err(_) => inspect(false, content="true")
  }
}
