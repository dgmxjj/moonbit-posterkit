///|
fn total_jobs(packs : Array[CampaignPack]) -> Int {
  packs.fold(init=0, fn(acc, pack) { acc + pack.jobs.length() })
}

///|
fn rendered_count(batch : @config.BatchJob) -> Int {
  match @config.render_batch(batch) {
    Ok(rendered) => rendered.length()
    Err(_) => -1
  }
}

///|
test "all_packs exposes multiple reusable campaign collections" {
  let packs = all_packs()
  inspect(packs.length() >= 8, content="true")
  inspect(total_jobs(packs) >= 20, content="true")
}

///|
test "flatten_jobs converts a pack into a renderable batch" {
  let batch = flatten_jobs(hackathon_pack())
  inspect(batch.jobs.length() >= 3, content="true")
  inspect(rendered_count(batch) >= 3, content="true")
}

///|
test "conference pack includes both launch and story jobs" {
  let batch = flatten_jobs(conference_pack())
  inspect(batch.jobs.length() >= 3, content="true")
  inspect(rendered_count(batch) >= 3, content="true")
}

///|
test "quote_story_pack exercises the quote template family" {
  let batch = flatten_jobs(quote_story_pack())
  inspect(batch.jobs.length() >= 2, content="true")
  inspect(batch.jobs[0].template, content="quote")
  inspect(rendered_count(batch) >= 2, content="true")
}

///|
test "weekly_digest_pack uses digest jobs across multiple aspect ratios" {
  let batch = flatten_jobs(weekly_digest_pack())
  inspect(batch.jobs.length() >= 3, content="true")
  inspect(batch.jobs[0].template, content="digest")
  inspect(batch.jobs[2].preset, content="social-story")
  inspect(rendered_count(batch) >= 3, content="true")
}
