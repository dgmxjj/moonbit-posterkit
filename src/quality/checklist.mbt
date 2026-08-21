///|
pub(all) struct QualityChecklist {
  document : QualityReport
  svg : QualityReport
  batch : QualityReport
  overall_score : Int
  overall_grade : QualityGrade
} derive(Debug, Eq, ToJson)

///|
pub fn combine_reports(
  document : QualityReport,
  svg : QualityReport,
  batch : QualityReport,
) -> QualityChecklist {
  let score = (document.score + svg.score + batch.score) / 3
  {
    document,
    svg,
    batch,
    overall_score: score,
    overall_grade: grade_for(score),
  }
}

///|
pub fn checklist_is_strong(checklist : QualityChecklist) -> Bool {
  checklist.overall_score >= 75 &&
  checklist.document.errors.is_empty() &&
  checklist.svg.errors.is_empty() &&
  checklist.batch.errors.is_empty()
}

///|
pub fn checklist_summary(checklist : QualityChecklist) -> String {
  "overall=" +
  grade_text(checklist.overall_grade) +
  ",score=" +
  checklist.overall_score.to_string() +
  ",document=" +
  checklist.document.score.to_string() +
  ",svg=" +
  checklist.svg.score.to_string() +
  ",batch=" +
  checklist.batch.score.to_string()
}

///|
pub fn report_errors(reports : Array[QualityReport]) -> Array[String] {
  let errors : Array[String] = []
  reports.each(report => report.errors.each(error => errors.push(error)))
  errors
}

///|
pub fn report_scores(reports : Array[QualityReport]) -> Array[Int] {
  reports.map(report => report.score)
}
