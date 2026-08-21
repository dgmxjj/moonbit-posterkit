///|
pub(all) struct ValidationIssue {
  job_index : Int
  field : String
  code : String
  message : String
} derive(Debug, Eq, ToJson)

///|
fn issue(
  index : Int,
  field : String,
  code : String,
  message : String,
) -> ValidationIssue {
  { job_index: index, field, code, message }
}

///|
fn strict_job_issues(job : PosterJob, index : Int) -> Array[ValidationIssue] {
  let issues : Array[ValidationIssue] = []
  if job.slug.trim().is_empty() {
    issues.push(issue(index, "slug", "empty-slug", "slug must not be empty"))
  }
  if job.template.trim().is_empty() {
    issues.push(
      issue(index, "template", "empty-template", "template must not be empty"),
    )
  }
  if job.preset.trim().is_empty() {
    issues.push(
      issue(index, "preset", "empty-preset", "preset must not be empty"),
    )
  }
  if job.theme.trim().is_empty() {
    issues.push(issue(index, "theme", "empty-theme", "theme must not be empty"))
  }
  issues
}

///|
pub fn validate_batch_strict(
  batch : BatchJob,
) -> Result[ValidationSummary, Array[ValidationIssue]] {
  let issues : Array[ValidationIssue] = []
  batch.jobs.eachi((index, job) => {
    strict_job_issues(job, index).each(issue => issues.push(issue))
    match validate_job(job) {
      None => ()
      Some(UnknownPreset(name~)) =>
        issues.push(issue(index, "preset", "unknown-preset", name))
      Some(UnknownTheme(name~)) =>
        issues.push(issue(index, "theme", "unknown-theme", name))
      Some(UnknownTemplate(name~)) =>
        issues.push(issue(index, "template", "unknown-template", name))
      Some(InvalidJson(message~)) =>
        issues.push(issue(index, "job", "invalid-json", message))
      Some(DuplicateSlug(name~)) =>
        issues.push(issue(index, "slug", "duplicate-slug", name))
    }
  })
  if issues.length() > 0 {
    Err(issues)
  } else {
    match validate_batch(batch) {
      Ok(summary) => Ok(summary)
      Err(_) =>
        Err([issue(0, "batch", "invalid-batch", "batch validation failed")])
    }
  }
}

///|
pub fn validation_issues_text(issues : Array[ValidationIssue]) -> String {
  issues
  .map(issue => {
    issue.job_index.to_string() + ":" + issue.field + ":" + issue.code
  })
  .join("\n")
}
