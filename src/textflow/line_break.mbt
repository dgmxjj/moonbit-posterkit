///|
pub(all) struct TextMeasure {
  lines : Array[String]
  width : Int
  height : Int
  truncated : Bool
} derive(Debug, Eq)

///|
pub fn split_lines(content : String) -> Array[String] {
  let lines : Array[String] = []
  content.split("\n").each(view => lines.push(view.to_owned()))
  lines
}

///|
fn hard_limit(content : String, limit : Int) -> String {
  if limit <= 0 {
    ""
  } else if content.char_length() <= limit {
    content
  } else {
    let chars = content.to_array()
    let result : Array[Char] = []
    let count = Int::min(limit, chars.length())
    for i = 0; i < count; i = i + 1 {
      result.push(chars[i])
    }
    String::from_array(result)
  }
}

///|
pub fn truncate_text(
  content : String,
  max_chars~ : Int,
  ellipsis~ : String,
) -> String {
  let budget = Int::max(max_chars, 0)
  if content.char_length() <= budget {
    content
  } else if ellipsis.char_length() >= budget {
    hard_limit(ellipsis, budget)
  } else {
    hard_limit(content, budget - ellipsis.char_length()) + ellipsis
  }
}

///|
pub fn measure_text(
  content : String,
  style : @scene.TextStyle,
  max_width~ : Int,
  max_lines~ : Int,
) -> TextMeasure {
  let width = Int::max(max_width, 1)
  let chars_per_line = estimate_chars_per_line(width, style)
  let raw_lines : Array[String] = []
  split_lines(content).each(line => {
    wrap_text(line, max_chars=chars_per_line).each(wrapped => {
      raw_lines.push(wrapped)
    })
  })
  let lines_limit = Int::max(max_lines, 1)
  let truncated = raw_lines.length() > lines_limit
  let lines : Array[String] = []
  let count = Int::min(raw_lines.length(), lines_limit)
  for i = 0; i < count; i = i + 1 {
    let line = raw_lines[i]
    lines.push(
      if line.char_length() > chars_per_line {
        truncate_text(line, max_chars=chars_per_line, ellipsis="…")
      } else {
        line
      },
    )
  }
  let measured_width = lines.fold(init=0, (max_width, line) => {
    Int::max(max_width, line.char_length() * Int::max(style.size / 2, 1))
  })
  {
    lines,
    width: Int::min(measured_width, width),
    height: lines.length() * Int::max(style.line_height, 1),
    truncated,
  }
}
