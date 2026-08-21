///|
pub(all) enum LayoutWarning {
  NegativeGap(value~ : Int)
  NegativeHeight(index~ : Int, value~ : Int)
  ClippedChild(index~ : Int, overflow~ : @core.RectOverflow)
  EmptyRegion
  InvalidGrid
} derive(Debug, Eq)

///|
pub fn warning_code(warning : LayoutWarning) -> String {
  match warning {
    NegativeGap(value=_) => "negative-gap"
    NegativeHeight(index=_, value=_) => "negative-height"
    ClippedChild(index=_, overflow=_) => "clipped-child"
    EmptyRegion => "empty-region"
    InvalidGrid => "invalid-grid"
  }
}

///|
pub fn warnings_text(warnings : Array[LayoutWarning]) -> String {
  warnings.map(warning_code).join(",")
}
