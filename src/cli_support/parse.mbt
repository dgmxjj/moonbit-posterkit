///|
fn looks_like_batch_invocation(args : Array[String]) -> Bool {
  args.length() == 3 && args[1].has_suffix(".json")
}

///|
pub fn parse_command(args : Array[String]) -> Result[CliCommand, CliError] {
  if args.length() <= 1 {
    Err(CliError::Usage)
  } else if looks_like_batch_invocation(args) {
    Ok(CliCommand::Batch(input=args[1], output_dir=args[2]))
  } else {
    match args[1] {
      "batch" =>
        if args.length() == 4 {
          Ok(CliCommand::Batch(input=args[2], output_dir=args[3]))
        } else {
          Err(CliError::Usage)
        }
      "render" =>
        if args.length() == 4 {
          Ok(CliCommand::Render(input=args[2], output_file=args[3]))
        } else {
          Err(CliError::Usage)
        }
      "validate" =>
        if args.length() == 3 {
          Ok(CliCommand::Validate(input=args[2]))
        } else {
          Err(CliError::Usage)
        }
      "emit-pack" =>
        if args.length() == 4 {
          Ok(CliCommand::EmitPack(name=args[2], output_file=args[3]))
        } else {
          Err(CliError::Usage)
        }
      "list-templates" =>
        if args.length() == 2 {
          Ok(CliCommand::ListTemplates)
        } else {
          Err(CliError::Usage)
        }
      "list-presets" =>
        if args.length() == 2 {
          Ok(CliCommand::ListPresets)
        } else {
          Err(CliError::Usage)
        }
      "list-themes" =>
        if args.length() == 2 {
          Ok(CliCommand::ListThemes)
        } else {
          Err(CliError::Usage)
        }
      "list-packs" =>
        if args.length() == 2 {
          Ok(CliCommand::ListPacks)
        } else {
          Err(CliError::Usage)
        }
      "catalog-json" =>
        if args.length() == 2 {
          Ok(CliCommand::CatalogJson)
        } else {
          Err(CliError::Usage)
        }
      "catalog-md" =>
        if args.length() == 2 {
          Ok(CliCommand::CatalogMarkdown)
        } else {
          Err(CliError::Usage)
        }
      "help" => Err(CliError::Usage)
      other => Err(CliError::InvalidCommand(name=other))
    }
  }
}
