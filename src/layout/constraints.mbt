///|
pub(all) struct LayoutRequest {
  region : @scene.Rect
  min_width : Int
  min_height : Int
  max_width : Int
  max_height : Int
  gap : Int
  padding : @core.EdgeInsets
} derive(Debug, Eq)

///|
pub(all) struct LayoutEnvelope {
  content : @scene.Rect
  requested : @core.Size
  constrained : @core.Size
  overflow : @core.RectOverflow
  valid : Bool
} derive(Debug, Eq)

///|
pub fn content_region(
  region : @scene.Rect,
  padding : @core.EdgeInsets,
) -> @scene.Rect {
  let inner = region.inset(padding)
  {
    ..inner,
    width: Int::max(inner.width, 0),
    height: Int::max(inner.height, 0),
  }
}

///|
pub fn layout_envelope(request : LayoutRequest) -> LayoutEnvelope {
  let content = content_region(request.region, request.padding)
  let constraints = @core.Constraints::{
    min_width: Int::max(request.min_width, 0),
    max_width: Int::max(request.max_width, Int::max(request.min_width, 0)),
    min_height: Int::max(request.min_height, 0),
    max_height: Int::max(request.max_height, Int::max(request.min_height, 0)),
  }
  let requested = @core.Size::{ width: content.width, height: content.height }
  let constrained = constraints.constrain(requested)
  let overflow = rect_overflow(
    @scene.Rect::{
      x: content.x,
      y: content.y,
      width: constrained.width,
      height: constrained.height,
    },
    request.region,
  )
  {
    content,
    requested,
    constrained,
    overflow,
    valid: request.gap >= 0 &&
    request.region.width >= 0 &&
    request.region.height >= 0,
  }
}

///|
pub fn layout_request_summary(request : LayoutRequest) -> String {
  let envelope = layout_envelope(request)
  let valid = if envelope.valid { "true" } else { "false" }
  "content=" +
  envelope.content.width.to_string() +
  "x" +
  envelope.content.height.to_string() +
  ",requested=" +
  envelope.requested.width.to_string() +
  "x" +
  envelope.requested.height.to_string() +
  ",valid=" +
  valid
}
