///|
fn hex_digit(value : Byte) -> Int {
  let code = value.to_int()
  if code >= 48 && code <= 57 {
    code - 48
  } else if code >= 65 && code <= 70 {
    code - 55
  } else if code >= 97 && code <= 102 {
    code - 87
  } else {
    0
  }
}

///|
fn hex_byte(value : String) -> Byte {
  if value.length() < 2 {
    png_byte(0)
  } else {
    (hex_digit(value[0].to_byte()) * 16 + hex_digit(value[1].to_byte())).to_byte()
  }
}

///|
fn theme_color(color : @theme.Color) -> Array[Byte] {
  let css = color.as_css()
  if css.length() >= 7 && css[0] == '#' {
    [
      hex_byte(String::unsafe_substring(css, start=1, end=3)),
      hex_byte(String::unsafe_substring(css, start=3, end=5)),
      hex_byte(String::unsafe_substring(css, start=5, end=7)),
      png_byte(255),
    ]
  } else {
    [png_byte(0), png_byte(0), png_byte(0), png_byte(255)]
  }
}

///|
/// Render the supported scene primitives into a valid PNG canvas.
pub fn render_poster_png(document : @scene.PosterDocument) -> Array[Byte] {
  let size = document.preset.canvas
  let initial = match
    PngImage::solid(
      size.width,
      size.height,
      theme_color(document.theme.background),
    ) {
    Ok(image) => image
    Err(_) =>
      match
        PngImage::rgba(1, 1, [
          png_byte(0),
          png_byte(0),
          png_byte(0),
          png_byte(255),
        ]) {
        Ok(image) => image
        Err(_) => abort("unable to create fallback image")
      }
  }
  let image = document.elements.fold(init=initial, fn(image, element) {
    match element {
      @scene.Element::Block(rect~, fill~, ..) =>
        image.fill_rect(
          rect.x,
          rect.y,
          rect.width,
          rect.height,
          theme_color(fill),
        )
      @scene.Element::ImageSlot(rect~, ..) =>
        image.fill_rect(rect.x, rect.y, rect.width, rect.height, [
          png_byte(180),
          png_byte(180),
          png_byte(180),
          png_byte(255),
        ])
      @scene.Element::Text(..) => image
    }
  })
  encode_png(image)
}

///|
/// Render supported scene primitives into a valid single-page PDF.
pub fn render_poster_pdf(document : @scene.PosterDocument) -> String {
  let size = document.preset.canvas
  let base = match PdfDocument::page(size.width, size.height) {
    Ok(document) => document
    Err(_) => abort("unable to create pdf page")
  }
  let document = document.elements.fold(init=base, fn(pdf, element) {
    match element {
      @scene.Element::Block(rect~, ..) =>
        pdf.add_rect(rect.x, rect.y, rect.width, rect.height, "0.5 0.5 0.5")
      @scene.Element::ImageSlot(rect~, ..) =>
        pdf.add_rect(rect.x, rect.y, rect.width, rect.height, "0.7 0.7 0.7")
      @scene.Element::Text(content~, position~, ..) =>
        pdf.add_text(position.x, position.y, content)
    }
  })
  render_pdf(document)
}
