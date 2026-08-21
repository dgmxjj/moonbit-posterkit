///|
test "metrics helpers calculate rates and averages" {
  let metrics = metrics_from_sizes([100, 200, 300])
  inspect(success_rate_percent(metrics), content="100")
  inspect(metrics.average_svg_bytes, content="200")
  inspect(metrics_is_consistent(metrics), content="true")
  inspect(metrics_summary(metrics).contains("bytes=600"), content="true")
}

///|
test "metrics merge preserves totals and recomputes average" {
  let left = metrics_from_sizes([100, 200])
  let right = metrics_from_sizes([300])
  let merged = merge_metrics(left, right)
  inspect(merged.total, content="3")
  inspect(merged.total_svg_bytes, content="600")
  inspect(merged.average_svg_bytes, content="200")
  inspect(success_rate_percent(BatchMetrics::empty(4)), content="0")
}

///|
test "metrics empty sizes are consistent" {
  let metrics = metrics_from_sizes([])
  inspect(metrics.total, content="0")
  inspect(metrics.total_svg_bytes, content="0")
  inspect(metrics.average_svg_bytes, content="0")
  inspect(metrics_is_consistent(metrics), content="true")
  inspect(success_rate_percent(metrics), content="0")
}

///|
test "metrics clamp negative byte samples" {
  let metrics = metrics_from_sizes([-1, 10, -20])
  inspect(metrics.total, content="3")
  inspect(metrics.total_svg_bytes, content="10")
  inspect(metrics.average_svg_bytes, content="3")
  inspect(metrics_is_consistent(metrics), content="true")
}

///|
test "metrics success rate uses integer percentage" {
  let metrics : BatchMetrics = {
    total: 3,
    succeeded: 2,
    failed: 1,
    total_svg_bytes: 30,
    average_svg_bytes: 15,
  }
  inspect(success_rate_percent(metrics), content="66")
  inspect(metrics_is_consistent(metrics), content="true")
  inspect(metrics_summary(metrics).contains("success_rate=66%"), content="true")
}

///|
test "metrics merge empty sides is identity" {
  let value = metrics_from_sizes([7, 13])
  let empty = BatchMetrics::empty(0)
  let merged_left = merge_metrics(empty, value)
  let merged_right = merge_metrics(value, empty)
  inspect(merged_left.total, content="2")
  inspect(merged_right.total, content="2")
  inspect(merged_left.total_svg_bytes, content="20")
  inspect(merged_right.total_svg_bytes, content="20")
  inspect(merged_left.average_svg_bytes, content="10")
  inspect(merged_right.average_svg_bytes, content="10")
}

///|
test "metrics merge keeps failed counts" {
  let left : BatchMetrics = {
    total: 4,
    succeeded: 3,
    failed: 1,
    total_svg_bytes: 40,
    average_svg_bytes: 13,
  }
  let right : BatchMetrics = {
    total: 2,
    succeeded: 1,
    failed: 1,
    total_svg_bytes: 10,
    average_svg_bytes: 10,
  }
  let merged = merge_metrics(left, right)
  inspect(merged.total, content="6")
  inspect(merged.succeeded, content="4")
  inspect(merged.failed, content="2")
  inspect(merged.total_svg_bytes, content="50")
  inspect(metrics_is_consistent(merged), content="true")
}

///|
test "metrics summary exposes every stable field" {
  let metrics = metrics_from_sizes([1])
  let summary = metrics_summary(metrics)
  inspect(summary.contains("total=1"), content="true")
  inspect(summary.contains("succeeded=1"), content="true")
  inspect(summary.contains("failed=0"), content="true")
  inspect(summary.contains("bytes=1"), content="true")
  inspect(summary.contains("average=1"), content="true")
  inspect(summary.contains("success_rate=100%"), content="true")
}

///|
test "metrics zero success avoids division by zero" {
  let metrics : BatchMetrics = {
    total: 5,
    succeeded: 0,
    failed: 5,
    total_svg_bytes: 0,
    average_svg_bytes: 0,
  }
  inspect(success_rate_percent(metrics), content="0")
  inspect(metrics_summary(metrics).contains("average=0"), content="true")
  inspect(metrics_is_consistent(metrics), content="true")
}

///|
test "metrics consistency rejects mismatched result counts" {
  let invalid : BatchMetrics = {
    total: 2,
    succeeded: 2,
    failed: 1,
    total_svg_bytes: 1,
    average_svg_bytes: 0,
  }
  inspect(metrics_is_consistent(invalid), content="false")
}

///|
test "metrics consistency rejects negative totals" {
  let invalid : BatchMetrics = {
    total: -1,
    succeeded: 0,
    failed: 0,
    total_svg_bytes: 0,
    average_svg_bytes: 0,
  }
  inspect(metrics_is_consistent(invalid), content="false")
}
