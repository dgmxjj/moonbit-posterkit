///|
test "horizontal stack preserves order and non-negative widths" {
  let frames = stack_horizontal(
    region=@scene.Rect::{ x: 10, y: 20, width: 300, height: 80 },
    item_widths=[50, -4, 100],
    gap=10,
  )
  debug_inspect(frames[1], content="{ x: 70, y: 20, width: 0, height: 80 }")
  debug_inspect(frames[2], content="{ x: 80, y: 20, width: 100, height: 80 }")
}

///|
test "distribution supports center end and space between" {
  let region = @scene.Rect::{ x: 0, y: 0, width: 300, height: 50 }
  let centered = distribute_horizontal(
    region~,
    item_widths=[50, 50],
    alignment=FlowAlignment::Center,
  )
  debug_inspect(centered[0], content="{ x: 100, y: 0, width: 50, height: 50 }")
  debug_inspect(centered[1], content="{ x: 150, y: 0, width: 50, height: 50 }")
  let spaced = distribute_horizontal(
    region~,
    item_widths=[50, 50],
    alignment=FlowAlignment::SpaceBetween,
  )
  debug_inspect(spaced[0], content="{ x: 0, y: 0, width: 50, height: 50 }")
  debug_inspect(spaced[1], content="{ x: 250, y: 0, width: 50, height: 50 }")
}

///|
test "split helpers conserve the original region" {
  let region = @scene.Rect::{ x: 10, y: 20, width: 200, height: 100 }
  let (top, bottom) = split_vertical(region, 40)
  inspect(top.height + bottom.height, content="100")
  let (left, right) = split_horizontal(region, 25)
  inspect(left.width + right.width, content="200")
}
