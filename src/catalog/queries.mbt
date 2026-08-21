///|
pub(all) struct PackStatistics {
  name : String
  jobs : Int
  templates : Array[String]
  presets : Array[String]
  themes : Array[String]
  total_title_characters : Int
  image_slots : Int
} derive(Debug, Eq, ToJson)

///|
fn add_unique(values : Array[String], value : String) -> Array[String] {
  if values.any(item => item == value) {
    values
  } else {
    let result = values.copy()
    result.push(value)
    result
  }
}

///|
pub fn pack_statistics(pack : CampaignPack) -> PackStatistics {
  let templates : Array[String] = []
  let presets : Array[String] = []
  let themes : Array[String] = []
  let mut title_characters = 0
  let mut image_slots = 0
  pack.jobs.each(job => {
    let new_templates = add_unique(templates, job.template)
    let new_presets = add_unique(presets, job.preset)
    let new_themes = add_unique(themes, job.theme)
    templates.clear()
    templates.push_iter(new_templates.iter())
    presets.clear()
    presets.push_iter(new_presets.iter())
    themes.clear()
    themes.push_iter(new_themes.iter())
    title_characters = title_characters + job.content.title.char_length()
    if job.content.image_asset_id.trim().is_empty() == false {
      image_slots = image_slots + 1
    }
  })
  {
    name: pack.name,
    jobs: pack.jobs.length(),
    templates,
    presets,
    themes,
    total_title_characters: title_characters,
    image_slots,
  }
}

///|
pub fn packs_with_template(template : String) -> Array[CampaignPack] {
  all_packs().filter(pack => pack.jobs.any(job => job.template == template))
}

///|
pub fn packs_with_preset(preset : String) -> Array[CampaignPack] {
  all_packs().filter(pack => pack.jobs.any(job => job.preset == preset))
}

///|
pub fn catalog_job_count() -> Int {
  all_packs().fold(init=0, (total, pack) => total + pack.jobs.length())
}

///|
pub fn catalog_template_count() -> Int {
  let names : Array[String] = []
  all_packs().each(pack => {
    pack.jobs.each(job => {
      if names.any(name => name == job.template) == false {
        names.push(job.template)
      }
    })
  })
  names.length()
}
