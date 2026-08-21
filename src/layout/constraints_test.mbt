///|
test "layout envelope applies padding and limits" {
  let request : LayoutRequest = {
    region: @scene.Rect::{ x: 0, y: 0, width: 400, height: 200 },
    min_width: 100,
    min_height: 80,
    max_width: 240,
    max_height: 160,
    gap: 12,
    padding: @core.EdgeInsets::all(20),
  }
  let envelope = layout_envelope(request)
  debug_inspect(
    envelope.content,
    content="{ x: 20, y: 20, width: 360, height: 160 }",
  )
  debug_inspect(envelope.constrained, content="{ width: 240, height: 160 }")
  inspect(envelope.valid, content="true")
}

///|
test "layout request summary exposes invalid negative gaps" {
  let request : LayoutRequest = {
    region: @scene.Rect::{ x: 0, y: 0, width: 100, height: 100 },
    min_width: 0,
    min_height: 0,
    max_width: 100,
    max_height: 100,
    gap: -1,
    padding: @core.EdgeInsets::zero(),
  }
  inspect(
    layout_request_summary(request).contains("valid=false"),
    content="true",
  )
}
