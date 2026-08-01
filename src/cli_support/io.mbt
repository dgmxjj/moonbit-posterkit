///|
fn ensure_output_dir(path : String) -> CliError? {
  if @fs.path_exists(path) {
    None
  } else {
    try {
      @fs.create_dir(path)
      None
    } catch {
      @fs.IOError(message) => Some(CliError::IO(path~, message~))
    }
  }
}

///|
fn read_batch(path : String) -> Result[@config.BatchJob, CliError] {
  try {
    let raw = @fs.read_file_to_string(path, encoding="utf8")
    match @config.parse_batch(raw) {
      Ok(batch) => Ok(batch)
      Err(error) => Err(CliError::Render(error~))
    }
  } catch {
    @fs.IOError(message) => Err(CliError::IO(path~, message~))
  }
}

///|
fn read_job(path : String) -> Result[@config.PosterJob, CliError] {
  try {
    let raw = @fs.read_file_to_string(path, encoding="utf8")
    try {
      let job : @config.PosterJob = @json.from_json(@json.parse(raw))
      Ok(job)
    } catch {
      _ => Err(CliError::Render(error=InvalidJson(message="invalid-json")))
    }
  } catch {
    @fs.IOError(message) => Err(CliError::IO(path~, message~))
  }
}

///|
fn write_text(path : String, content : String) -> CliError? {
  try {
    @fs.write_string_to_file(path, content, encoding="utf8")
    None
  } catch {
    @fs.IOError(message) => Some(CliError::IO(path~, message~))
  }
}

///|
fn write_posters(
  posters : Array[@config.RenderedPoster],
  output_dir : String,
  index : Int,
) -> CliError? {
  if index >= posters.length() {
    None
  } else {
    let poster = posters[index]
    let path = output_path(output_dir, poster.slug)
    match write_text(path, poster.svg) {
      Some(error) => Some(error)
      None => write_posters(posters, output_dir, index + 1)
    }
  }
}
