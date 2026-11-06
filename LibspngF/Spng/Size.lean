import Std

/-! A mathematical model of the RGBA8 branch of calculate_image_width and
calculate_image_size in the pinned spng.c. This is not a C semantics or a
verified translation. Preconditions and fidelity limitations are in docs/overview.md. -/
namespace LibspngF

/-- The range of a 64-bit C size_t. -/
def sizeMax : Nat := 2^64 - 1

/-- The two C overflow checks for non-null arguments, RGBA8 and positive height.
The caller must additionally ensure that width and height are representable in
uint32_t. On error, `none` does not model C's output-pointer contents. -/
def rgba8Size (width height : Nat) : Option Nat :=
  if width > sizeMax / 4 then none
  else
    let row := width * 4
    if row > sizeMax / height then none
    else some (row * height)

end LibspngF
