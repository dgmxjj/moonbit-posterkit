///|
pub(all) struct TemplateInfo {
  name : String
  summary : String
  default_preset : String
  default_theme : String
  supported_presets : Array[String]
  supported_themes : Array[String]
} derive(Debug, Eq, ToJson)

///|
pub(all) struct PresetInfo {
  name : String
  summary : String
  width : Int
  height : Int
  safe_margin : Int
  aspect_ratio : String
} derive(Debug, Eq, ToJson)

///|
pub(all) struct ThemeInfo {
  name : String
  summary : String
  background : String
  foreground : String
  accent : String
  padding : Int
  title_size : Int
  body_size : Int
} derive(Debug, Eq, ToJson)
