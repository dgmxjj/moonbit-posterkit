///|
pub fn normalized_id(raw : String, fallback : String) -> String {
  @core.safe_filename(raw, fallback).to_lower()
}

///|
pub fn normalized_title(document : PosterDocument, fallback : String) -> String {
  let title = document.title.trim().to_owned()
  if title.is_empty() {
    fallback
  } else {
    title
  }
}

///|
pub fn normalize_document_ids(document : PosterDocument) -> PosterDocument {
  let elements : Array[Element] = []
  document.elements.eachi((index, element) => {
    let fallback = "element-" + (index + 1).to_string()
    match element {
      Block(id~, rect~, fill~, radius~) =>
        elements.push(
          Block(id=normalized_id(id, fallback), rect~, fill~, radius~),
        )
      Text(id~, content~, position~, style~, max_width~) =>
        elements.push(
          Text(
            id=normalized_id(id, fallback),
            content~,
            position~,
            style~,
            max_width~,
          ),
        )
      ImageSlot(id~, asset_id~, rect~, label~, fit~) =>
        elements.push(
          ImageSlot(
            id=normalized_id(id, fallback),
            asset_id~,
            rect~,
            label~,
            fit~,
          ),
        )
    }
  })
  { ..document, title: normalized_title(document, "Untitled Poster"), elements }
}

///|
pub fn document_without_empty_text(document : PosterDocument) -> PosterDocument {
  let elements = document.elements.filter(element => {
    match element {
      Text(id=_, content~, position=_, style=_, max_width=_) =>
        !content.trim().is_empty()
      _ => true
    }
  })
  { ..document, elements, }
}

///|
pub fn normalize_for_render(document : PosterDocument) -> PosterDocument {
  document_without_empty_text(normalize_document_ids(document))
}

///|
pub fn normalization_summary(document : PosterDocument) -> String {
  let normalized = normalize_for_render(document)
  "title=" +
  normalized.title +
  ",elements=" +
  normalized.elements.length().to_string()
}
