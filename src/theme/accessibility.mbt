///|
pub(all) enum ContrastRating {
  Fail
  LargeText
  Pass
} derive(Debug, Eq)

///|
pub(all) struct ContrastReport {
  foreground : String
  background : String
  ratio : Int
  rating : ContrastRating
} derive(Debug, Eq)

///|
fn hex_digit(value : Char) -> Int {
  match value {
    '0'..='9' => value.to_int() - '0'.to_int()
    'a'..='f' => value.to_int() - 'a'.to_int() + 10
    'A'..='F' => value.to_int() - 'A'.to_int() + 10
    _ => 0
  }
}

///|
fn channel(css : String, index : Int) -> Int {
  if css.char_length() < index + 2 {
    0
  } else {
    match (css.get_char(index), css.get_char(index + 1)) {
      (Some(first), Some(second)) => hex_digit(first) * 16 + hex_digit(second)
      _ => 0
    }
  }
}

///|
fn luminance(color : Color) -> Int {
  let offset = if color.css.has_prefix("#") { 1 } else { 0 }
  let red = channel(color.css, offset)
  let green = channel(color.css, offset + 2)
  let blue = channel(color.css, offset + 4)
  (red * 299 + green * 587 + blue * 114) / 1000
}

///|
pub fn contrast_ratio(foreground : Color, background : Color) -> Int {
  let first = luminance(foreground) + 5
  let second = luminance(background) + 5
  if first >= second {
    first * 100 / second
  } else {
    second * 100 / first
  }
}

///|
pub fn contrast_report(
  foreground : Color,
  background : Color,
) -> ContrastReport {
  let ratio = contrast_ratio(foreground, background)
  {
    foreground: foreground.css,
    background: background.css,
    ratio,
    rating: if ratio >= 700 {
      Pass
    } else if ratio >= 450 {
      LargeText
    } else {
      Fail
    },
  }
}

///|
pub fn Theme::body_contrast(self : Theme) -> ContrastReport {
  contrast_report(self.foreground, self.background)
}

///|
pub fn Theme::accent_contrast(self : Theme) -> ContrastReport {
  contrast_report(self.accent, self.background)
}

///|
pub fn contrast_rating_text(rating : ContrastRating) -> String {
  match rating {
    Fail => "fail"
    LargeText => "large-text"
    Pass => "pass"
  }
}
