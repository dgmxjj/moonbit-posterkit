pub(all) struct PosterPreset {
  name : String
  canvas : @core.Size
  margin : @core.EdgeInsets
} derive(Debug, Eq)

fn gcd(left : Int, right : Int) -> Int {
  if right == 0 {
    left.abs()
  } else {
    gcd(right, left % right)
  }
}

pub fn PosterPreset::safe_area(self : PosterPreset) -> @core.EdgeInsets {
  self.margin
}

pub fn PosterPreset::aspect_ratio_label(self : PosterPreset) -> String {
  let divisor = gcd(self.canvas.width, self.canvas.height)
  let width = self.canvas.width / divisor
  let height = self.canvas.height / divisor
  width.to_string() + ":" + height.to_string()
}

pub fn PosterPreset::instagram_square() -> PosterPreset {
  {
    name: "instagram-square",
    canvas: @core.Size::square(1080),
    margin: @core.EdgeInsets::all(96),
  }
}

pub fn PosterPreset::youtube_thumbnail() -> PosterPreset {
  {
    name: "youtube-thumbnail",
    canvas: { width: 1280, height: 720 },
    margin: @core.EdgeInsets::all(72),
  }
}

pub fn PosterPreset::social_story() -> PosterPreset {
  {
    name: "social-story",
    canvas: { width: 1080, height: 1920 },
    margin: @core.EdgeInsets::all(84),
  }
}
