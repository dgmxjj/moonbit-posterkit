///|
test "pdf renders valid header and trailer" {
  match PdfDocument::page(320, 180) {
    Ok(document) => {
      let pdf = render_pdf(document)
      inspect(pdf.has_prefix("%PDF-1.4"), content="true")
      inspect(pdf.has_suffix("%%EOF\n"), content="true")
      inspect(pdf.contains("xref"), content="true")
    }
    Err(_) => inspect(false, content="true")
  }
}

///|
test "pdf includes rectangle and escaped text" {
  match PdfDocument::page(320, 180) {
    Ok(document) => {
      let document = document.add_rect(10, 20, 100, 50, "1 0 0")
      let document = document.add_text(20, 40, "Hello (MoonBit)")
      let pdf = render_pdf(document)
      inspect(pdf.contains("re"), content="true")
      inspect(pdf.contains("Hello \\(MoonBit\\)"), content="true")
    }
    Err(_) => inspect(false, content="true")
  }
}

///|
test "pdf rejects invalid page dimensions" {
  inspect(PdfDocument::page(0, 100) is Err(_), content="true")
  inspect(PdfDocument::page(100, 0) is Err(_), content="true")
  inspect(PdfDocument::page(20000, 100) is Err(_), content="true")
}

///|
test "pdf output is deterministic" {
  match PdfDocument::page(100, 100) {
    Ok(document) => {
      let left = render_pdf(document.add_line(0, 0, 100, 100, "0 0 0"))
      let right = render_pdf(document.add_line(0, 0, 100, 100, "0 0 0"))
      inspect(left == right, content="true")
    }
    Err(_) => inspect(false, content="true")
  }
}
