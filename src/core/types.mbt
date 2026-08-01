///|
pub(all) struct Size {
  width : Int
  height : Int
} derive(Debug, Eq)

///|
pub(all) struct EdgeInsets {
  top : Int
  right : Int
  bottom : Int
  left : Int
} derive(Debug, Eq)

///|
pub fn Size::square(edge : Int) -> Size {
  { width: edge, height: edge }
}

///|
pub fn EdgeInsets::all(value : Int) -> EdgeInsets {
  { top: value, right: value, bottom: value, left: value }
}

///|
pub fn EdgeInsets::zero() -> EdgeInsets {
  EdgeInsets::all(0)
}
