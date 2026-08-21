///|
fn png_byte(value : Int) -> Byte {
  value.to_byte()
}

///|
test "png encodes one rgba pixel" {
  match
    PngImage::rgba(1, 1, [
      png_byte(255),
      png_byte(0),
      png_byte(128),
      png_byte(255),
    ]) {
    Ok(image) => {
      let bytes = encode_png(image)
      inspect(bytes.length() > 40, content="true")
      inspect(bytes[0].to_int(), content="137")
      inspect(bytes[1].to_int(), content="80")
      inspect(bytes[2].to_int(), content="78")
      inspect(bytes[3].to_int(), content="71")
    }
    Err(_) => inspect(false, content="true")
  }
}

///|
test "png rejects pixel length mismatch" {
  inspect(
    PngImage::rgba(2, 1, [png_byte(0), png_byte(0), png_byte(0), png_byte(255)])
    is Err(_),
    content="true",
  )
}

///|
test "png output is deterministic" {
  let pixels = [png_byte(10), png_byte(20), png_byte(30), png_byte(255)]
  match (PngImage::rgba(1, 1, pixels), PngImage::rgba(1, 1, pixels)) {
    (Ok(left), Ok(right)) =>
      inspect(encode_png(left) == encode_png(right), content="true")
    (_, _) => inspect(false, content="true")
  }
}

///|
test "png rejects invalid dimensions" {
  inspect(PngImage::rgba(0, 1, []) is Err(_), content="true")
  inspect(PngImage::rgba(1, 0, []) is Err(_), content="true")
}
