///|
pub(all) enum CliCommand {
  Batch(input~ : String, output_dir~ : String)
  Render(input~ : String, output_file~ : String)
  Validate(input~ : String)
  ValidateStrict(input~ : String)
  Inspect(input~ : String)
  Benchmark(input~ : String, iterations~ : Int)
  AssetsInspect(input~ : String)
  ExportPng(input~ : String, output_dir~ : String)
  ExportPdf(input~ : String, output_dir~ : String)
  EmitPack(name~ : String, output_file~ : String)
  ListTemplates
  ListPresets
  ListThemes
  ListPacks
  CatalogJson
  CatalogMarkdown
} derive(Debug, Eq)

///|
pub(all) enum CliError {
  Usage
  InvalidCommand(name~ : String)
  Render(error~ : @config.ConfigError)
  IO(path~ : String, message~ : String)
  UnknownPack(name~ : String)
  Asset(error~ : @assets.AssetError)
} derive(Debug, Eq)

///|
pub fn usage() -> String {
  (
    #|Usage:
    #|  posterkit batch <input.json> <output-dir>
    #|  posterkit render <job.json> <output.svg>
    #|  posterkit validate <input.json>
    #|  posterkit validate --strict <input.json>
    #|  posterkit inspect <input.json>
    #|  posterkit benchmark <input.json> [iterations]
    #|  posterkit assets inspect <image>
    #|  posterkit export png <input.json> <output-dir>
    #|  posterkit export pdf <input.json> <output-dir>
    #|  posterkit emit-pack <pack-name> <output.json>
    #|  posterkit list-templates
    #|  posterkit list-presets
    #|  posterkit list-themes
    #|  posterkit list-packs
    #|  posterkit catalog-json
    #|  posterkit catalog-md
    #|
    #|Legacy:
    #|  posterkit <input.json> <output-dir>
    #|
  )
}

///|
pub fn output_path(output_dir : String, slug : String) -> String {
  if output_dir.has_suffix("/") || output_dir.has_suffix("\\") {
    output_dir + slug + ".svg"
  } else {
    output_dir + "/" + slug + ".svg"
  }
}
