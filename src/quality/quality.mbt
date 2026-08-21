///|
pub(all) enum QualityGrade {
  Excellent
  Good
  Review
  Reject
} derive(Debug, Eq, ToJson)

///|
pub(all) struct QualityReport {
  grade : QualityGrade
  score : Int
  checks : Int
  passed : Int
  warnings : Array[String]
  errors : Array[String]
} derive(Debug, Eq, ToJson)

///|
pub fn grade_for(score : Int) -> QualityGrade {
  if score >= 90 {
    Excellent
  } else if score >= 75 {
    Good
  } else if score >= 50 {
    Review
  } else {
    Reject
  }
}

///|
pub fn audit_document(document : @scene.PosterDocument) -> QualityReport {
  let diagnostics = @scene.validate_document(document, strict=true)
  let checks = 3
  let mut passed = 0
  let warnings : Array[String] = []
  let errors : Array[String] = []
  if document.title.trim().is_empty() {
    errors.push("empty-title")
  } else {
    passed = passed + 1
  }
  if document.elements.length() > 0 {
    passed = passed + 1
  } else {
    warnings.push("empty-document")
  }
  if diagnostics.is_empty() {
    passed = passed + 1
  } else {
    diagnostics.each(item => errors.push(@scene.diagnostic_code(item)))
  }
  let score = passed * 100 / checks
  { grade: grade_for(score), score, checks, passed, warnings, errors }
}

///|
pub fn audit_svg(svg : String) -> QualityReport {
  let validation = @svg.validate_svg(svg)
  let checks = 5
  let mut passed = 0
  let errors : Array[String] = []
  if validation.has_root {
    passed = passed + 1
  } else {
    errors.push("root")
  }
  if validation.has_view_box {
    passed = passed + 1
  } else {
    errors.push("viewbox")
  }
  if validation.has_namespace {
    passed = passed + 1
  } else {
    errors.push("namespace")
  }
  if validation.closing_root {
    passed = passed + 1
  } else {
    errors.push("closing-root")
  }
  if validation.balanced_tags {
    passed = passed + 1
  } else {
    errors.push("tags")
  }
  let score = passed * 100 / checks
  { grade: grade_for(score), score, checks, passed, warnings: [], errors }
}

///|
pub fn audit_batch(batch : @config.BatchJob) -> QualityReport {
  match @config.validate_batch_strict(batch) {
    Ok(summary) => {
      let checks = 2
      let passed = if summary.total_jobs > 0 { 2 } else { 1 }
      let score = passed * 100 / checks
      {
        grade: grade_for(score),
        score,
        checks,
        passed,
        warnings: [],
        errors: [],
      }
    }
    Err(issues) => {
      let errors = issues.map(issue => issue.code)
      { grade: Reject, score: 0, checks: 2, passed: 0, warnings: [], errors }
    }
  }
}

///|
pub fn grade_text(grade : QualityGrade) -> String {
  match grade {
    Excellent => "excellent"
    Good => "good"
    Review => "review"
    Reject => "reject"
  }
}

///|
pub fn report_summary(report : QualityReport) -> String {
  "grade=" +
  grade_text(report.grade) +
  ",score=" +
  report.score.to_string() +
  ",checks=" +
  report.checks.to_string() +
  ",passed=" +
  report.passed.to_string() +
  ",errors=" +
  report.errors.join("|")
}
