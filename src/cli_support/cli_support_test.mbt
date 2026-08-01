///|
fn command_text(result : Result[CliCommand, CliError]) -> String {
  match result {
    Ok(CliCommand::Batch(input~, output_dir~)) => input + "|" + output_dir
    Ok(CliCommand::Render(input~, output_file~)) => input + "|" + output_file
    Ok(CliCommand::Validate(input~)) => input
    Ok(CliCommand::EmitPack(name~, output_file~)) => name + "|" + output_file
    Ok(CliCommand::ListTemplates) => "list-templates"
    Ok(CliCommand::ListPresets) => "list-presets"
    Ok(CliCommand::ListThemes) => "list-themes"
    Ok(CliCommand::ListPacks) => "list-packs"
    Ok(CliCommand::CatalogJson) => "catalog-json"
    Ok(CliCommand::CatalogMarkdown) => "catalog-md"
    Err(Usage) => "usage"
    Err(InvalidCommand(name~)) => "invalid:" + name
    Err(Render(error=_)) => "render"
    Err(IO(path=_, message=_)) => "io"
    Err(UnknownPack(name=_)) => "pack"
  }
}

///|
test "parse_command preserves legacy batch invocation" {
  inspect(
    command_text(parse_command(["posterkit", "examples/posters.json", "dist"])),
    content="examples/posters.json|dist",
  )
}

///|
test "parse_command supports subcommands for render and emit-pack" {
  inspect(
    command_text(parse_command(["posterkit", "render", "job.json", "out.svg"])),
    content="job.json|out.svg",
  )
  inspect(
    command_text(
      parse_command(["posterkit", "emit-pack", "hackathon-showcase", "out.json"]),
    ),
    content="hackathon-showcase|out.json",
  )
}

///|
test "parse_command recognizes list and catalog commands" {
  inspect(
    command_text(parse_command(["posterkit", "list-templates"])),
    content="list-templates",
  )
  inspect(
    command_text(parse_command(["posterkit", "list-presets"])),
    content="list-presets",
  )
  inspect(
    command_text(parse_command(["posterkit", "catalog-md"])),
    content="catalog-md",
  )
}

///|
test "parse_command rejects incomplete or unknown invocations" {
  inspect(command_text(parse_command(["posterkit"])), content="usage")
  inspect(
    command_text(parse_command(["posterkit", "mystery"])),
    content="invalid:mystery",
  )
}

///|
test "output_path appends svg filename under target directory" {
  inspect(
    output_path("dist", "launch-square"),
    content="dist/launch-square.svg",
  )
  inspect(output_path("dist\\", "story"), content="dist\\story.svg")
}

///|
test "listing helpers surface stable registry summaries" {
  inspect(
    template_listing_output().contains("launch | preset:"),
    content="true",
  )
  inspect(
    preset_listing_output().contains("youtube-thumbnail | 1280x720"),
    content="true",
  )
  inspect(
    theme_listing_output().contains("warm-editorial | accent"),
    content="true",
  )
  inspect(
    pack_listing_output().contains("hackathon-showcase | jobs 3"),
    content="true",
  )
}

///|
test "emit_pack_json returns reusable built-in batch configuration" {
  inspect(
    match emit_pack_json("hackathon-showcase") {
      Ok(content) => content.contains("\"launch-square\"")
      Err(_) => false
    },
    content="true",
  )
  inspect(
    match emit_pack_json("missing-pack") {
      Ok(_) => false
      Err(UnknownPack(name~)) => name == "missing-pack"
      Err(_) => false
    },
    content="true",
  )
}

///|
test "validation and catalog formatters expose machine and human views" {
  let summary : @config.ValidationSummary = {
    total_jobs: 2,
    slugs: ["launch-square", "event-story"],
    templates: ["launch", "event"],
    presets: ["instagram-square", "social-story"],
    themes: ["warm-editorial", "swiss-grid"],
  }
  inspect(
    validation_output(summary).contains("Valid batch: 2 job(s)"),
    content="true",
  )
  inspect(
    catalog_json_output().contains(
      "\"module_name\": \"dgmxjj/moonbit-posterkit\"",
    ),
    content="true",
  )
  inspect(catalog_markdown_output().contains("## Packs"), content="true")
}

///|
test "usage string documents the expanded invocation contract" {
  inspect(usage().contains("posterkit batch"), content="true")
  inspect(usage().contains("list-presets"), content="true")
  inspect(usage().contains("emit-pack"), content="true")
}
