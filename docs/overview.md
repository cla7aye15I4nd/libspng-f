# Scope and status

Status: initial pilot. No complete API, decoder, SIMD implementation or zlib
integration is proved. The source submodule is pinned at
`46c81dc2b3747fa43aac33704c890a468f195d6e`; the intended target is an x86-64
Linux build with the upstream default architecture optimizations and zlib.
The exact compiler and zlib version still have to be pinned before a claim
about a concrete build. The first path is buffer input, default allocator,
RGBA8 output, flags 0 and default decoder options. Later work must cover the
input PNG formats and Adam7 interlacing accepted by that path. Arbitrary bytes,
not merely valid PNG files, are in the intended input domain.

## First checked model

`LibspngF/Spng/Size.lean` models the arithmetic and error decisions of the
RGBA8 branch of `calculate_image_width` and `calculate_image_size`: 64-bit
`size_t`, non-null valid arguments and positive height. The model uses `Nat`,
not machine integers or a C heap. Its parameters are not bounded to uint32_t;
the theorem is stronger for these arithmetic inputs, but that is not a claim
about C calls outside uint32_t. It does not represent the output pointer, its
contents on failure, other formats, or errors from other stages.

`rgba8Size_sound` proves successful results equal width * 4 * height and fit in
size_t. `rgba8Size_complete` proves the model accepts whenever that size fits,
for positive height. These are kernel-checked facts about the model; no formal
connection to C has been established. In particular, the source code's division
by height requires establishing positive height from the actual caller state.

`tests/size.c` calls the actual static C helper on boundary and deterministic
sample inputs and compares with 128-bit arithmetic. It is a test of C behavior,
not a proof of translation fidelity or of the rest of the decoder. It does not
execute the Lean model directly. `tests/Audit.lean` reports theorem axioms; it is
not yet an automated axiom allowlist or a zlib-f-style full audit.

## Next work

1. Formalize or reuse the zlib-f runtime after reviewing compatibility and
   licensing; translate the actual RGBA8 helpers including pointers, uint32_t,
   size_t, return codes and write effects. Prove the model corresponds to it.
2. Prove positive height and the remaining helper preconditions from the actual
   input parser and context state; validate failure paths and allocator behavior.
3. Specify and then prove the buffer-based decode API sequence against arbitrary
   bytes, including all supported input formats and Adam7. Model zlib and libc
   calls explicitly and list every unproved assumption.
4. Cover the actual default x86-64 SSE2 paths; only then make a claim about the
   default optimized build. Pin the compiler, target ABI and zlib revision.
5. Add statement/axiom audits, translation checks, differential and mutation
   tests and CI before claiming completed verification.
