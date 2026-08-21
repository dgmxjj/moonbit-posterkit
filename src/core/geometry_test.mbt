///|
test "constraints clamp sizes to their normalized bounds" {
  let constraints = Constraints::{
    min_width: 100,
    max_width: 400,
    min_height: 80,
    max_height: 300,
  }
  debug_inspect(
    constraints.constrain(Size::{ width: 10, height: 500 }),
    content="{ width: 100, height: 300 }",
  )
}

///|
test "tight constraints force both dimensions" {
  debug_inspect(
    Constraints::tight(Size::{ width: 240, height: 120 }).constrain(Size::{
      width: 1,
      height: 2,
    }),
    content="{ width: 240, height: 120 }",
  )
}
