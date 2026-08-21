///|
pub(all) struct LayoutResult {
  frames : Array[@scene.Rect]
  warnings : Array[LayoutWarning]
  used : @core.Size
} derive(Debug, Eq)

///|
pub fn measure_stack_vertical(
  region~ : @scene.Rect,
  item_heights~ : Array[Int],
  gap~ : Int,
  constraints~ : @core.Constraints,
) -> LayoutResult {
  let warnings : Array[LayoutWarning] = []
  if region.width <= 0 || region.height <= 0 {
    warnings.push(LayoutWarning::EmptyRegion)
  }
  let safe_gap = if gap < 0 {
    warnings.push(NegativeGap(value=gap))
    0
  } else {
    gap
  }
  let frames : Array[@scene.Rect] = []
  let mut current_y = region.y
  let mut used_height = 0
  item_heights.eachi((index, raw_height) => {
    let height = Int::max(raw_height, 0)
    if raw_height < 0 {
      warnings.push(LayoutWarning::NegativeHeight(index~, value=raw_height))
    }
    let frame = @scene.Rect::{
      x: region.x,
      y: current_y,
      width: region.width,
      height,
    }
    let overflow = rect_overflow(frame, region)
    if overflow.left > 0 ||
      overflow.top > 0 ||
      overflow.right > 0 ||
      overflow.bottom > 0 {
      warnings.push(LayoutWarning::ClippedChild(index~, overflow~))
    }
    frames.push(frame)
    current_y = current_y + height + safe_gap
    used_height = current_y - region.y - safe_gap
  })
  let used = constraints.constrain(@core.Size::{
    width: region.width,
    height: used_height,
  })
  { frames, warnings, used }
}

///|
pub fn measure_grid(
  region~ : @scene.Rect,
  spec~ : GridSpec,
  constraints~ : @core.Constraints,
) -> LayoutResult {
  let warnings : Array[LayoutWarning] = []
  if spec.columns <= 0 || spec.rows <= 0 {
    warnings.push(LayoutWarning::InvalidGrid)
    return { frames: [], warnings, used: @core.Size::{ width: 0, height: 0 } }
  }
  let frames = grid(region~, spec~)
  let used = constraints.constrain(@core.Size::{
    width: region.width,
    height: region.height,
  })
  { frames, warnings, used }
}
