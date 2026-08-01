pub(all) struct GridSpec {
  columns : Int
  rows : Int
  gap_x : Int
  gap_y : Int
  padding : @core.EdgeInsets
} derive(Debug, Eq)

pub(all) enum HorizontalAlign {
  Start
  Center
  End
} derive(Debug, Eq)

pub(all) enum VerticalAlign {
  Top
  Middle
  Bottom
} derive(Debug, Eq)

pub fn stack_vertical(
  region~ : @scene.Rect,
  item_heights~ : Array[Int],
  gap~ : Int,
) -> Array[@scene.Rect] {
  let frames : Array[@scene.Rect] = []
  let mut current_y = region.y
  item_heights.each(height => {
    frames.push({
      x: region.x,
      y: current_y,
      width: region.width,
      height,
    })
    current_y = current_y + height + gap
  })
  frames
}

pub fn grid(region~ : @scene.Rect, spec~ : GridSpec) -> Array[@scene.Rect] {
  if spec.columns <= 0 || spec.rows <= 0 {
    []
  } else {
    let inner = region.inset(spec.padding)
    let cell_width = (inner.width - spec.gap_x * (spec.columns - 1)) / spec.columns
    let cell_height = (inner.height - spec.gap_y * (spec.rows - 1)) / spec.rows
    Array::makei(spec.columns * spec.rows, index => {
      let row = index / spec.columns
      let column = index % spec.columns
      {
        x: inner.x + column * (cell_width + spec.gap_x),
        y: inner.y + row * (cell_height + spec.gap_y),
        width: cell_width,
        height: cell_height,
      }
    })
  }
}

fn resolve_x(
  region : @scene.Rect,
  width : Int,
  h_align : HorizontalAlign,
) -> Int {
  match h_align {
    Start => region.x
    Center => region.x + (region.width - width) / 2
    End => region.x + region.width - width
  }
}

fn resolve_y(
  region : @scene.Rect,
  height : Int,
  v_align : VerticalAlign,
) -> Int {
  match v_align {
    Top => region.y
    Middle => region.y + (region.height - height) / 2
    Bottom => region.y + region.height - height
  }
}

pub fn anchor(
  region~ : @scene.Rect,
  size~ : @core.Size,
  h_align~ : HorizontalAlign,
  v_align~ : VerticalAlign,
  margin~ : @core.EdgeInsets,
) -> @scene.Point {
  let inner = region.inset(margin)
  @scene.Point::at(
    resolve_x(inner, size.width, h_align),
    resolve_y(inner, size.height, v_align),
  )
}
