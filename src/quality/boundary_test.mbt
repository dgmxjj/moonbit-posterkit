///|
test "quality rejects empty title" {
  let document = @scene.PosterDocument::empty(
    title="",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  )
  let report = audit_document(document)
  inspect(report.errors[0], content="empty-title")
}

///|
test "quality warns about empty document" {
  let document = @scene.PosterDocument::empty(
    title="Title",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  )
  let report = audit_document(document)
  inspect(report.warnings[0], content="empty-document")
}

///|
test "quality reports duplicate ids" {
  let base = quality_document()
  let duplicate = base.push(
    @scene.Element::Text(
      id="title",
      content="again",
      position={ x: 2, y: 2 },
      style=@scene.TextStyle::body(@theme.Theme::warm_editorial()),
      max_width=100,
    ),
  )
  inspect(audit_document(duplicate).errors[0], content="duplicate-element-id")
}

///|
test "quality reports invalid image slots" {
  let document = @scene.PosterDocument::empty(
    title="Image",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  ).push(
    @scene.Element::ImageSlot(
      id="image",
      asset_id="",
      rect={ x: 0, y: 0, width: 0, height: 0 },
      label="",
      fit=@scene.ImageFit::Cover,
    ),
  )
  let report = audit_document(document)
  inspect(report.errors.length() >= 3, content="true")
}

///|
test "quality accepts empty svg root only when required attributes exist" {
  let good = "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>"
  inspect(grade_text(audit_svg(good).grade), content="excellent")
}

///|
test "quality rejects unclosed svg" {
  let report = audit_svg("<svg viewBox=\"0 0 1 1\">")
  inspect(report.errors.length() > 0, content="true")
}

///|
test "quality handles svg text with ampersands" {
  let svg = "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\">&amp;</svg>"
  inspect(audit_svg(svg).score, content="100")
}

///|
test "quality handles a one-job batch" {
  let content = @template.TemplateContent::{
    eyebrow: "e",
    title: "t",
    subtitle: "s",
    body: "b",
    cta: "c",
    footer: "f",
    image_label: "image",
    image_asset_id: "asset",
  }
  let batch : @config.BatchJob = {
    jobs: [
      {
        slug: "one",
        template: "launch",
        preset: "instagram-square",
        theme: "warm-editorial",
        content,
      },
    ],
  }
  inspect(grade_text(audit_batch(batch).grade), content="excellent")
}

///|
test "quality exposes report json fields" {
  inspect(
    audit_document(quality_document()).to_json().stringify().contains("score"),
    content="true",
  )
}

///|
test "quality grades exact threshold values" {
  inspect(grade_text(grade_for(100)), content="excellent")
  inspect(grade_text(grade_for(90)), content="excellent")
  inspect(grade_text(grade_for(75)), content="good")
  inspect(grade_text(grade_for(50)), content="review")
  inspect(grade_text(grade_for(49)), content="reject")
}

///|
test "quality report errors preserve order" {
  let report = audit_svg("broken")
  inspect(report.errors[0], content="root")
  inspect(report.errors[1], content="viewbox")
  inspect(report.errors[2], content="namespace")
}

///|
test "quality checklist reports all strong reports" {
  let report = audit_svg(
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
  )
  let checklist = combine_reports(report, report, report)
  inspect(checklist_is_strong(checklist), content="true")
  inspect(checklist.overall_score, content="100")
}

///|
test "quality report score is bounded for valid document" {
  let score = audit_document(quality_document()).score
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality report score is bounded for broken svg" {
  let score = audit_svg("broken").score
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality empty batch is reviewable rather than crashing" {
  let report = audit_batch({ jobs: [] })
  inspect(report.checks, content="2")
  inspect(report.passed, content="1")
}

///|
test "quality summaries contain grade and score" {
  let summary = report_summary(audit_document(quality_document()))
  inspect(summary.contains("grade=excellent"), content="true")
  inspect(summary.contains("score=100"), content="true")
}

///|
test "quality error aggregation handles no errors" {
  let report = audit_document(quality_document())
  inspect(report_errors([report]).length(), content="0")
  debug_inspect(report_scores([report]), content="[100]")
}

///|
test "quality svg validator sees balanced tags" {
  let report = audit_svg(
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"><g></g></svg>",
  )
  inspect(report.score, content="100")
}

///|
test "quality report retains warnings independently of errors" {
  let document = @scene.PosterDocument::empty(
    title="Title",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  )
  let report = audit_document(document)
  inspect(report.errors.length(), content="0")
  inspect(report.warnings.length(), content="1")
}

///|
test "quality preserves document ids in render order" {
  let ids = @scene.element_ids(quality_document())
  inspect(ids.length(), content="1")
  inspect(ids[0], content="title")
}

///|
test "quality accepts a valid image slot" {
  let document = quality_document().push(
    @scene.Element::ImageSlot(
      id="hero",
      asset_id="asset",
      rect={ x: 10, y: 10, width: 20, height: 20 },
      label="Hero",
      fit=@scene.ImageFit::Contain,
    ),
  )
  inspect(audit_document(document).errors.length(), content="0")
}

///|
test "quality distinguishes compact and dense output scores" {
  let compact = audit_svg(
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
  )
  let dense = audit_svg("<svg>")
  inspect(compact.score > dense.score, content="true")
}

