# Contributing

## Development setup

Install the current MoonBit stable toolchain and run:

~~~bash
moon update
moon check --deny-warn --target all
moon test --deny-warn --target all
moon fmt --check
moon info
~~~

The native CLI is used for filesystem and benchmark smoke tests. Keep fixtures deterministic and do not require network access during tests.

## Code guidelines

- Keep new behavior in the package that owns it.
- Preserve existing public APIs unless a compatibility change is explicitly reviewed.
- Add a focused test for every new public function and every boundary condition.
- Keep SVG serialization deterministic: stable ordering, escaping, numeric formatting, and IDs.
- Do not add unknown-origin fonts, images, generated code, or copied implementations.
- Run `moon fmt` and inspect `moon info` changes before committing.

## Pull requests

Describe the user-facing behavior, tests run, target backends checked, and any benchmark command used. Generated files should be included only when produced by the current toolchain and reviewed for unintended API changes.
