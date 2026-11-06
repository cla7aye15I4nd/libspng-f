import LibspngF.Spng.Size

namespace LibspngF

/-- Under the C caller's positive-height precondition, a successful model
result is exactly the mathematical RGBA8 image size and fits in size_t. -/
theorem rgba8Size_sound (width height n : Nat) (hh : 0 < height)
    (h : rgba8Size width height = some n) :
    n = width * 4 * height ∧ n ≤ sizeMax := by
  unfold rgba8Size at h
  split at h
  · contradiction
  · dsimp only at h
    split at h
    · contradiction
    · rename_i hrow
      have hb : width * 4 ≤ sizeMax / height := Nat.le_of_not_gt hrow
      have hfit : width * 4 * height ≤ sizeMax :=
        (Nat.le_div_iff_mul_le hh).mp hb
      have hn : width * 4 * height = n := Option.some.inj h
      exact ⟨hn.symm, hn ▸ hfit⟩

/-- If the mathematical RGBA8 image size fits, neither modeled check rejects it.
The first check also matters independently when height is zero, excluded here. -/
theorem rgba8Size_complete (width height : Nat) (hh : 0 < height)
    (hfit : width * 4 * height ≤ sizeMax) :
    rgba8Size width height = some (width * 4 * height) := by
  have hrow : width * 4 ≤ sizeMax / height := (Nat.le_div_iff_mul_le hh).mpr hfit
  have hwidthmul : width * 4 ≤ sizeMax := by
    have h : width * 4 ≤ width * 4 * height := by
      simpa using Nat.mul_le_mul_left (width * 4) hh
    exact Nat.le_trans h hfit
  have hwidth : width ≤ sizeMax / 4 := (Nat.le_div_iff_mul_le (by decide)).mpr hwidthmul
  simp [rgba8Size, Nat.not_lt_of_ge hwidth, Nat.not_lt_of_ge hrow]

end LibspngF
