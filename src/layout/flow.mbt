///|
pub(all) enum FlowDirection {
  Horizontal
  Vertical
} derive(Debug, Eq)

///|
pub(all) enum FlowAlignment {
  Start
  Center
  End
  SpaceBetween
} derive(Debug, Eq)

///|
pub fn stack_horizontal(
  region~ : @scene.Rect,
  item_widths~ : Array[Int],
  gap~ : Int,
) -> Array[@scene.Rect] {
  let frames : Array[@scene.Rect] = []
  let safe_gap = Int::max(gap, 0)
  let mut x = region.x
  item_widths.each(width => {
    let safe_width = Int::max(width, 0)
    frames.push({ x, y: region.y, width: safe_width, height: region.height })
    x = x + safe_width + safe_gap
  })
  frames
}

///|
pub fn distribute_horizontal(
  region~ : @scene.Rect,
  item_widths~ : Array[Int],
  alignment~ : FlowAlignment,
) -> Array[@scene.Rect] {
  let widths = item_widths.map(width => Int::max(width, 0))
  let total = widths.fold(init=0, (sum, width) => sum + width)
  let remaining = Int::max(region.width - total, 0)
  let gap = match alignment {
    Start => 0
    Center => 0
    End => 0
    SpaceBetween =>
      if widths.length() <= 1 {
        0
      } else {
        remaining / (widths.length() - 1)
      }
  }
  let offset = match alignment {
    Start => 0
    Center => remaining / 2
    End => remaining
    SpaceBetween => 0
  }
  let frames : Array[@scene.Rect] = []
  let mut x = region.x + offset
  widths.each(width => {
    frames.push({ x, y: region.y, width, height: region.height })
    x = x + width + gap
  })
  frames
}

///|
pub fn fit_rect(
  source~ : @core.Size,
  target~ : @scene.Rect,
  mode~ : @scene.ImageFit,
) -> @scene.Rect {
  if source.width <= 0 ||
    source.height <= 0 ||
    target.width <= 0 ||
    target.height <= 0 {
    return { ..target, width: 0, height: 0 }
  }
  let source_ratio = source.width.to_double() / source.height.to_double()
  let target_ratio = target.width.to_double() / target.height.to_double()
  let crop = match mode {
    @scene.ImageFit::Contain => source_ratio < target_ratio
    @scene.ImageFit::Cover => source_ratio > target_ratio
  }
  if crop {
    { ..target, width: target.width, height: target.height }
  } else {
    { ..target, width: target.width, height: target.height }
  }
}

///|
pub fn split_vertical(
  region : @scene.Rect,
  ratio_percent : Int,
) -> (@scene.Rect, @scene.Rect) {
  let ratio = Int::clamp(ratio_percent, min=0, max=100)
  let first_height = region.height * ratio / 100
  let first : @scene.Rect = {
    x: region.x,
    y: region.y,
    width: region.width,
    height: first_height,
  }
  let second : @scene.Rect = {
    x: region.x,
    y: region.y + first_height,
    width: region.width,
    height: region.height - first_height,
  }
  (first, second)
}

///|
pub fn split_horizontal(
  region : @scene.Rect,
  ratio_percent : Int,
) -> (@scene.Rect, @scene.Rect) {
  let ratio = Int::clamp(ratio_percent, min=0, max=100)
  let first_width = region.width * ratio / 100
  let first : @scene.Rect = {
    x: region.x,
    y: region.y,
    width: first_width,
    height: region.height,
  }
  let second : @scene.Rect = {
    x: region.x + first_width,
    y: region.y,
    width: region.width - first_width,
    height: region.height,
  }
  (first, second)
}
