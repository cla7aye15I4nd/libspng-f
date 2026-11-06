# Trust boundary

The two initial theorems depend on Lean's kernel and the axioms reported by
`tests/Audit.lean`. They establish properties only of `rgba8Size`, an unbounded
natural-number model. No C semantics, compiler correctness, heap, allocator,
zlib, SSE2 or PNG parsing has been proved or connected to those theorems.

The correspondence of the model and the pinned C is a manual observation, not
a theorem. The C test gives finite evidence for the arithmetic behavior only;
it cannot establish correspondence for all inputs. As implementation proofs
are added, record their precise semantics, assumptions and trusted components
here, and audit them independently.
