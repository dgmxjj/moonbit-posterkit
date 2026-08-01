pub(all) struct PosterJob {
  slug : String
  template : String
  preset : String
  theme : String
  content : @template.TemplateContent
} derive(Debug, Eq, FromJson, ToJson)

pub(all) struct BatchJob {
  jobs : Array[PosterJob]
} derive(Debug, Eq, FromJson, ToJson)

pub(all) struct RenderedPoster {
  slug : String
  svg : String
} derive(Debug, Eq)

pub(all) enum ConfigError {
  InvalidJson(message~ : String)
  UnknownPreset(name~ : String)
  UnknownTheme(name~ : String)
  UnknownTemplate(name~ : String)
} derive(Debug, Eq)

fn resolve_preset(name : String) -> @preset.PosterPreset? {
  match name {
    "instagram-square" => Some(@preset.PosterPreset::instagram_square())
    "youtube-thumbnail" => Some(@preset.PosterPreset::youtube_thumbnail())
    "social-story" => Some(@preset.PosterPreset::social_story())
    _ => None
  }
}

fn resolve_theme(name : String) -> @theme.Theme? {
  match name {
    "warm-editorial" => Some(@theme.Theme::warm_editorial())
    "swiss-grid" => Some(@theme.Theme::swiss_grid())
    _ => None
  }
}

fn ensure_template(name : String) -> String? {
  match name {
    "launch" => Some(name)
    "editorial" => Some(name)
    "event" => Some(name)
    _ => None
  }
}

pub fn parse_batch(raw : String) -> Result[BatchJob, ConfigError] {
  try {
    let batch : BatchJob = @json.from_json(@json.parse(raw))
    Ok(batch)
  } catch {
    _ => Err(ConfigError::InvalidJson(message="invalid-json"))
  }
}

pub fn render_job(job : PosterJob) -> Result[RenderedPoster, ConfigError] {
  match resolve_preset(job.preset) {
    Some(preset) =>
      match resolve_theme(job.theme) {
        Some(theme) =>
          match ensure_template(job.template) {
            Some(template) => {
              let document = @template.render_template(
                template=template,
                preset=preset,
                theme=theme,
                content=job.content,
              )
              Ok({ slug: job.slug, svg: @svg.render_svg(document) })
            }
            None => Err(ConfigError::UnknownTemplate(name=job.template))
          }
        None => Err(ConfigError::UnknownTheme(name=job.theme))
      }
    None => Err(ConfigError::UnknownPreset(name=job.preset))
  }
}

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

pub fn render_batch(batch : BatchJob) -> Result[Array[RenderedPoster], ConfigError] {
  render_jobs(batch.jobs, 0, [])
}
