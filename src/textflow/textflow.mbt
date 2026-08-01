fn latin_words(content : String) -> Array[String] {
  Array::from_iter(content.split(" ")).map(view => view.to_owned())
}

fn wrap_latin(content : String, max_chars : Int) -> Array[String] {
  let lines : Array[String] = []
  let words = latin_words(content)
  let mut current = ""
  words.each(word => {
    if current.is_empty() {
      current = word
    } else if current.char_length() + 1 + word.char_length() <= max_chars {
      current = current + " " + word
    } else {
      lines.push(current)
      current = word
    }
  })
  if !current.is_empty() {
    lines.push(current)
  }
  lines
}

fn wrap_cjk(content : String, max_chars : Int) -> Array[String] {
  let lines : Array[String] = []
  let mut current : Array[Char] = []
  content.to_array().each(char => {
    current.push(char)
    if current.length() >= max_chars {
      lines.push(String::from_array(current))
      current = []
    }
  })
  if !current.is_empty() {
    lines.push(String::from_array(current))
  }
  lines
}

pub fn estimate_chars_per_line(
  max_width : Int,
  style : @scene.TextStyle,
) -> Int {
  let glyph_width = Int::max(style.size / 2, 1)
  Int::max(max_width / glyph_width, 1)
}

pub fn wrap_text(content : String, max_chars~ : Int) -> Array[String] {
  let budget = Int::max(max_chars, 1)
  if content.contains_char(' ') {
    wrap_latin(content, budget)
  } else {
    wrap_cjk(content, budget)
  }
}

pub fn paragraph_to_elements(
  id_prefix~ : String,
  region~ : @scene.Rect,
  content~ : String,
  style~ : @scene.TextStyle,
) -> Array[@scene.Element] {
  let lines = wrap_text(content, max_chars=estimate_chars_per_line(region.width, style))
  let elements : Array[@scene.Element] = []
  let mut current_y = region.y
  lines.eachi((index, line) => {
    elements.push(
      @scene.Element::Text(
        id=id_prefix + "-" + (index + 1).to_string(),
        content=line,
        position=@scene.Point::at(region.x, current_y),
        style=style,
        max_width=region.width,
      ),
    )
    current_y = current_y + style.line_height
  })
  elements
}
