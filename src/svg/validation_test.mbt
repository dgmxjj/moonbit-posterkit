///|
test "svg validation accepts renderer output" {
  let document = @scene.PosterDocument::empty(
    title="validation",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  )
  let (svg, validation) = render_and_validate(document)
  inspect(svg.contains("<svg"), content="true")
  inspect(validation.valid, content="true")
  inspect(svg_validation_summary(validation), content="valid-svg")
}

///|
test "svg validation reports missing structural pieces" {
  let validation = validate_svg("<div>broken</div>")
  inspect(validation.has_root, content="false")
  inspect(
    svg_validation_summary(validation).contains("missing-root"),
    content="true",
  )
}
