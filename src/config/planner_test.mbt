///|
fn planner_batch() -> BatchJob {
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
  {
    jobs: [
      {
        slug: "first",
        template: "launch",
        preset: "instagram-square",
        theme: "warm-editorial",
        content,
      },
      {
        slug: "second",
        template: "event",
        preset: "social-story",
        theme: "swiss-grid",
        content,
      },
    ],
  }
}

///|
test "output planner creates stable relative svg paths" {
  let plans = output_plan("dist", planner_batch())
  inspect(plans.length(), content="2")
  inspect(plans[0].relative_path, content="dist/first.svg")
  inspect(plans[1].index, content="1")
  inspect(plan_summary(plans).contains("outputs=2"), content="true")
}

///|
test "output planner rejects unsafe slugs and detects duplicate paths" {
  inspect(valid_output_slug("release_01"), content="true")
  inspect(valid_output_slug("../escape"), content="false")
  let batch = planner_batch()
  let duplicate : BatchJob = {
    jobs: [batch.jobs[0], { ..batch.jobs[1], slug: "first" }],
  }
  inspect(
    plan_has_duplicate_paths(output_plan("dist", duplicate)),
    content="true",
  )
  inspect(invalid_slugs(duplicate).length(), content="0")
}
