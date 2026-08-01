///|
test "catalog_json serializes repository metadata and template inventory" {
  let json = catalog_json()
  inspect(
    json.contains("\"module_name\": \"dgmxjj/moonbit-posterkit\""),
    content="true",
  )
  inspect(json.contains("\"launch\""), content="true")
  inspect(json.contains("\"hackathon-showcase\""), content="true")
}

///|
test "catalog_markdown renders human-readable reference tables" {
  let markdown = catalog_markdown()
  inspect(markdown.contains("## Templates"), content="true")
  inspect(
    markdown.contains("| launch | instagram-square | warm-editorial |"),
    content="true",
  )
  inspect(
    markdown.contains("| instagram-square | 1080x1080 | 96 | 1:1 |"),
    content="true",
  )
  inspect(
    markdown.contains("| hackathon-showcase | 3 | launch, editorial, event |"),
    content="true",
  )
}
