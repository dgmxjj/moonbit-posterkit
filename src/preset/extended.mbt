///|
pub fn PosterPreset::open_graph() -> PosterPreset {
  {
    name: "open-graph",
    canvas: { width: 1200, height: 630 },
    margin: @core.EdgeInsets::all(72),
  }
}

///|
pub fn PosterPreset::a4_portrait() -> PosterPreset {
  {
    name: "a4-portrait",
    canvas: { width: 1240, height: 1754 },
    margin: @core.EdgeInsets::all(96),
  }
}

///|
pub fn PosterPreset::linkedin_landscape() -> PosterPreset {
  {
    name: "linkedin-landscape",
    canvas: { width: 1200, height: 627 },
    margin: @core.EdgeInsets::all(72),
  }
}

///|
pub fn PosterPreset::portrait_card() -> PosterPreset {
  {
    name: "portrait-card",
    canvas: { width: 900, height: 1200 },
    margin: @core.EdgeInsets::all(72),
  }
}

///|
pub fn PosterPreset::landscape_card() -> PosterPreset {
  {
    name: "landscape-card",
    canvas: { width: 1600, height: 900 },
    margin: @core.EdgeInsets::all(96),
  }
}

///|
pub fn PosterPreset::area(self : PosterPreset) -> Int {
  self.canvas.width * self.canvas.height
}

///|
pub fn PosterPreset::is_portrait(self : PosterPreset) -> Bool {
  self.canvas.height > self.canvas.width
}

///|
pub fn PosterPreset::is_landscape(self : PosterPreset) -> Bool {
  self.canvas.width > self.canvas.height
}

///|
pub fn PosterPreset::describe(self : PosterPreset) -> String {
  self.name +
  " " +
  self.canvas.width.to_string() +
  "x" +
  self.canvas.height.to_string() +
  " margin=" +
  self.margin.left.to_string() +
  " ratio=" +
  self.aspect_ratio_label()
}

///|
pub fn all_extended_presets() -> Array[PosterPreset] {
  [
    PosterPreset::instagram_square(),
    PosterPreset::social_story(),
    PosterPreset::youtube_thumbnail(),
    PosterPreset::open_graph(),
    PosterPreset::a4_portrait(),
    PosterPreset::linkedin_landscape(),
    PosterPreset::portrait_card(),
    PosterPreset::landscape_card(),
  ]
}
