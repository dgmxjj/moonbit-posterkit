///|
pub(all) struct TemplateContent {
  eyebrow : String
  title : String
  subtitle : String
  body : String
  cta : String
  footer : String
  image_label : String
  image_asset_id : String
} derive(Debug, Eq, FromJson, ToJson)

///|
fn canvas_frame(preset : @preset.PosterPreset) -> @scene.Rect {
  { x: 0, y: 0, width: preset.canvas.width, height: preset.canvas.height }
}

///|
fn eyebrow_style(theme : @theme.Theme) -> @scene.TextStyle {
  {
    ..@scene.TextStyle::body(theme),
    size: theme.caption_size,
    line_height: theme.caption_size + 8,
    weight: 700,
    color: theme.accent,
  }
}

///|
fn caption_style(theme : @theme.Theme) -> @scene.TextStyle {
  {
    ..@scene.TextStyle::body(theme),
    size: theme.caption_size,
    line_height: theme.caption_size + 10,
    color: theme.muted,
  }
}

///|
fn launch_layout(
  preset : @preset.PosterPreset,
  theme : @theme.Theme,
  content : TemplateContent,
) -> @scene.PosterDocument {
  let frame = canvas_frame(preset).inset(theme.padding)
  let sections = @layout.stack_vertical(
    region=frame,
    item_heights=[theme.caption_size + 10, 260, 380, 140],
    gap=32,
  )
  let document = @scene.PosterDocument::empty(
    title=content.title,
    preset~,
    theme~,
  )
  let headline_style = @scene.TextStyle::display(theme)
  let body_style = @scene.TextStyle::body(theme)
  let footer_style = caption_style(theme)
  let body_block = @layout.anchor(
    region=sections[3],
    size={ width: sections[3].width, height: sections[3].height },
    h_align=@layout.HorizontalAlign::Start,
    v_align=@layout.VerticalAlign::Top,
    margin=@core.EdgeInsets::zero(),
  )
  document
  .push(
    @scene.Element::Block(
      id="launch-shell",
      rect=frame,
      fill=@theme.Color::hex("#fffaf2"),
      radius=36,
    ),
  )
  .push(
    @scene.Element::Text(
      id="launch-eyebrow",
      content=content.eyebrow,
      position=@scene.Point::at(
        sections[0].x,
        sections[0].y + theme.caption_size,
      ),
      style=eyebrow_style(theme),
      max_width=sections[0].width,
    ),
  )
  .push(
    @scene.Element::Text(
      id="launch-subtitle",
      content=content.subtitle,
      position=@scene.Point::at(sections[1].x, sections[1].y + 34),
      style=body_style,
      max_width=sections[1].width,
    ),
  )
  .push(
    @scene.Element::ImageSlot(
      id="launch-hero",
      asset_id=content.image_asset_id,
      rect=sections[2],
      label=content.image_label,
      fit=@scene.ImageFit::Cover,
    ),
  )
  .push(
    @scene.Element::Text(
      id="launch-cta",
      content=content.cta,
      position=@scene.Point::at(
        sections[3].x,
        sections[3].y + theme.caption_size,
      ),
      style=eyebrow_style(theme),
      max_width=sections[3].width,
    ),
  )
  .push(
    @scene.Element::Text(
      id="launch-footer",
      content=content.footer,
      position=@scene.Point::at(body_block.x, body_block.y + 96),
      style=footer_style,
      max_width=sections[3].width,
    ),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="launch-title",
      region=sections[1],
      content=content.title,
      style=headline_style,
    ).iter(),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="launch-body",
      region={
        x: sections[3].x,
        y: sections[3].y + 40,
        width: sections[3].width,
        height: sections[3].height - 48,
      },
      content=content.body,
      style=body_style,
    ).iter(),
  )
}

///|
fn editorial_layout(
  preset : @preset.PosterPreset,
  theme : @theme.Theme,
  content : TemplateContent,
) -> @scene.PosterDocument {
  let frame = canvas_frame(preset).inset(theme.padding)
  let grid = @layout.grid(region=frame, spec=@layout.GridSpec::{
    columns: 1,
    rows: 3,
    gap_x: 0,
    gap_y: 28,
    padding: @core.EdgeInsets::zero(),
  })
  let document = @scene.PosterDocument::empty(
    title=content.title,
    preset~,
    theme~,
  )
  let headline_style = {
    ..@scene.TextStyle::display(theme),
    size: theme.title_size + 12,
    line_height: theme.title_size + 18,
    color: theme.accent,
  }
  document
  .push(
    @scene.Element::ImageSlot(
      id="editorial-cover",
      asset_id=content.image_asset_id,
      rect=grid[0],
      label=content.image_label,
      fit=@scene.ImageFit::Cover,
    ),
  )
  .push(
    @scene.Element::Block(
      id="editorial-kicker",
      rect={ x: grid[1].x, y: grid[1].y, width: 280, height: 52 },
      fill=theme.accent,
      radius=12,
    ),
  )
  .push(
    @scene.Element::Text(
      id="editorial-kicker-text",
      content=content.eyebrow,
      position=@scene.Point::at(grid[1].x + 18, grid[1].y + 32),
      style={ ..caption_style(theme), color: @theme.Color::hex("#ffffff") },
      max_width=244,
    ),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="editorial-title",
      region={
        x: grid[1].x,
        y: grid[1].y + 84,
        width: grid[1].width,
        height: grid[1].height - 84,
      },
      content=content.title,
      style=headline_style,
    ).iter(),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="editorial-subtitle",
      region=grid[2],
      content=content.subtitle + " " + content.body,
      style=@scene.TextStyle::body(theme),
    ).iter(),
  )
  .push(
    @scene.Element::Text(
      id="editorial-footer",
      content=content.footer,
      position=@scene.Point::at(grid[2].x, grid[2].y + grid[2].height - 16),
      style=caption_style(theme),
      max_width=grid[2].width,
    ),
  )
}

