///|
pub(all) enum ImageFormat {
  Png
  Jpeg
  Unknown
} derive(Debug, Eq)

///|
pub(all) struct AssetSize {
  width : Int
  height : Int
} derive(Debug, Eq)

///|
pub(all) struct ImageInfo {
  format : ImageFormat
  size : AssetSize
  bit_depth : Int
  color_type : Int
  byte_length : Int
} derive(Debug, Eq)

///|
pub(all) enum AssetError {
  Empty
  Truncated
  InvalidSignature
  InvalidHeader
  InvalidDimensions
  UnsupportedFormat
} derive(Debug, Eq)

///|
pub(all) enum FitMode {
  Contain
  Cover
} derive(Debug, Eq)

///|
pub(all) struct FittedRect {
  width : Int
  height : Int
  offset_x : Int
  offset_y : Int
} derive(Debug, Eq)

///|
fn byte_at(bytes : Array[Byte], index : Int) -> Int {
  bytes[index].to_int()
}

///|
fn read_u16(bytes : Array[Byte], index : Int) -> Int {
  byte_at(bytes, index) * 256 + byte_at(bytes, index + 1)
}

///|
fn read_u32(bytes : Array[Byte], index : Int) -> Int {
  byte_at(bytes, index) * 16777216 +
  byte_at(bytes, index + 1) * 65536 +
  byte_at(bytes, index + 2) * 256 +
  byte_at(bytes, index + 3)
}

///|
fn is_png(bytes : Array[Byte]) -> Bool {
  bytes.length() >= 8 &&
  byte_at(bytes, 0) == 137 &&
  byte_at(bytes, 1) == 80 &&
  byte_at(bytes, 2) == 78 &&
  byte_at(bytes, 3) == 71 &&
  byte_at(bytes, 4) == 13 &&
  byte_at(bytes, 5) == 10 &&
  byte_at(bytes, 6) == 26 &&
  byte_at(bytes, 7) == 10
}

///|
fn is_jpeg(bytes : Array[Byte]) -> Bool {
  bytes.length() >= 2 && byte_at(bytes, 0) == 255 && byte_at(bytes, 1) == 216
}

///|
fn parse_png(bytes : Array[Byte]) -> Result[ImageInfo, AssetError] {
  if bytes.length() < 29 {
    Err(Truncated)
  } else if read_u32(bytes, 8) != 13 ||
    byte_at(bytes, 12) != 73 ||
    byte_at(bytes, 13) != 72 ||
    byte_at(bytes, 14) != 68 ||
    byte_at(bytes, 15) != 82 {
    Err(InvalidHeader)
  } else {
    let width = read_u32(bytes, 16)
    let height = read_u32(bytes, 20)
    let bit_depth = byte_at(bytes, 24)
    let color_type = byte_at(bytes, 25)
    if width <= 0 || height <= 0 {
      Err(InvalidDimensions)
    } else if bit_depth <= 0 {
      Err(InvalidHeader)
    } else {
      Ok({
        format: Png,
        size: { width, height },
        bit_depth,
        color_type,
        byte_length: bytes.length(),
      })
    }
  }
}

///|
fn parse_jpeg(bytes : Array[Byte]) -> Result[ImageInfo, AssetError] {
  if bytes.length() < 4 {
    Err(Truncated)
  } else {
    let mut index = 2
    let mut found : ImageInfo? = None
    while index + 3 < bytes.length() && found is None {
      if byte_at(bytes, index) != 255 {
        return Err(InvalidHeader)
      }
      let marker = byte_at(bytes, index + 1)
      if marker == 216 || marker == 217 {
        index += 2
      } else {
        let length = read_u16(bytes, index + 2)
        if length < 2 || index + 2 + length > bytes.length() {
          return Err(Truncated)
        } else if marker >= 192 && marker <= 195 {
          if length < 7 {
            return Err(InvalidHeader)
          }
          let height = read_u16(bytes, index + 5)
          let width = read_u16(bytes, index + 7)
          if width <= 0 || height <= 0 {
            return Err(InvalidDimensions)
          }
          found = Some({
            format: Jpeg,
            size: { width, height },
            bit_depth: byte_at(bytes, index + 4),
            color_type: 0,
            byte_length: bytes.length(),
          })
        } else {
          index += 2 + length
        }
      }
    }
    match found {
      Some(info) => Ok(info)
      None => Err(InvalidHeader)
    }
  }
}

///|
/// Parse trusted dimensions from PNG or JPEG headers without decoding pixels.
pub fn parse_image_info(bytes : Array[Byte]) -> Result[ImageInfo, AssetError] {
  if bytes.is_empty() {
    Err(Empty)
  } else if is_png(bytes) {
    parse_png(bytes)
  } else if is_jpeg(bytes) {
    parse_jpeg(bytes)
  } else {
    Err(UnsupportedFormat)
  }
}

///|
/// Compute an integer fit rectangle while preserving the source aspect ratio.
pub fn fit_rect(
  source : AssetSize,
  target : AssetSize,
  mode : FitMode,
) -> FittedRect {
  if source.width <= 0 ||
    source.height <= 0 ||
    target.width <= 0 ||
    target.height <= 0 {
    { width: 0, height: 0, offset_x: 0, offset_y: 0 }
  } else {
    let contain = source.width * target.height <= target.width * source.height
    let use_width = match mode {
      Contain => !contain
      Cover => contain
    }
    let (width, height) = if use_width {
      let width = target.width
      let height = source.height * width / source.width
      (width, height)
    } else {
      let height = target.height
      let width = source.width * height / source.height
      (width, height)
    }
    {
      width,
      height,
      offset_x: (target.width - width) / 2,
      offset_y: (target.height - height) / 2,
    }
  }
}
