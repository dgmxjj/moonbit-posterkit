test "stack_vertical splits a region into sequential frames" {
  let frames = stack_vertical(
    region=@scene.Rect::{ x: 0, y: 0, width: 1000, height: 600 },
    item_heights=[100, 200, 120],
    gap=20,
  )
  inspect(frames.length(), content="3")
  debug_inspect(frames[0], content="{ x: 0, y: 0, width: 1000, height: 100 }")
  debug_inspect(frames[1], content="{ x: 0, y: 120, width: 1000, height: 200 }")
  debug_inspect(frames[2], content="{ x: 0, y: 340, width: 1000, height: 120 }")
}

test "grid respects padding and gutters" {
  let frames = grid(
    region=@scene.Rect::{ x: 0, y: 0, width: 1080, height: 1080 },
    spec=GridSpec::{
      columns: 2,
      rows: 2,
      gap_x: 24,
      gap_y: 24,
      padding: @core.EdgeInsets::all(96),
    },
  )
  inspect(frames.length(), content="4")
  debug_inspect(frames[0], content="{ x: 96, y: 96, width: 432, height: 432 }")
  debug_inspect(frames[3], content="{ x: 552, y: 552, width: 432, height: 432 }")
}

test "anchor places a box at the visual center" {
  let point = anchor(
    region=@scene.Rect::{ x: 100, y: 100, width: 880, height: 880 },
    size=@core.Size::{ width: 400, height: 200 },
    h_align=HorizontalAlign::Center,
    v_align=VerticalAlign::Middle,
    margin=@core.EdgeInsets::zero(),
  )
  debug_inspect(point, content="{ x: 340, y: 440 }")
}
