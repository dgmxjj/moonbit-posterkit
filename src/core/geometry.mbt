///|
pub(all) struct Constraints {
  min_width : Int
  max_width : Int
  min_height : Int
  max_height : Int
} derive(Debug, Eq)

///|
pub(all) struct RectOverflow {
  left : Int
  top : Int
  right : Int
  bottom : Int
} derive(Debug, Eq)

///|
pub fn Constraints::unbounded() -> Constraints {
  {
    min_width: 0,
    max_width: 2_147_483_647,
    min_height: 0,
    max_height: 2_147_483_647,
  }
}

///|
pub fn Constraints::tight(size : Size) -> Constraints {
  let width = Int::max(size.width, 0)
  let height = Int::max(size.height, 0)
  { min_width: width, max_width: width, min_height: height, max_height: height }
}

///|
pub fn Constraints::constrain(self : Constraints, size : Size) -> Size {
  {
    width: Int::min(Int::max(size.width, self.min_width), self.max_width),
    height: Int::min(Int::max(size.height, self.min_height), self.max_height),
  }
}

///|
pub fn Size::non_negative(self : Size) -> Size {
  { width: Int::max(self.width, 0), height: Int::max(self.height, 0) }
}
