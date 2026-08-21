///|
test "pack statistics summarize jobs and content" {
  let stats = pack_statistics(hackathon_pack())
  inspect(stats.name, content="hackathon-showcase")
  inspect(stats.jobs, content="3")
  inspect(stats.templates.length(), content="3")
  inspect(stats.image_slots, content="3")
  inspect(stats.total_title_characters > 20, content="true")
}

///|
test "catalog queries find reusable packs by output and template" {
  inspect(packs_with_template("digest").length(), content="3")
  inspect(packs_with_preset("social-story").length(), content="10")
  inspect(catalog_job_count(), content="28")
  inspect(catalog_template_count(), content="5")
}
