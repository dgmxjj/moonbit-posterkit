///|
pub(all) struct PackInfo {
  name : String
  summary : String
  jobs : Int
  templates : Array[String]
  presets : Array[String]
  themes : Array[String]
} derive(Debug, Eq, ToJson)
