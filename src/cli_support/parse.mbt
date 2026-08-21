///|
fn looks_like_batch_invocation(args : Array[String]) -> Bool {
  args.length() == 3 && args[1].has_suffix(".json")
}

///|
fn parse_digits(chars : Array[Char], index : Int, value : Int) -> Int? {
  if index >= chars.length() {
    Some(value)
  } else {
    match chars[index] {
      '0'..='9' =>
        parse_digits(
          chars,
          index + 1,
          value * 10 + chars[index].to_int() - '0'.to_int(),
        )
      _ => None
    }
  }
}

///|
fn parse_positive_int(raw : String) -> Int? {
  match parse_digits(raw.to_array(), 0, 0) {
    Some(value) if value > 0 => Some(value)
    _ => None
  }
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
        if args.length() == 4 && args[2] == "--strict" {
          Ok(CliCommand::ValidateStrict(input=args[3]))
        } else if args.length() == 3 {
          Ok(CliCommand::Validate(input=args[2]))
        } else {
          Err(CliError::Usage)
        }
      "inspect" =>
        if args.length() == 3 {
          Ok(CliCommand::Inspect(input=args[2]))
        } else {
          Err(CliError::Usage)
        }
      "benchmark" =>
        if args.length() == 3 {
          Ok(CliCommand::Benchmark(input=args[2], iterations=1))
        } else if args.length() == 4 {
          match parse_positive_int(args[3]) {
            Some(iterations) if iterations > 0 =>
              Ok(CliCommand::Benchmark(input=args[2], iterations~))
            _ => Err(CliError::Usage)
          }
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
