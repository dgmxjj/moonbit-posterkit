///|
fn byte(value : Int) -> Byte {
  value.to_byte()
}

///|
fn png_header(width : Int, height : Int) -> Array[Byte] {
  [
    byte(137),
    byte(80),
    byte(78),
    byte(71),
    byte(13),
    byte(10),
    byte(26),
    byte(10),
    byte(0),
    byte(0),
    byte(0),
    byte(13),
    byte(73),
    byte(72),
    byte(68),
    byte(82),
    byte(width >> 24),
    byte(width >> 16),
    byte(width >> 8),
    byte(width),
    byte(height >> 24),
    byte(height >> 16),
    byte(height >> 8),
    byte(height),
    byte(8),
    byte(6),
    byte(0),
    byte(0),
    byte(0),
  ]
}

///|
test "assets parse png dimensions" {
  let result = parse_image_info(png_header(640, 480))
  inspect(result is Ok(_), content="true")
}

///|
test "assets reject empty input" {
  inspect(parse_image_info([]) is Err(_), content="true")
}

///|
test "assets reject truncated png signature" {
  inspect(
    parse_image_info([byte(137), byte(80), byte(78)]) is Err(_),
    content="true",
  )
}

///|
test "assets reject zero png dimensions" {
  inspect(parse_image_info(png_header(0, 480)) is Err(_), content="true")
  inspect(parse_image_info(png_header(640, 0)) is Err(_), content="true")
}

///|
test "assets parse jpeg sof dimensions" {
  let jpeg = [
    byte(255),
    byte(216),
    byte(255),
    byte(192),
    byte(0),
    byte(11),
    byte(8),
    byte(1),
    byte(44),
    byte(2),
    byte(128),
    byte(3),
    byte(1),
    byte(17),
    byte(0),
  ]
  match parse_image_info(jpeg) {
    Ok(info) => {
      inspect(info.format is Jpeg, content="true")
      inspect(info.size.width, content="640")
      inspect(info.size.height, content="300")
    }
    Err(_) => inspect(false, content="true")
  }
}

///|
test "assets reject unknown format" {
  inspect(
    parse_image_info([byte(1), byte(2), byte(3)]) is Err(UnsupportedFormat),
    content="true",
  )
}

///|
test "assets fit invalid sizes returns zero" {
  let fit = fit_rect(
    { width: 0, height: 20 },
    { width: 100, height: 100 },
    FitMode::Contain,
  )
  inspect(fit.width, content="0")
  inspect(fit.height, content="0")
}

///|
test "assets fit contain preserves aspect ratio" {
  let fit = fit_rect(
    { width: 1600, height: 900 },
    { width: 400, height: 400 },
    FitMode::Contain,
  )
  inspect(fit.width, content="400")
  inspect(fit.height, content="225")
}

///|
test "assets fit cover fills target" {
  let fit = fit_rect(
    { width: 1600, height: 900 },
    { width: 400, height: 400 },
    FitMode::Cover,
  )
  inspect(fit.width, content="711")
  inspect(fit.height, content="400")
}
