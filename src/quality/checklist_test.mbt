///|
test "quality checklist combines document svg and batch evidence" {
  let document = audit_document(quality_document())
  let svg = audit_svg(@svg.render_svg(quality_document()))
  let batch = audit_batch({ jobs: [] })
  let checklist = combine_reports(document, svg, batch)
  inspect(checklist.overall_score, content="83")
  inspect(grade_text(checklist.overall_grade), content="good")
  inspect(checklist_is_strong(checklist), content="true")
  inspect(checklist_summary(checklist).contains("document=100"), content="true")
}

///|
test "quality checklist aggregates errors and scores" {
  let broken = audit_svg("broken")
  inspect(report_errors([broken]).length(), content="5")
  debug_inspect(report_scores([broken]), content="[0]")
}