///|
test "quality report errors are serializable" {
  inspect(
    audit_svg("broken").to_json().stringify().contains("errors"),
    content="true",
  )
}

///|
test "quality checklist keeps individual scores" {
  let document = audit_document(quality_document())
  let svg = audit_svg(@svg.render_svg(quality_document()))
  let batch = audit_batch({ jobs: [] })
  let checklist = combine_reports(document, svg, batch)
  inspect(checklist.document.score, content="100")
  inspect(checklist.svg.score, content="100")
  inspect(checklist.batch.score, content="50")
}

///|
test "quality error collection flattens multiple reports" {
  let broken = audit_svg("broken")
  let errors = report_errors([broken, broken])
  inspect(errors.length(), content="10")
}

///|
test "quality report scores retain input order" {
  let good = audit_svg(
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
  )
  let broken = audit_svg("broken")
  debug_inspect(report_scores([good, broken]), content="[100, 0]")
}

///|
test "quality grade text is lowercase and stable" {
  inspect(grade_text(QualityGrade::Excellent), content="excellent")
  inspect(grade_text(QualityGrade::Good), content="good")
  inspect(grade_text(QualityGrade::Review), content="review")
  inspect(grade_text(QualityGrade::Reject), content="reject")
}

///|
test "quality empty svg errors include all structural checks" {
  let errors = audit_svg("").errors
  inspect(errors.length(), content="5")
}

///|
test "quality valid report has no warning strings" {
  inspect(
    audit_svg(
      "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
    ).warnings.length(),
    content="0",
  )
}

///|
test "quality handles svg self closing child tags" {
  let svg = "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"><rect /></svg>"
  inspect(grade_text(audit_svg(svg).grade), content="excellent")
}

///|
test "quality checklist score is an integer average" {
  let report = audit_svg(
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
  )
  let checklist = combine_reports(report, report, audit_batch({ jobs: [] }))
  inspect(checklist.overall_score, content="83")
}

///|
test "quality detects text outside a poster canvas" {
  let document = @scene.PosterDocument::empty(
    title="Outside",
    preset=@preset.PosterPreset::instagram_square(),
    theme=@theme.Theme::warm_editorial(),
  ).push(
    @scene.Element::Text(
      id="outside",
      content="x",
      position={ x: 2000, y: 2000 },
      style=@scene.TextStyle::body(@theme.Theme::warm_editorial()),
      max_width=100,
    ),
  )
  inspect(audit_document(document).errors[0], content="text-outside-canvas")
}

///|
test "quality document report uses all three structural checks" {
  let report = audit_document(quality_document())
  inspect(report.checks, content="3")
  inspect(report.passed, content="3")
}

///|
test "quality broken reports are never marked strong" {
  let report = audit_svg("<svg>")
  let checklist = combine_reports(report, report, report)
  inspect(checklist_is_strong(checklist), content="false")
}

///|
test "quality rejects an empty svg string" {
  inspect(grade_text(audit_svg("").grade), content="reject")
}

///|
test "quality keeps report check counts positive" {
  inspect(audit_svg("broken").checks, content="5")
  inspect(audit_document(quality_document()).checks, content="3")
}

///|
test "quality checklist summary includes every component" {
  let report = audit_svg("<svg>")
  let summary = checklist_summary(combine_reports(report, report, report))
  inspect(summary.contains("document="), content="true")
  inspect(summary.contains("svg="), content="true")
  inspect(summary.contains("batch="), content="true")
}

///|
test "quality report keeps zero warnings for valid svg" {
  let report = audit_svg(
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
  )
  inspect(report.warnings.is_empty(), content="true")
}

///|
test "quality report keeps errors for invalid svg" {
  inspect(audit_svg("broken").errors.is_empty(), content="false")
}

///|
test "quality document report has a stable excellent score" {
  inspect(audit_document(quality_document()).score, content="100")
}

///|
test "quality batch report has a stable review score for empty input" {
  inspect(audit_batch({ jobs: [] }).score, content="50")
}

///|
test "quality report score never exceeds one hundred" {
  inspect(audit_svg("broken").score <= 100, content="true")
}

///|
test "quality report score never falls below zero" {
  inspect(audit_svg("broken").score >= 0, content="true")
}

///|
test "quality report error count is deterministic" {
  inspect(audit_svg("broken").errors.length(), content="5")
}

///|
test "quality report valid svg has five passed checks" {
  let report = audit_svg(
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>",
  )
  inspect(report.passed, content="5")
}

///|
test "quality report broken svg has zero passed checks" {
  inspect(audit_svg("broken").passed, content="0")
}

///|
test "quality report exposes review threshold behavior" {
  inspect(grade_text(grade_for(74)), content="review")
}

///|
test "quality report exposes good threshold behavior" {
  inspect(grade_text(grade_for(75)), content="good")
}

///|
test "quality report exposes excellent threshold behavior" {
  inspect(grade_text(grade_for(90)), content="excellent")
}

///|
test "quality report exposes reject threshold behavior" {
  inspect(grade_text(grade_for(0)), content="reject")
}

///|
test "quality report grade strings are non-empty" {
  inspect(!grade_text(grade_for(50)).is_empty(), content="true")
}
