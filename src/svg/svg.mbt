///|
fn escape_xml(raw : String) -> String {
  raw
  .replace_all(old="&", new="&amp;")
  .replace_all(old="<", new="&lt;")
  .replace_all(old=">", new="&gt;")
  .replace_all(old="\"", new="&quot;")
}

///|
fn render_text_align(align : @scene.TextAlign) -> String {
  match align {
    @scene.TextAlign::Left => "start"
    @scene.TextAlign::Center => "middle"
    @scene.TextAlign::Right => "end"
  }
}

///|
fn render_image_fit(fit : @scene.ImageFit) -> String {
  match fit {
    @scene.ImageFit::Cover => "cover"
    @scene.ImageFit::Contain => "contain"
  }
}

///|
fn render_block(
  id : String,
  rect : @scene.Rect,
  fill : @theme.Color,
  radius : Int,
) -> String {
  [
    "<rect",
    " id=\"" + escape_xml(id) + "\"",
    " x=\"" + rect.x.to_string() + "\"",
    " y=\"" + rect.y.to_string() + "\"",
    " width=\"" + rect.width.to_string() + "\"",
    " height=\"" + rect.height.to_string() + "\"",
    " rx=\"" + radius.to_string() + "\"",
    " fill=\"" + fill.as_css() + "\"",
    " />",
  ].join("")
}

///|
fn render_text(
  id : String,
  content : String,
  position : @scene.Point,
  style : @scene.TextStyle,
  max_width : Int,
) -> String {
  [
    "<text",
    " id=\"" + escape_xml(id) + "\"",
    " x=\"" + position.x.to_string() + "\"",
    " y=\"" + position.y.to_string() + "\"",
    " fill=\"" + style.color.as_css() + "\"",
    " font-family=\"" + escape_xml(style.family) + "\"",
    " font-size=\"" + style.size.to_string() + "\"",
    " font-weight=\"" + style.weight.to_string() + "\"",
    " text-anchor=\"" + render_text_align(style.align) + "\"",
    " data-max-width=\"" + max_width.to_string() + "\"",
    ">",
    escape_xml(content),
    "</text>",
  ].join("")
}

///|
fn render_image_slot(
  id : String,
  asset_id : String,
  rect : @scene.Rect,
  label : String,
  fit : @scene.ImageFit,
) -> String {
  let center_x = rect.x + rect.width / 2
  let center_y = rect.y + rect.height / 2
  [
    "<g",
    " id=\"" + escape_xml(id) + "\"",
    " data-asset-id=\"" + escape_xml(asset_id) + "\"",
    " data-fit=\"" + render_image_fit(fit) + "\"",
    ">",
    "<rect",
    " x=\"" + rect.x.to_string() + "\"",
    " y=\"" + rect.y.to_string() + "\"",
    " width=\"" + rect.width.to_string() + "\"",
    " height=\"" + rect.height.to_string() + "\"",
    " fill=\"none\" stroke=\"#7c6f64\" stroke-width=\"3\"",
    " stroke-dasharray=\"12 8\" />",
    "<text",
    " x=\"" + center_x.to_string() + "\"",
    " y=\"" + center_y.to_string() + "\"",
    " fill=\"#7c6f64\" font-family=\"Arial, Noto Sans SC, sans-serif\"",
    " font-size=\"26\" text-anchor=\"middle\">",
    escape_xml(label),
    "</text>",
    "</g>",
  ].join("")
}

///|
fn render_element(element : @scene.Element) -> String {
  match element {
    Block(id~, rect~, fill~, radius~) => render_block(id, rect, fill, radius)
    Text(id~, content~, position~, style~, max_width~) =>
      render_text(id, content, position, style, max_width)
    ImageSlot(id~, asset_id~, rect~, label~, fit~) =>
      render_image_slot(id, asset_id, rect, label, fit)
  }
}

///|
pub fn render_svg(document : @scene.PosterDocument) -> String {
  let fragments = document.elements.map(render_element)
  let view_box = " viewBox=\"0 0 " +
    document.preset.canvas.width.to_string() +
    " " +
    document.preset.canvas.height.to_string() +
    "\""
  [
    "<svg xmlns=\"http://www.w3.org/2000/svg\"",
    " width=\"" + document.preset.canvas.width.to_string() + "\"",
    " height=\"" + document.preset.canvas.height.to_string() + "\"",
    view_box,
    " data-title=\"" + escape_xml(document.title) + "\"",
    ">",
    "<rect width=\"100%\" height=\"100%\" fill=\"" +
    document.theme.background.as_css() +
    "\" />",
    fragments.join(""),
    "</svg>",
  ].join("")
}
