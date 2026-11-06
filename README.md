# libspng-f

A Lean 4 verification project for libspng, starting with the default x86-64
build and the memory-buffer to RGBA8 decode path. The source is pinned as a
submodule. This project is work in progress: **libspng is not verified**.

The first result proves properties of a mathematical model of the RGBA8 image
size calculation. It is not yet a proof of the C implementation. See
[docs/overview.md](docs/overview.md) for the exact scope, assumptions and work
remaining, and [docs/trusted-base.md](docs/trusted-base.md) for trust boundaries.

After `git submodule update --init`, with Lean installed through elan, a C
compiler and zlib headers/library available, run:

```sh
scripts/check.sh
```

The test compiles on a 64-bit `size_t` target, including ARM64. Its result does
not establish x86-64 or SIMD coverage. The target for the eventual proof is
x86-64 Linux; the Lean model itself does not encode an operating system.
