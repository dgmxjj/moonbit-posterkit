///|
pub(all) struct PosterJob {
  slug : String
  template : String
  preset : String
  theme : String
  content : @template.TemplateContent
} derive(Debug, Eq, FromJson, ToJson)

///|
pub(all) struct BatchJob {
  jobs : Array[PosterJob]
} derive(Debug, Eq, FromJson, ToJson)

///|
pub(all) struct RenderedPoster {
  slug : String
  svg : String
} derive(Debug, Eq)

///|
pub(all) struct ValidationSummary {
  total_jobs : Int
  slugs : Array[String]
  templates : Array[String]
  presets : Array[String]
  themes : Array[String]
} derive(Debug, Eq, ToJson)

///|
pub(all) enum ConfigError {
  InvalidJson(message~ : String)
  UnknownPreset(name~ : String)
  UnknownTheme(name~ : String)
  UnknownTemplate(name~ : String)
  DuplicateSlug(name~ : String)
} derive(Debug, Eq)

///|
fn contains_name(values : Array[String], target : String) -> Bool {
  values.any(value => value == target)
}

///|
fn push_unique(values : Array[String], target : String) -> Unit {
  if !contains_name(values, target) {
    values.push(target)
  }
}

///|
fn validate_job(job : PosterJob) -> ConfigError? {
  match @registry.resolve_preset(job.preset) {
    Some(_) =>
      match @registry.resolve_theme(job.theme) {
        Some(_) =>
          match @registry.resolve_template_name(job.template) {
            Some(_) => None
            None => Some(ConfigError::UnknownTemplate(name=job.template))
          }
        None => Some(ConfigError::UnknownTheme(name=job.theme))
      }
    None => Some(ConfigError::UnknownPreset(name=job.preset))
  }
}

///|
pub fn parse_batch(raw : String) -> Result[BatchJob, ConfigError] {
  try {
    let batch : BatchJob = @json.from_json(@json.parse(raw))
    Ok(batch)
  } catch {
    _ => Err(ConfigError::InvalidJson(message="invalid-json"))
  }
}

///|
fn validate_jobs(
  jobs : Array[PosterJob],
  index : Int,
  slugs : Array[String],
  templates : Array[String],
  presets : Array[String],
  themes : Array[String],
) -> Result[ValidationSummary, ConfigError] {
  if index >= jobs.length() {
    Ok({ total_jobs: jobs.length(), slugs, templates, presets, themes })
  } else {
    let job = jobs[index]
    match validate_job(job) {
      Some(error) => Err(error)
      None =>
        if contains_name(slugs, job.slug) {
          Err(ConfigError::DuplicateSlug(name=job.slug))
        } else {
          slugs.push(job.slug)
          push_unique(templates, job.template)
          push_unique(presets, job.preset)
          push_unique(themes, job.theme)
          validate_jobs(jobs, index + 1, slugs, templates, presets, themes)
        }
    }
  }
}

///|
pub fn validate_batch(
  batch : BatchJob,
) -> Result[ValidationSummary, ConfigError] {
  validate_jobs(batch.jobs, 0, [], [], [], [])
}

///|
/// Build the typed scene document for export backends.
pub fn render_job_document(
  job : PosterJob,
) -> Result[@scene.PosterDocument, ConfigError] {
  match @registry.resolve_preset(job.preset) {
    Some(preset) =>
      match @registry.resolve_theme(job.theme) {
        Some(theme) =>
          match @registry.resolve_template_name(job.template) {
            Some(template) => {
              let document = @template.render_template(
                template~,
                preset~,
                theme~,
                content=job.content,
              )
              Ok(document)
            }
            None => Err(ConfigError::UnknownTemplate(name=job.template))
          }
        None => Err(ConfigError::UnknownTheme(name=job.theme))
      }
    None => Err(ConfigError::UnknownPreset(name=job.preset))
  }
}

///|
/// Render a job to the existing SVG output.
pub fn render_job(job : PosterJob) -> Result[RenderedPoster, ConfigError] {
  match render_job_document(job) {
    Ok(document) => Ok({ slug: job.slug, svg: @svg.render_svg(document) })
    Err(error) => Err(error)
  }
}

///|
fn render_jobs(
  jobs : Array[PosterJob],
  index : Int,
  rendered : Array[RenderedPoster],
) -> Result[Array[RenderedPoster], ConfigError] {
  if index >= jobs.length() {
    Ok(rendered)
  } else {
    match render_job(jobs[index]) {
      Ok(poster) => {
        rendered.push(poster)
        render_jobs(jobs, index + 1, rendered)
      }
      Err(error) => Err(error)
    }
  }
}

///|
pub fn render_batch(
  batch : BatchJob,
) -> Result[Array[RenderedPoster], ConfigError] {
  match validate_batch(batch) {
    Ok(_) => render_jobs(batch.jobs, 0, [])
    Err(error) => Err(error)
  }
}
