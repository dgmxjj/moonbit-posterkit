///|
test "catalog_meta summarizes job families and unique names" {
  inspect(list_packs().length() >= 7, content="true")
  let info = match resolve_pack_info("hackathon-showcase") {
    Some(info) => info
    None =>
      { name: "", summary: "", jobs: 0, templates: [], presets: [], themes: [] }
  }
  inspect(info.jobs, content="3")
  inspect(info.templates.join(","), content="launch,editorial,event")
  inspect(info.presets.join(","), content="instagram-square,social-story")
}

///|
test "catalog_meta exposes operational campaign packs" {
  inspect(resolve_pack_info("release-note-pack") is Some(_), content="true")
  inspect(resolve_pack_info("community-digest-pack") is Some(_), content="true")
  inspect(
    resolve_pack_info("event-announcement-pack") is Some(_),
    content="true",
  )
  inspect(
    resolve_pack_info("project-spotlight-pack") is Some(_),
    content="true",
  )
}
