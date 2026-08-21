///|
test "cli batch report exposes validation and output context" {
  let content = @template.TemplateContent::{
    eyebrow: "e",
    title: "t",
    subtitle: "s",
    body: "b",
    cta: "c",
    footer: "f",
    image_label: "image",
    image_asset_id: "asset",
  }
  let batch : @config.BatchJob = {
    jobs: [
      {
        slug: "report",
        template: "launch",
        preset: "instagram-square",
        theme: "warm-editorial",
        content,
      },
    ],
  }
  let report = batch_report(input="input.json", output_directory="dist", batch)
  inspect(report.valid, content="true")
  inspect(report.jobs, content="1")
  inspect(batch_report_text(report).contains("valid=true"), content="true")
  inspect(batch_report_json(report).contains("input.json"), content="true")
}
