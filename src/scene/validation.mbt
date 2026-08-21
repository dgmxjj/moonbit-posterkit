///|
pub(all) enum SceneDiagnostic {
  EmptyTitle
  EmptyElementId(index~ : Int)
  DuplicateElementId(id~ : String)
  InvalidRect(id~ : String)
  EmptyAssetId(id~ : String)
  EmptyImageLabel(id~ : String)
  TextOutsideCanvas(id~ : String)
} derive(Debug, Eq)

///|
pub fn element_ids(document : PosterDocument) -> Array[String] {
  document.elements.map(element_id)
}

///|
fn element_id(element : Element) -> String {
  match element {
    Block(id~, rect=_, fill=_, radius=_) => id
    Text(id~, content=_, position=_, style=_, max_width=_) => id
    ImageSlot(id~, asset_id=_, rect=_, label=_, fit=_) => id
  }
}

///|
fn has_id(ids : Array[String], target : String) -> Bool {
  ids.any(id => id == target)
}

///|
fn rect_is_invalid(rect : Rect) -> Bool {
  rect.width <= 0 || rect.height <= 0
}

///|
pub fn validate_document(
  document : PosterDocument,
  strict~ : Bool,
) -> Array[SceneDiagnostic] {
  let diagnostics : Array[SceneDiagnostic] = []
  if strict && document.title.trim().is_empty() {
    diagnostics.push(SceneDiagnostic::EmptyTitle)
  }
  let ids : Array[String] = []
  document.elements.eachi((index, element) => {
    let id = element_id(element)
    if id.trim().is_empty() {
      diagnostics.push(SceneDiagnostic::EmptyElementId(index~))
    } else if has_id(ids, id) {
      diagnostics.push(SceneDiagnostic::DuplicateElementId(id~))
    } else {
      ids.push(id)
    }
    match element {
      Block(id~, rect~, fill=_, radius~) => {
        if rect_is_invalid(rect) {
          diagnostics.push(InvalidRect(id~))
        }
        if radius < 0 {
          diagnostics.push(InvalidRect(id~))
        }
      }
      Text(id~, content=_, position~, style=_, max_width~) => {
        if max_width <= 0 {
          diagnostics.push(InvalidRect(id~))
        }
        if position.x < 0 ||
          position.y < 0 ||
          position.x >= document.preset.canvas.width ||
          position.y >= document.preset.canvas.height {
          diagnostics.push(TextOutsideCanvas(id~))
        }
      }
      ImageSlot(id~, asset_id~, rect~, label~, fit=_) => {
        if rect_is_invalid(rect) {
          diagnostics.push(InvalidRect(id~))
        }
        if asset_id.trim().is_empty() {
          diagnostics.push(EmptyAssetId(id~))
        }
        if label.trim().is_empty() {
          diagnostics.push(EmptyImageLabel(id~))
        }
      }
    }
  })
  diagnostics
}

///|
pub fn diagnostic_code(diagnostic : SceneDiagnostic) -> String {
  match diagnostic {
    EmptyTitle => "empty-title"
    EmptyElementId(index=_) => "empty-element-id"
    DuplicateElementId(id=_) => "duplicate-element-id"
    InvalidRect(id=_) => "invalid-rect"
    EmptyAssetId(id=_) => "empty-asset-id"
    EmptyImageLabel(id=_) => "empty-image-label"
    TextOutsideCanvas(id=_) => "text-outside-canvas"
  }
}
