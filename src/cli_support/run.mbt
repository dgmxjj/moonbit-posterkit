///|
fn exit_code(error : CliError) -> Int {
  match error {
    Usage => 2
    InvalidCommand(name=_) => 2
    Render(error=_) => 1
    IO(path=_, message=_) => 1
    UnknownPack(name=_) => 1
  }
}

///|
fn print_error(error : CliError) -> Unit {
  match error {
    Usage => println(usage())
    InvalidCommand(name~) => {
      println("Unknown command: \{name}")
      println(usage())
    }
    Render(error=InvalidJson(message~)) =>
      println("Render error: invalid json (\{message})")
    Render(error=UnknownPreset(name~)) =>
      println("Render error: unknown preset \{name}")
    Render(error=UnknownTheme(name~)) =>
      println("Render error: unknown theme \{name}")
    Render(error=UnknownTemplate(name~)) =>
      println("Render error: unknown template \{name}")
    Render(error=DuplicateSlug(name~)) =>
      println("Render error: duplicate slug \{name}")
    IO(path~, message~) => println("I/O error at \{path}: \{message}")
    UnknownPack(name~) => println("Unknown built-in pack: \{name}")
  }
}

///|
fn run_validate(input : String) -> Int {
  match read_batch(input) {
    Err(error) => {
      print_error(error)
      exit_code(error)
    }
    Ok(batch) =>
      match @config.validate_batch(batch) {
        Err(error) => {
          print_error(Render(error~))
          1
        }
        Ok(summary) => {
          println(validation_output(summary))
          0
        }
      }
  }
}

///|
fn run_validate_strict(input : String) -> Int {
  match read_batch(input) {
    Err(error) => {
      print_error(error)
      exit_code(error)
    }
    Ok(batch) =>
      match @config.validate_batch_strict(batch) {
        Ok(summary) => {
          println(validation_output(summary))
          0
        }
        Err(issues) => {
          println("Strict validation failed:")
          println(@config.validation_issues_text(issues))
          1
        }
      }
  }
}

///|
fn run_inspect(input : String) -> Int {
  match read_batch(input) {
    Err(error) => {
      print_error(error)
      exit_code(error)
    }
    Ok(batch) =>
      match @config.validate_batch(batch) {
        Err(error) => {
          print_error(Render(error~))
          1
        }
        Ok(summary) => {
          println(validation_output(summary))
          println("Inspection jobs: {batch.jobs.length()}")
          0
        }
      }
  }
}

///|
fn run_benchmark(input : String, iterations : Int) -> Int {
  match read_batch(input) {
    Err(error) => {
      print_error(error)
      exit_code(error)
    }
    Ok(batch) =>
      match @config.render_batch_with_metrics(batch) {
        Err(error) => {
          print_error(Render(error~))
          1
        }
        Ok((posters, metrics)) => {
          let mut measured_bytes = 0
          for i = 0; i < iterations; i = i + 1 {
            posters.each(poster => {
              measured_bytes = measured_bytes + poster.svg.length()
            })
          }
          println("Benchmark iterations: {iterations}")
          println("Jobs: " + metrics.total.to_string())
          println("Successful renders: " + metrics.succeeded.to_string())
          println(
            "SVG bytes per iteration: " + metrics.total_svg_bytes.to_string(),
          )
          println("Measured bytes: {measured_bytes}")
          0
        }
      }
  }
}

///|
fn run_batch(input : String, output_dir : String) -> Int {
  match ensure_output_dir(output_dir) {
    Some(error) => {
      print_error(error)
      exit_code(error)
    }
    None =>
      match read_batch(input) {
        Err(error) => {
          print_error(error)
          exit_code(error)
        }
        Ok(batch) =>
          match @config.render_batch(batch) {
            Err(error) => {
              print_error(Render(error~))
              1
            }
            Ok(posters) =>
              match write_posters(posters, output_dir, 0) {
                Some(error) => {
                  print_error(error)
                  exit_code(error)
                }
                None => {
                  println(
                    "Generated \{posters.length()} poster(s) in \{output_dir}",
                  )
                  0
                }
              }
          }
      }
  }
}

///|
fn run_render(input : String, output_file : String) -> Int {
  match read_job(input) {
    Err(error) => {
      print_error(error)
      exit_code(error)
    }
    Ok(job) =>
      match @config.render_job(job) {
        Err(error) => {
          print_error(Render(error~))
          1
        }
        Ok(poster) =>
          match write_text(output_file, poster.svg) {
            Some(error) => {
              print_error(error)
              exit_code(error)
            }
            None => {
              println("Generated \{poster.slug} -> \{output_file}")
              0
            }
          }
      }
  }
}

///|
fn run_emit_pack(name : String, output_file : String) -> Int {
  match emit_pack_json(name) {
    Err(error) => {
      print_error(error)
      exit_code(error)
    }
    Ok(content) =>
      match write_text(output_file, content) {
        Some(error) => {
          print_error(error)
          exit_code(error)
        }
        None => {
          println("Wrote built-in pack \{name} -> \{output_file}")
          0
        }
      }
  }
}

///|
pub fn run_cli(args : Array[String]) -> Int {
  match parse_command(args) {
    Err(error) => {
      print_error(error)
      exit_code(error)
    }
    Ok(command) =>
      match command {
        CliCommand::Batch(input~, output_dir~) => run_batch(input, output_dir)
        CliCommand::Render(input~, output_file~) =>
          run_render(input, output_file)
        CliCommand::Validate(input~) => run_validate(input)
        CliCommand::ValidateStrict(input~) => run_validate_strict(input)
        CliCommand::Inspect(input~) => run_inspect(input)
        CliCommand::Benchmark(input~, iterations~) =>
          run_benchmark(input, iterations)
        CliCommand::EmitPack(name~, output_file~) =>
          run_emit_pack(name, output_file)
        CliCommand::ListTemplates => {
          println(template_listing_output())
          0
        }
        CliCommand::ListPresets => {
          println(preset_listing_output())
          0
        }
        CliCommand::ListThemes => {
          println(theme_listing_output())
          0
        }
        CliCommand::ListPacks => {
          println(pack_listing_output())
          0
        }
        CliCommand::CatalogJson => {
          println(catalog_json_output())
          0
        }
        CliCommand::CatalogMarkdown => {
          println(catalog_markdown_output())
          0
        }
      }
  }
}
