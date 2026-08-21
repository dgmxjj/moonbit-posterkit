///|
fn quality_document() -> @scene.PosterDocument {
  @scene.PosterDocument::empty(
    title="Quality",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  ).push(
    @scene.Element::Text(
      id="title",
      content="Quality report",
      position={ x: 80, y: 80 },
      style=@scene.TextStyle::display(@theme.Theme::warm_editorial()),
      max_width=700,
    ),
  )
}

///|
test "document quality audit scores a valid document" {
  let report = audit_document(quality_document())
  inspect(grade_text(report.grade), content="excellent")
  inspect(report.score, content="100")
  inspect(report.errors.length(), content="0")
}

///|
test "svg quality audit distinguishes valid and broken output" {
  let good = audit_svg(@svg.render_svg(quality_document()))
  let bad = audit_svg("<div>broken</div>")
  inspect(grade_text(good.grade), content="excellent")
  inspect(grade_text(bad.grade), content="reject")
  inspect(report_summary(good).contains("score=100"), content="true")
}

///|
test "batch quality audit reports strict configuration issues" {
  let empty : @config.BatchJob = { jobs: [] }
  let report = audit_batch(empty)
  inspect(grade_text(report.grade), content="review")
  inspect(report.errors.length(), content="0")
}
