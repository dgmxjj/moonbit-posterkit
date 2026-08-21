///|
pub(all) struct SvgValidation {
  has_root : Bool
  has_view_box : Bool
  has_namespace : Bool
  closing_root : Bool
  balanced_tags : Bool
  valid : Bool
} derive(Debug, Eq)

///|
fn count_occurrences(value : String, needle : String) -> Int {
  if needle.is_empty() {
    0
  } else {
    let mut count = 0
    value.split(needle).each(_ => count = count + 1)
    Int::max(count - 1, 0)
  }
}

///|
pub fn validate_svg(svg : String) -> SvgValidation {
  let has_root = svg.has_prefix("<svg")
  let has_view_box = svg.contains("viewBox=\"")
  let has_namespace = svg.contains("xmlns=\"http://www.w3.org/2000/svg\"")
  let closing_root = svg.has_suffix("</svg>")
  let open_tags = count_occurrences(svg, "<")
  let close_tags = count_occurrences(svg, ">")
  let balanced_tags = open_tags == close_tags && open_tags > 0
  {
    has_root,
    has_view_box,
    has_namespace,
    closing_root,
    balanced_tags,
    valid: has_root &&
    has_view_box &&
    has_namespace &&
    closing_root &&
    balanced_tags,
  }
}

///|
pub fn svg_validation_summary(validation : SvgValidation) -> String {
  if validation.valid {
    "valid-svg"
  } else {
    let parts : Array[String] = []
    if !validation.has_root {
      parts.push("missing-root")
    }
    if !validation.has_view_box {
      parts.push("missing-viewbox")
    }
    if !validation.has_namespace {
      parts.push("missing-namespace")
    }
    if !validation.closing_root {
      parts.push("missing-close")
    }
    if !validation.balanced_tags {
      parts.push("unbalanced-tags")
    }
    parts.join(",")
  }
}

///|
pub fn render_and_validate(
  document : @scene.PosterDocument,
) -> (String, SvgValidation) {
  let svg = render_svg(document)
  (svg, validate_svg(svg))
}
