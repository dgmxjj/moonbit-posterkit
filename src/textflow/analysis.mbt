///|
pub(all) struct ParagraphProfile {
  paragraphs : Int
  lines : Int
  characters : Int
  words : Int
  has_cjk : Bool
  has_explicit_breaks : Bool
} derive(Debug, Eq)

///|
pub fn profile_paragraph(content : String) -> ParagraphProfile {
  let lines = split_lines(content)
  let mut words = 0
  lines.each(line => {
    line
    .split(" ")
    .each(view => if !view.to_owned().trim().is_empty() { words = words + 1 })
  })
  let has_cjk = content.to_array().any(char => char.to_int() > 0x3000)
  {
    paragraphs: lines.filter(line => !line.trim().is_empty()).length(),
    lines: lines.length(),
    characters: content.char_length(),
    words,
    has_cjk,
    has_explicit_breaks: lines.length() > 1,
  }
}

///|
pub fn profile_summary(profile : ParagraphProfile) -> String {
  let cjk = if profile.has_cjk { "yes" } else { "no" }
  "paragraphs=" +
  profile.paragraphs.to_string() +
  ",lines=" +
  profile.lines.to_string() +
  ",characters=" +
  profile.characters.to_string() +
  ",words=" +
  profile.words.to_string() +
  ",cjk=" +
  cjk
}

///|
pub fn text_fits_lines(
  content : String,
  style : @scene.TextStyle,
  width : Int,
  lines : Int,
) -> Bool {
  !measure_text(content, style, max_width=width, max_lines=lines).truncated
}

///|
pub fn line_height_for(style : @scene.TextStyle, line_count : Int) -> Int {
  Int::max(style.line_height, 1) * Int::max(line_count, 0)
}