///|
fn event_layout(
  preset : @preset.PosterPreset,
  theme : @theme.Theme,
  content : TemplateContent,
) -> @scene.PosterDocument {
  let frame = canvas_frame(preset).inset(theme.padding)
  let columns = @layout.grid(region=frame, spec=@layout.GridSpec::{
    columns: 2,
    rows: 2,
    gap_x: 24,
    gap_y: 24,
    padding: @core.EdgeInsets::zero(),
  })
  let document = @scene.PosterDocument::empty(
    title=content.title,
    preset~,
    theme~,
  )
  let left_top = columns[0]
  let right_top = columns[1]
  let footer : @scene.Rect = {
    x: columns[2].x,
    y: columns[2].y,
    width: columns[2].width + 24 + columns[3].width,
    height: columns[2].height,
  }
  document
  .push(
    @scene.Element::Block(
      id="event-panel",
      rect=frame,
      fill=@theme.Color::hex("#fffaf2"),
      radius=32,
    ),
  )
  .push(
    @scene.Element::ImageSlot(
      id="event-image",
      asset_id=content.image_asset_id,
      rect=right_top,
      label=content.image_label,
      fit=@scene.ImageFit::Cover,
    ),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="event-title",
      region=left_top,
      content=content.title,
      style=@scene.TextStyle::display(theme),
    ).iter(),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="event-detail",
      region={
        x: left_top.x,
        y: left_top.y + 220,
        width: left_top.width,
        height: left_top.height - 220,
      },
      content=content.subtitle + " " + content.body + " " + content.cta,
      style=@scene.TextStyle::body(theme),
    ).iter(),
  )
  .push(
    @scene.Element::Text(
      id="event-footer",
      content=content.footer,
      position=@scene.Point::at(footer.x, footer.y + theme.caption_size),
      style=eyebrow_style(theme),
      max_width=footer.width,
    ),
  )
  .push(
    @scene.Element::Text(
      id="event-eyebrow",
      content=content.eyebrow,
      position=@scene.Point::at(footer.x, footer.y + 72),
      style=caption_style(theme),
      max_width=footer.width,
    ),
  )
}

///|
fn quote_layout(
  preset : @preset.PosterPreset,
  theme : @theme.Theme,
  content : TemplateContent,
) -> @scene.PosterDocument {
  let frame = canvas_frame(preset).inset(theme.padding)
  let sections = @layout.stack_vertical(
    region=frame,
    item_heights=[theme.caption_size + 12, 420, 260],
    gap=28,
  )
  let document = @scene.PosterDocument::empty(
    title=content.title,
    preset~,
    theme~,
  )
  let quote_style = {
    ..@scene.TextStyle::display(theme),
    size: theme.title_size + 10,
    line_height: theme.title_size + 22,
  }
  let body_style = @scene.TextStyle::body(theme)
  let byline_style = { ..eyebrow_style(theme), color: theme.foreground }
  let portrait_origin = @layout.anchor(
    region=sections[2],
    size={ width: 220, height: 220 },
    h_align=@layout.HorizontalAlign::End,
    v_align=@layout.VerticalAlign::Top,
    margin=@core.EdgeInsets::zero(),
  )
  let portrait_rect : @scene.Rect = {
    x: portrait_origin.x,
    y: portrait_origin.y,
    width: 220,
    height: 220,
  }
  let support_region : @scene.Rect = {
    x: sections[2].x,
    y: sections[2].y + 48,
    width: sections[2].width - 260,
    height: sections[2].height - 56,
  }
  document
  .push(
    @scene.Element::Block(
      id="quote-shell",
      rect=frame,
      fill=@theme.Color::hex("#fffaf4"),
      radius=36,
    ),
  )
  .push(
    @scene.Element::Block(
      id="quote-kicker",
      rect={ x: sections[0].x, y: sections[0].y, width: 260, height: 54 },
      fill=theme.accent,
      radius=14,
    ),
  )
  .push(
    @scene.Element::Text(
      id="quote-kicker-text",
      content=content.eyebrow,
      position=@scene.Point::at(sections[0].x + 18, sections[0].y + 34),
      style={ ..caption_style(theme), color: @theme.Color::hex("#ffffff") },
      max_width=220,
    ),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="quote-title",
      region=sections[1],
      content=content.title,
      style=quote_style,
    ).iter(),
  )
  .push(
    @scene.Element::Text(
      id="quote-author",
      content=content.subtitle,
      position=@scene.Point::at(
        sections[2].x,
        sections[2].y + theme.caption_size,
      ),
      style=byline_style,
      max_width=support_region.width,
    ),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="quote-support",
      region=support_region,
      content=content.body + " " + content.cta,
      style=body_style,
    ).iter(),
  )
  .push(
    @scene.Element::Text(
      id="quote-footer",
      content=content.footer,
      position=@scene.Point::at(
        sections[2].x,
        sections[2].y + sections[2].height - 18,
      ),
      style=caption_style(theme),
      max_width=support_region.width,
    ),
  )
  .push(
    @scene.Element::ImageSlot(
      id="quote-portrait",
      asset_id=content.image_asset_id,
      rect=portrait_rect,
      label=content.image_label,
      fit=@scene.ImageFit::Cover,
    ),
  )
}

