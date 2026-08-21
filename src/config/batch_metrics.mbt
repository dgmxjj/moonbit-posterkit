///|
pub(all) struct BatchMetrics {
  total : Int
  succeeded : Int
  failed : Int
  total_svg_bytes : Int
  average_svg_bytes : Int
} derive(Debug, Eq, ToJson)

///|
pub fn BatchMetrics::empty(total : Int) -> BatchMetrics {
  {
    total,
    succeeded: 0,
    failed: total,
    total_svg_bytes: 0,
    average_svg_bytes: 0,
  }
}

///|
pub fn render_batch_with_metrics(
  batch : BatchJob,
) -> Result[(Array[RenderedPoster], BatchMetrics), ConfigError] {
  match validate_batch(batch) {
    Err(error) => Err(error)
    Ok(_) => {
      let posters : Array[RenderedPoster] = []
      let mut bytes = 0
      batch.jobs.each(job => {
        match render_job(job) {
          Ok(poster) => {
            bytes = bytes + poster.svg.length()
            posters.push(poster)
          }
          Err(_) => ()
        }
      })
      let total = batch.jobs.length()
      let succeeded = posters.length()
      let failed = total - succeeded
      Ok(
        (
          posters,
          {
            total,
            succeeded,
            failed,
            total_svg_bytes: bytes,
            average_svg_bytes: if succeeded == 0 {
              0
            } else {
              bytes / succeeded
            },
          },
        ),
      )
    }
  }
}
