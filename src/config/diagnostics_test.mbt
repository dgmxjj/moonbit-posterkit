///|
test "strict validation reports empty fields in stable order" {
  let content = @template.TemplateContent::{
    eyebrow: "",
    title: "",
    subtitle: "",
    body: "",
    cta: "",
    footer: "",
    image_label: "",
    image_asset_id: "",
  }
  let result = validate_batch_strict({
    jobs: [{ slug: "", template: "", preset: "", theme: "", content }],
  })
  match result {
    Err(issues) => {
      inspect(issues.length(), content="5")
      inspect(issues[0].field, content="slug")
      inspect(issues[0].code, content="empty-slug")
    }
    Ok(_) => inspect(false, content="true")
  }
}
