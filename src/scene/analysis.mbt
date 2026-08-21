///|
pub(all) struct DocumentStats {
  element_count : Int
  block_count : Int
  text_count : Int
  image_slot_count : Int
  text_characters : Int
  occupied_area : Int
  ids : Array[String]
} derive(Debug, Eq)

///|
pub fn DocumentStats::empty() -> DocumentStats {
  {
    element_count: 0,
    block_count: 0,
    text_count: 0,
    image_slot_count: 0,
    text_characters: 0,
    occupied_area: 0,
    ids: [],
  }
}

///|
fn append_id(ids : Array[String], id : String) -> Array[String] {
  let result = ids.copy()
  result.push(id)
  result
}

///|
pub fn analyze_document(document : PosterDocument) -> DocumentStats {
  document.elements.fold(init=DocumentStats::empty(), (stats, element) => {
    match element {
      Block(id~, rect~, fill=_, radius=_) =>
        {
          ..stats,
          element_count: stats.element_count + 1,
          block_count: stats.block_count + 1,
          occupied_area: stats.occupied_area +
          Int::max(rect.width, 0) * Int::max(rect.height, 0),
          ids: append_id(stats.ids, id),
        }
      Text(id~, content~, position=_, style=_, max_width=_) =>
        {
          ..stats,
          element_count: stats.element_count + 1,
          text_count: stats.text_count + 1,
          text_characters: stats.text_characters + content.char_length(),
          ids: append_id(stats.ids, id),
        }
      ImageSlot(id~, asset_id=_, rect~, label~, fit=_) =>
        {
          ..stats,
          element_count: stats.element_count + 1,
          image_slot_count: stats.image_slot_count + 1,
          occupied_area: stats.occupied_area +
          Int::max(rect.width, 0) * Int::max(rect.height, 0),
          text_characters: stats.text_characters + label.char_length(),
          ids: append_id(stats.ids, id),
        }
    }
  })
}

///|
pub fn text_character_count(document : PosterDocument) -> Int {
  analyze_document(document).text_characters
}

///|
pub fn image_slot_count(document : PosterDocument) -> Int {
  analyze_document(document).image_slot_count
}

///|
fn find_element_at(
  elements : Array[Element],
  index : Int,
  id : String,
) -> Element? {
  if index >= elements.length() {
    None
  } else if element_id(elements[index]) == id {
    Some(elements[index])
  } else {
    find_element_at(elements, index + 1, id)
  }
}

///|
pub fn find_element(document : PosterDocument, id : String) -> Element? {
  find_element_at(document.elements, 0, id)
}

///|
pub fn element_ids_sorted(document : PosterDocument) -> Array[String] {
  let ids = element_ids(document)
  for i = 0; i < ids.length(); i = i + 1 {
    for j = i + 1; j < ids.length(); j = j + 1 {
      if String::lexical_compare(ids[i], ids[j]) > 0 {
        let value = ids[i]
        ids[i] = ids[j]
        ids[j] = value
      }
    }
  }
  ids
}
