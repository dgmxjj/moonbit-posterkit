# Benchmarks

The benchmark command uses committed JSON fixtures and reports deterministic workload counters:

~~~bash
moon run --target native src/cli benchmark examples/benchmarks/batch-10.json 3
~~~

The output includes iterations, jobs, successful renders, SVG bytes per iteration, and repeated measured bytes. Wall-clock numbers depend on the host and should be recorded with the exact MoonBit version, operating system, and command. Do not compare timings from different machines as a performance guarantee.

The fixtures exercise a small batch, mixed CJK/Latin text, and repeated campaign rendering. They contain no network URLs or local absolute paths.
