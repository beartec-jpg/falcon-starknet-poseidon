# Poseidon-path tuning log (snforge 0.59.0, L2 gas)

Hash-to-point alone (fixture d0, includes ~30k test setup):

| Variant | h2p gas | Δ | Construction change? | Adopted |
|---|---|---|---|---|
| v1 baseline (per-word `len()==512` guard) | 1,424,880 | — | — | — |
| **No per-word length guard** (let the last block overshoot; `et` takes the first 512) | **1,258,290** | **−166,590** | no (same point, same signatures) | **yes** |
| + single permutation with tag in salt_a's high bits (`salt_a + 'FPH2P-v2'·2^160`) | 1,256,999 | −1,291 | yes (would need v2 + new vectors) | no: saving 0.03%, not worth a new construction |
| Drop the 2^160 salt range checks | 1,251,630 | −6,660 | no | no: keeps salts canonical 40-byte Falcon salts; 0.13% |

Full verify, 8 vectors, dual entry mode 1: 5,181,117 → **5,013,399** mean (−3.24%), −79.20% vs record 24,097,870.

Rejected without implementation (analysis):
- **Squeezing the third (capacity) state element.** The capacity is what makes the sponge indifferentiable from a random oracle; outputting it exposes the full state, so the next block becomes a public function of known values. That is fine for a pure XOF only if nobody needs the security argument, and we do. Gain would be at most one permutation per 3 felts (permutations cost ~1.3k each, ~25k total), so it is also not worth it.
- **More bits per felt.** The high u128 of a felt is below 2^123, so 15 full 16-bit words (240 bits) is the maximum; a 16th word would be heavily biased.
- **14-bit words.** Accept 12289/16384 = 75.0% vs 61445/65536 = 93.8% for 16-bit words: 1.33 vs 1.07 extracted words per coefficient, and per-word extraction (division + range check + append) dominates cost, so ~25% more work. Worse.
- **`poseidon_hash_many`** pads and absorbs in a fixed way and still needs a squeeze loop; no saving over raw `hades_permutation`.
- **Core changes.** Poseidon-mode coefficients have the same range (< 5q, unreduced) as the record's SHAKE path, so the core has no Poseidon-specific shortcut.
