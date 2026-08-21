///|
pub enum PdfError {
  InvalidPageDimensions
} derive(Debug, Eq)

///|
pub(all) struct PdfDocument {
  width : Int
  height : Int
  commands : Array[String]
} derive(Debug, Eq)

///|
/// Create a single-page PDF document in points.
pub fn PdfDocument::page(
  width : Int,
  height : Int,
) -> Result[PdfDocument, PdfError] {
  if width <= 0 || height <= 0 || width > 14400 || height > 14400 {
    Err(InvalidPageDimensions)
  } else {
    Ok({ width, height, commands: [] })
  }
}

///|
fn pdf_escape(value : String) -> String {
  value
  .replace_all(old="\\", new="\\\\")
  .replace_all(old="(", new="\\(")
  .replace_all(old=")", new="\\)")
}

///|
/// Add a filled rectangle using an RGB color expression such as `1 0 0`.
pub fn PdfDocument::add_rect(
  self : PdfDocument,
  x : Int,
  y : Int,
  width : Int,
  height : Int,
  color : String,
) -> PdfDocument {
  let commands = self.commands.copy()
  commands.push(
    color +
    " rg " +
    x.to_string() +
    " " +
    y.to_string() +
    " " +
    width.to_string() +
    " " +
    height.to_string() +
    " re f",
  )
  { ..self, commands, }
}

///|
/// Add a line using an RGB color expression.
pub fn PdfDocument::add_line(
  self : PdfDocument,
  x1 : Int,
  y1 : Int,
  x2 : Int,
  y2 : Int,
  color : String,
) -> PdfDocument {
  let commands = self.commands.copy()
  commands.push(
    color +
    " RG " +
    x1.to_string() +
    " " +
    y1.to_string() +
    " m " +
    x2.to_string() +
    " " +
    y2.to_string() +
    " l S",
  )
  { ..self, commands, }
}

///|
/// Add a 12-point Helvetica text object.
pub fn PdfDocument::add_text(
  self : PdfDocument,
  x : Int,
  y : Int,
  text : String,
) -> PdfDocument {
  let commands = self.commands.copy()
  commands.push(
    "BT /F1 12 Tf " +
    x.to_string() +
    " " +
    y.to_string() +
    " Td (" +
    pdf_escape(text) +
    ") Tj ET",
  )
  { ..self, commands, }
}

///|
fn write_object(
  builder : StringBuilder,
  offsets : Array[Int],
  id : Int,
  content : String,
) -> Unit {
  offsets.push(builder.to_string().length())
  builder.write_string(id.to_string() + " 0 obj\n")
  builder.write_string(content)
  builder.write_string("\nendobj\n")
}

///|
fn content_stream(document : PdfDocument) -> String {
  let builder = StringBuilder::new()
  document.commands.each(command => {
    builder.write_string(command)
    builder.write_string("\n")
  })
  builder.to_string()
}

///|
/// Render a deterministic single-page PDF with fixed object ordering.
pub fn render_pdf(document : PdfDocument) -> String {
  let builder = StringBuilder::new()
  builder.write_string("%PDF-1.4\n%PosterKit\n")
  let offsets : Array[Int] = [0]
  write_object(builder, offsets, 1, "<< /Type /Catalog /Pages 2 0 R >>")
  write_object(builder, offsets, 2, "<< /Type /Pages /Kids [3 0 R] /Count 1 >>")
  write_object(
    builder,
    offsets,
    3,
    "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 " +
    document.width.to_string() +
    " " +
    document.height.to_string() +
    "] /Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>",
  )
  let stream = content_stream(document)
  write_object(
    builder,
    offsets,
    4,
    "<< /Length " +
    stream.length().to_string() +
    " >>\nstream\n" +
    stream +
    "endstream",
  )
  write_object(
    builder, offsets, 5, "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>",
  )
  let xref_offset = builder.to_string().length()
  builder.write_string("xref\n0 6\n0000000000 65535 f \n")
  for index in 1..<=5 {
    let offset = offsets[index]
    builder.write_string(offset.to_string().pad_start(10, '0') + " 00000 n \n")
  }
  builder.write_string("trailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n")
  builder.write_string(xref_offset.to_string())
  builder.write_string("\n%%EOF\n")
  builder.to_string()
}
