pub(all) struct Point {
  x : Int
  y : Int
} derive(Debug, Eq)

pub(all) struct Rect {
  x : Int
  y : Int
  width : Int
  height : Int
} derive(Debug, Eq)

pub(all) enum TextAlign {
  Left
  Center
  Right
} derive(Debug, Eq)

pub(all) enum ImageFit {
  Cover
  Contain
} derive(Debug, Eq)

pub(all) struct TextStyle {
  family : String
  size : Int
  weight : Int
  line_height : Int
  align : TextAlign
  color : @theme.Color
} derive(Debug, Eq)

pub(all) enum Element {
  Block(id~ : String, rect~ : Rect, fill~ : @theme.Color, radius~ : Int)
  Text(
    id~ : String,
    content~ : String,
    position~ : Point,
    style~ : TextStyle,
    max_width~ : Int,
  )
  ImageSlot(
    id~ : String,
    asset_id~ : String,
    rect~ : Rect,
    label~ : String,
    fit~ : ImageFit,
  )
} derive(Debug, Eq)

pub(all) struct PosterDocument {
  title : String
  preset : @preset.PosterPreset
  theme : @theme.Theme
  elements : Array[Element]
} derive(Debug, Eq)

pub fn Point::at(x : Int, y : Int) -> Point {
  { x, y }
}

pub fn Rect::inset(rect : Rect, edge : @core.EdgeInsets) -> Rect {
  {
    x: rect.x + edge.left,
    y: rect.y + edge.top,
    width: rect.width - edge.left - edge.right,
    height: rect.height - edge.top - edge.bottom,
  }
}

pub fn TextStyle::display(theme : @theme.Theme) -> TextStyle {
  {
    family: "Georgia, Source Han Serif SC, serif",
    size: theme.title_size,
    weight: 700,
    line_height: theme.title_size + 18,
    align: TextAlign::Left,
    color: theme.foreground,
  }
}

pub fn TextStyle::body(theme : @theme.Theme) -> TextStyle {
  {
    family: "Arial, Noto Sans SC, sans-serif",
    size: theme.body_size,
    weight: 400,
    line_height: theme.body_size + 14,
    align: TextAlign::Left,
    color: theme.foreground,
  }
}

pub fn PosterDocument::empty(
  title~ : String,
  preset~ : @preset.PosterPreset,
  theme~ : @theme.Theme,
) -> PosterDocument {
  { title, preset, theme, elements: [] }
}

pub fn PosterDocument::push(
  document : PosterDocument,
  element : Element,
) -> PosterDocument {
  let elements = document.elements.copy()
  elements.push(element)
  { ..document, elements }
}

pub fn PosterDocument::push_iter(
  document : PosterDocument,
  new_elements : Iter[Element],
) -> PosterDocument {
  let elements = document.elements.copy()
  elements.push_iter(new_elements)
  { ..document, elements }
}
