///|
pub(all) struct OutputPlan {
  slug : String
  relative_path : String
  index : Int
  template : String
  preset : String
  theme : String
} derive(Debug, Eq, ToJson)

///|
pub fn output_plan(output_dir : String, batch : BatchJob) -> Array[OutputPlan] {
  let plans : Array[OutputPlan] = []
  batch.jobs.eachi((index, job) => {
    let separator = if output_dir.has_suffix("/") || output_dir.has_suffix("\\") {
      ""
    } else {
      "/"
    }
    plans.push({
      slug: job.slug,
      relative_path: output_dir + separator + job.slug + ".svg",
      index,
      template: job.template,
      preset: job.preset,
      theme: job.theme,
    })
  })
  plans
}

///|
pub fn plan_has_duplicate_paths(plans : Array[OutputPlan]) -> Bool {
  let paths : Array[String] = []
  plans.any(plan => {
    if paths.any(path => path == plan.relative_path) {
      true
    } else {
      paths.push(plan.relative_path)
      false
    }
  })
}

///|
pub fn plan_summary(plans : Array[OutputPlan]) -> String {
  if plans.is_empty() {
    "empty-plan"
  } else {
    let first = plans[0]
    "outputs=" +
    plans.length().to_string() +
    ",first=" +
    first.relative_path +
    ",templates=" +
    plans.map(plan => plan.template).join(",")
  }
}

///|
pub fn valid_output_slug(slug : String) -> Bool {
  if slug.is_empty() || slug == "." || slug == ".." {
    false
  } else {
    slug
    .to_array()
    .all(char => {
      (char >= 'a' && char <= 'z') ||
      (char >= 'A' && char <= 'Z') ||
      (char >= '0' && char <= '9') ||
      char == '-' ||
      char == '_' ||
      char == '.'
    })
  }
}

///|
pub fn invalid_slugs(batch : BatchJob) -> Array[String] {
  batch.jobs.map(job => job.slug).filter(slug => !valid_output_slug(slug))
}
