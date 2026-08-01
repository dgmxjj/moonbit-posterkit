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
fn summarize_pack(pack : @catalog.CampaignPack) -> PackInfo {
  let templates = []
  let presets = []
  let themes = []
  for job in pack.jobs {
    push_unique(templates, job.template)
    push_unique(presets, job.preset)
    push_unique(themes, job.theme)
  }
  {
    name: pack.name,
    summary: pack.description,
    jobs: pack.jobs.length(),
    templates,
    presets,
    themes,
  }
}

///|
pub fn list_packs() -> Array[PackInfo] {
  @catalog.all_packs().map(summarize_pack)
}

///|
fn find_pack(
  packs : Array[@catalog.CampaignPack],
  name : String,
  index : Int,
) -> @catalog.CampaignPack? {
  if index >= packs.length() {
    None
  } else if packs[index].name == name {
    Some(packs[index])
  } else {
    find_pack(packs, name, index + 1)
  }
}

///|
fn find_pack_info(
  packs : Array[PackInfo],
  name : String,
  index : Int,
) -> PackInfo? {
  if index >= packs.length() {
    None
  } else if packs[index].name == name {
    Some(packs[index])
  } else {
    find_pack_info(packs, name, index + 1)
  }
}

///|
pub fn pack_names() -> Array[String] {
  [
    for pack in @catalog.all_packs() => pack.name
  ]
}

///|
pub fn resolve_pack(name : String) -> @catalog.CampaignPack? {
  find_pack(@catalog.all_packs(), name, 0)
}

///|
pub fn resolve_pack_info(name : String) -> PackInfo? {
  find_pack_info(list_packs(), name, 0)
}
