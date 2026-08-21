///|
test "measure stack reports negative inputs and keeps frame order" {
  let result = measure_stack_vertical(
    region=@scene.Rect::{ x: 0, y: 0, width: 100, height: 100 },
    item_heights=[20, -5, 90],
    gap=-4,
    constraints=@core.Constraints::unbounded(),
  )
  inspect(result.frames.length(), content="3")
  inspect(result.warnings.length(), content="3")
  debug_inspect(
    result.frames[1],
    content="{ x: 0, y: 20, width: 100, height: 0 }",
  )
  inspect(result.used.height, content="110")
}

///|
test "measure grid returns a diagnostic for invalid dimensions" {
  let result = measure_grid(
    region=@scene.Rect::{ x: 0, y: 0, width: 100, height: 100 },
    spec=GridSpec::{
      columns: 0,
      rows: 2,
      gap_x: 0,
      gap_y: 0,
      padding: @core.EdgeInsets::zero(),
    },
    constraints=@core.Constraints::unbounded(),
  )
  inspect(result.frames.length(), content="0")
  inspect(warnings_text(result.warnings), content="invalid-grid")
}
