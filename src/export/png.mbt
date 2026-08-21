///|
pub enum PngError {
  InvalidDimensions
  InvalidPixelLength
} derive(Debug, Eq)

///|
pub(all) struct PngImage {
  width : Int
  height : Int
  pixels : Array[Byte]
} derive(Debug, Eq)

///|
fn png_byte(value : Int) -> Byte {
  value.to_byte()
}

///|
/// Construct an RGBA image with four bytes per pixel.
pub fn PngImage::rgba(
  width : Int,
  height : Int,
  pixels : Array[Byte],
) -> Result[PngImage, PngError] {
  if width <= 0 || height <= 0 || width > 8192 || height > 8192 {
    Err(InvalidDimensions)
  } else if pixels.length() != width * height * 4 {
    Err(InvalidPixelLength)
  } else {
    Ok({ width, height, pixels })
  }
}

///|
fn push_u32(target : Array[Byte], value : Int) -> Unit {
  target.push(png_byte(value >> 24))
  target.push(png_byte(value >> 16))
  target.push(png_byte(value >> 8))
  target.push(png_byte(value))
}

///|
fn crc32(bytes : Array[Byte]) -> Int {
  let mut crc = -1
  bytes.each(byte => {
    crc = Int::lxor(crc, byte.to_int())
    for _ in 0..<8 {
      let mask = if Int::land(crc, 1) == 1 { -306674912 } else { 0 }
      crc = Int::lxor(crc >> 1, mask)
    }
  })
  Int::lxor(crc, -1)
}

///|
fn adler32(bytes : Array[Byte]) -> Int {
  let mut a = 1
  let mut b = 0
  bytes.each(byte => {
    a = (a + byte.to_int()) % 65521
    b = (b + a) % 65521
  })
  (b << 16) + a
}

///|
fn append_bytes(target : Array[Byte], source : Array[Byte]) -> Unit {
  source.each(byte => target.push(byte))
}

///|
fn make_chunk(kind : Array[Byte], data : Array[Byte]) -> Array[Byte] {
  let result : Array[Byte] = []
  push_u32(result, data.length())
  kind.each(byte => result.push(byte))
  data.each(byte => result.push(byte))
  let checksum : Array[Byte] = []
  kind.each(byte => checksum.push(byte))
  data.each(byte => checksum.push(byte))
  push_u32(result, crc32(checksum))
  result
}

///|
fn raw_scanlines(image : PngImage) -> Array[Byte] {
  let raw : Array[Byte] = []
  for row in 0..<image.height {
    raw.push(png_byte(0))
    let start = row * image.width * 4
    for column in 0..<(image.width * 4) {
      raw.push(image.pixels[start + column])
    }
  }
  raw
}

///|
fn zlib_stored(raw : Array[Byte]) -> Array[Byte] {
  let result : Array[Byte] = [png_byte(120), png_byte(1)]
  let mut offset = 0
  if raw.is_empty() {
    result.push(png_byte(1))
    result.push(png_byte(0))
    result.push(png_byte(255))
    result.push(png_byte(255))
  } else {
    while offset < raw.length() {
      let remaining = raw.length() - offset
      let size = if remaining > 65535 { 65535 } else { remaining }
      let final_block = if offset + size == raw.length() { 1 } else { 0 }
      result.push(png_byte(final_block))
      result.push(png_byte(size))
      result.push(png_byte(size >> 8))
      let inverse = 65535 - size
      result.push(png_byte(inverse))
      result.push(png_byte(inverse >> 8))
      for index in 0..<size {
        result.push(raw[offset + index])
      }
      offset += size
    }
  }
  push_u32(result, adler32(raw))
  result
}

///|
/// Encode an RGBA image as a deterministic PNG file.
pub fn encode_png(image : PngImage) -> Array[Byte] {
  let result : Array[Byte] = [
    png_byte(137),
    png_byte(80),
    png_byte(78),
    png_byte(71),
    png_byte(13),
    png_byte(10),
    png_byte(26),
    png_byte(10),
  ]
  let header : Array[Byte] = []
  push_u32(header, image.width)
  push_u32(header, image.height)
  header.push(png_byte(8))
  header.push(png_byte(6))
  header.push(png_byte(0))
  header.push(png_byte(0))
  header.push(png_byte(0))
  append_bytes(
    result,
    make_chunk([png_byte(73), png_byte(72), png_byte(68), png_byte(82)], header),
  )
  append_bytes(
    result,
    make_chunk(
      [png_byte(73), png_byte(68), png_byte(65), png_byte(84)],
      zlib_stored(raw_scanlines(image)),
    ),
  )
  append_bytes(
    result,
    make_chunk([png_byte(73), png_byte(69), png_byte(78), png_byte(68)], []),
  )
  result
}