///|
fn digest_layout(
  preset : @preset.PosterPreset,
  theme : @theme.Theme,
  content : TemplateContent,
) -> @scene.PosterDocument {
  let frame = canvas_frame(preset).inset(theme.padding)
  let grid = @layout.grid(region=frame, spec=@layout.GridSpec::{
    columns: 2,
    rows: 3,
    gap_x: 24,
    gap_y: 24,
    padding: @core.EdgeInsets::zero(),
  })
  let lead : @scene.Rect = {
    x: grid[0].x,
    y: grid[0].y,
    width: grid[0].width,
    height: grid[0].height + 24 + grid[2].height,
  }
  let hero : @scene.Rect = {
    x: grid[1].x,
    y: grid[0].y,
    width: grid[1].width,
    height: grid[1].height + 24 + grid[3].height,
  }
  let footer : @scene.Rect = {
    x: grid[4].x,
    y: grid[4].y,
    width: grid[4].width + 24 + grid[5].width,
    height: grid[4].height,
  }
  let document = @scene.PosterDocument::empty(
    title=content.title,
    preset~,
    theme~,
  )
  let headline_style = {
    ..@scene.TextStyle::display(theme),
    size: theme.title_size + 4,
    line_height: theme.title_size + 20,
    color: theme.accent,
  }
  let body_style = @scene.TextStyle::body(theme)
  document
  .push(
    @scene.Element::Block(
      id="digest-shell",
      rect=frame,
      fill=@theme.Color::hex("#fffef8"),
      radius=32,
    ),
  )
  .push(
    @scene.Element::ImageSlot(
      id="digest-hero",
      asset_id=content.image_asset_id,
      rect=hero,
      label=content.image_label,
      fit=@scene.ImageFit::Cover,
    ),
  )
  .push(
    @scene.Element::Text(
      id="digest-eyebrow",
      content=content.eyebrow,
      position=@scene.Point::at(lead.x, lead.y + theme.caption_size),
      style=eyebrow_style(theme),
      max_width=lead.width,
    ),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="digest-title",
      region={ x: lead.x, y: lead.y + 48, width: lead.width, height: 220 },
      content=content.title,
      style=headline_style,
    ).iter(),
  )
  .push_iter(
    @textflow.paragraph_to_elements(
      id_prefix="digest-summary",
      region={
        x: lead.x,
        y: lead.y + 280,
        width: lead.width,
        height: lead.height - 280,
      },
      content=content.subtitle + " " + content.body,
      style=body_style,
    ).iter(),
  )
  .push(
    @scene.Element::Block(
      id="digest-footer-panel",
      rect=footer,
      fill=@theme.Color::hex("#111111"),
      radius=24,
    ),
  )
  .push(
    @scene.Element::Text(
      id="digest-cta",
      content=content.cta,
      position=@scene.Point::at(
        footer.x + 28,
        footer.y + theme.caption_size + 8,
      ),
      style={ ..eyebrow_style(theme), color: @theme.Color::hex("#ffffff") },
      max_width=footer.width - 56,
    ),
  )
  .push(
    @scene.Element::Text(
      id="digest-footer",
      content=content.footer,
      position=@scene.Point::at(footer.x + 28, footer.y + 86),
      style={ ..caption_style(theme), color: @theme.Color::hex("#f3f3f3") },
      max_width=footer.width - 56,
    ),
  )
}

///|
pub fn render_template(
  template~ : String,
  preset~ : @preset.PosterPreset,
  theme~ : @theme.Theme,
  content~ : TemplateContent,
) -> @scene.PosterDocument {
  match template {
    "digest" => digest_layout(preset, theme, content)
    "editorial" => editorial_layout(preset, theme, content)
    "event" => event_layout(preset, theme, content)
    "quote" => quote_layout(preset, theme, content)
    _ => launch_layout(preset, theme, content)
  }
}
