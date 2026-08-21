///|
pub fn success_rate_percent(metrics : BatchMetrics) -> Int {
  if metrics.total <= 0 {
    0
  } else {
    metrics.succeeded * 100 / metrics.total
  }
}

///|
pub fn metrics_summary(metrics : BatchMetrics) -> String {
  "total=" +
  metrics.total.to_string() +
  ",succeeded=" +
  metrics.succeeded.to_string() +
  ",failed=" +
  metrics.failed.to_string() +
  ",bytes=" +
  metrics.total_svg_bytes.to_string() +
  ",average=" +
  metrics.average_svg_bytes.to_string() +
  ",success_rate=" +
  success_rate_percent(metrics).to_string() +
  "%"
}

///|
pub fn merge_metrics(left : BatchMetrics, right : BatchMetrics) -> BatchMetrics {
  let total = left.total + right.total
  let succeeded = left.succeeded + right.succeeded
  let bytes = left.total_svg_bytes + right.total_svg_bytes
  {
    total,
    succeeded,
    failed: left.failed + right.failed,
    total_svg_bytes: bytes,
    average_svg_bytes: if succeeded == 0 {
      0
    } else {
      bytes / succeeded
    },
  }
}

///|
pub fn metrics_from_sizes(sizes : Array[Int]) -> BatchMetrics {
  let total = sizes.length()
  let bytes = sizes.fold(init=0, (sum, value) => sum + Int::max(value, 0))
  {
    total,
    succeeded: total,
    failed: 0,
    total_svg_bytes: bytes,
    average_svg_bytes: if total == 0 {
      0
    } else {
      bytes / total
    },
  }
}

///|
pub fn metrics_is_consistent(metrics : BatchMetrics) -> Bool {
  metrics.total >= 0 &&
  metrics.succeeded >= 0 &&
  metrics.failed >= 0 &&
  metrics.succeeded + metrics.failed == metrics.total &&
  metrics.total_svg_bytes >= 0 &&
  metrics.average_svg_bytes >= 0
}
