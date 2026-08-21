///|
pub fn clamp_int(value : Int, minimum : Int, maximum : Int) -> Int {
  if minimum > maximum {
    Int::clamp(value, min=maximum, max=minimum)
  } else {
    Int::clamp(value, min=minimum, max=maximum)
  }
}

///|
pub fn sum_ints(values : Array[Int]) -> Int {
  values.fold(init=0, (sum, value) => sum + value)
}

///|
pub fn average_ints(values : Array[Int]) -> Int {
  if values.is_empty() {
    0
  } else {
    sum_ints(values) / values.length()
  }
}

///|
pub fn min_int(values : Array[Int]) -> Int? {
  if values.is_empty() {
    None
  } else {
    let mut result = values[0]
    for i = 1; i < values.length(); i = i + 1 {
      result = Int::min(result, values[i])
    }
    Some(result)
  }
}

///|
pub fn max_int(values : Array[Int]) -> Int? {
  if values.is_empty() {
    None
  } else {
    let mut result = values[0]
    for i = 1; i < values.length(); i = i + 1 {
      result = Int::max(result, values[i])
    }
    Some(result)
  }
}

///|
pub fn repeat_string(value : String, count : Int) -> String {
  value.repeat(Int::max(count, 0))
}

///|
pub fn join_non_empty(values : Array[String], separator : String) -> String {
  values.filter(value => !value.trim().is_empty()).join(separator)
}

///|
pub fn safe_filename(value : String, fallback : String) -> String {
  let cleaned = value.trim().to_owned().replace_all(old=" ", new="-")
  if cleaned.is_empty() {
    fallback
  } else {
    cleaned
  }
}
