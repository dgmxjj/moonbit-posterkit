///|
pub(all) struct CliBatchReport {
  input : String
  jobs : Int
  valid : Bool
  templates : Array[String]
  presets : Array[String]
  themes : Array[String]
  output_directory : String
} derive(Debug, Eq, ToJson)

///|
pub fn batch_report(
  input~ : String,
  output_directory~ : String,
  batch : @config.BatchJob,
) -> CliBatchReport {
  match @config.validate_batch(batch) {
    Ok(summary) =>
      {
        input,
        jobs: summary.total_jobs,
        valid: true,
        templates: summary.templates,
        presets: summary.presets,
        themes: summary.themes,
        output_directory,
      }
    Err(_) => {
      let mut known = true
      batch.jobs.each(job => {
        known = known &&
          @registry.resolve_template_name(job.template) is Some(_) &&
          @registry.resolve_preset(job.preset) is Some(_) &&
          @registry.resolve_theme(job.theme) is Some(_)
      })
      {
        input,
        jobs: batch.jobs.length(),
        valid: known,
        templates: [],
        presets: [],
        themes: [],
        output_directory,
      }
    }
  }
}

///|
pub fn batch_report_text(report : CliBatchReport) -> String {
  let valid = if report.valid { "true" } else { "false" }
  "input=" +
  report.input +
  ",jobs=" +
  report.jobs.to_string() +
  ",valid=" +
  valid +
  ",output=" +
  report.output_directory
}

///|
pub fn batch_report_json(report : CliBatchReport) -> String {
  report.to_json().stringify()
}
