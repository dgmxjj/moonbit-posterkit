///|
pub(all) struct SvgMetrics {
  element_count : Int
  text_count : Int
  image_slot_count : Int
  block_count : Int
  bytes : Int
} derive(Debug, Eq)

///|
pub fn SvgMetrics::empty() -> SvgMetrics {
  {
    element_count: 0,
    text_count: 0,
    image_slot_count: 0,
    block_count: 0,
    bytes: 0,
  }
}

///|
pub fn SvgMetrics::add_element(
  metrics : SvgMetrics,
  element : @scene.Element,
) -> SvgMetrics {
  match element {
    @scene.Element::Text(id=_, content=_, position=_, style=_, max_width=_) =>
      {
        ..metrics,
        element_count: metrics.element_count + 1,
        text_count: metrics.text_count + 1,
      }
    @scene.Element::ImageSlot(id=_, asset_id=_, rect=_, label=_, fit=_) =>
      {
        ..metrics,
        element_count: metrics.element_count + 1,
        image_slot_count: metrics.image_slot_count + 1,
      }
    @scene.Element::Block(id=_, rect=_, fill=_, radius=_) =>
      {
        ..metrics,
        element_count: metrics.element_count + 1,
        block_count: metrics.block_count + 1,
      }
  }
}
