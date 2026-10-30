# falcon-starknet-poseidon

Falcon-512 verification on Starknet with a **Poseidon hash-to-point** (~5.18M L2 gas), and **dual signing**: one standard Falcon-512 key signs each message both with standard SHAKE256 (verifiable by PQClean / falcon.py) and with Poseidon (cheap on Starknet).

*BEARTEC / Falcon PL — falcon-fpl.com. Research prototype.*

## ⚠️ Read first: caveats
- **Not audited. Not for production.** Neither this code, the base, nor the challenge record it builds on has been audited.
- **Non-standard.** Poseidon hash-to-point is **not FIPS 206 / Falcon round 3**. Poseidon-mode signatures do not verify with standard Falcon libraries. Only the SHAKE mode is standard.
- **Extra assumption.** Poseidon mode's security relies on Poseidon behaving as a random oracle (in addition to Falcon's own assumptions). A key used in both modes is only as strong as the weaker hash *for verifiers that accept Poseidon mode*.
- **Fix the mode per contract.** Never let the caller pick the mode for a contract that expects one.
- **Never reuse salts**, across modes or signatures.
- **Outside the Starknet Falcon Challenge rules** (which require SHAKE256). This is not a record claim and was not submitted.

## Results (measured, snforge 0.59.0 / Scarb 2.18.0; L2 gas incl. ~27k fixture construction)
| | mean L2 gas | sigs |
|---|---|---|
| Challenge record (SHAKE256) | 24,097,870 | record's bench |
| Dual entry, mode 0 (SHAKE256, record code) | 23,585,028 (23.18M–24.78M) | 8 |
| Dual entry, mode 1 (Poseidon, tagged v1) | **5,181,118** (5.178M–5.185M) | 8 |

Poseidon mode: **−78.5%** vs the record. Poseidon hash-to-point alone ≈1.4M; implied SHAKE256 share of the record ≈20.3M (total minus measured core ≈3.73M). The OpenZeppelin repo's own (untagged) Poseidon verifier measured 10.10–10.20M on comparable signatures; the saving over it comes from the record's optimised NTT/hint core.

Run `./reproduce.sh` to regenerate everything (installs pinned toolchain, builds PQClean verifier, checks all vectors, runs all tests, prints the gas table).

## Construction (Poseidon hash-to-point v1)
```
t = hades(salt_a, salt_b, TAG)          # TAG = short string 'FALCON512-POSEIDON-H2P-v1'
s = hades(t0 + message_hash, t1, t2)
repeat: for felt in (s0, s1): 15 low 16-bit words w; accept w < 61445 (=5q), coeff = w mod q
        s = hades(s)  until 512 coefficients
```
- salts are 2 × 20 bytes (< 2^160 each, enforced), i.e. the standard 40-byte Falcon salt.
- 61445 = 5q, so accepted words are exactly uniform mod q = 12289; the low 240 bits of a field element are uniform up to ~2^-11 statistical distance per felt.
- Cairo: `crates/falcon_512/src/hashing/hash_to_point.cairo` (`hash_to_point_poseidon_raw`), Python: `tools/dualsign/dualsign.py` (`h2p_poseidon_v1`).
- Verifiers: `Falcon512ShakeVerifier` (record), `Falcon512PoseidonRecVerifier`, and `falcon512_dual_verify(mode, msg, pk, sig)` (0 = SHAKE, 1 = Poseidon, other = reject) in `crates/falcon_512/src/lib.cairo`.

## Dual signing
`tools/dualsign/dualsign.py keygen DIR | sign DIR MSG_FELT OUT | verify DIR OUT [--pqclean BIN] | cairo DIR OUT NAME FILE`
- One tprest/falcon.py key pair; public key emitted as 897-byte standard encoding (`pk.bin`) and 29-felt Cairo encoding (`pk.json`).
- `sign` draws two independent 40-byte salts and writes a standard detached SHAKE signature (`0x39 || salt || compressed s1`) plus Cairo felts for both modes. The secret key is stored mode 0600 and never printed; **no secret keys are in this repo**.
- Security: with independent salts the two signatures are Gaussian preimages of independent random-oracle targets, equivalent to signing two different messages, which Falcon's GPV-style security covers.

## Tests
- `vectors/v0..v7` (2 keys × 4 messages, public only): PQClean C verifier, falcon.py and the Python Cairo-equation check accept all; tampered PQClean signature rejected.
- `crates/falcon_512/tests/bench_dual.cairo`: valid × 8 per mode; mode swaps both ways, wrong key per mode, tampered message, invalid mode → rejected; an **untagged** Poseidon signature (OpenZeppelin's original Poseidon fixture) is rejected by the tagged verifier.
- Full upstream test suite still passes (the upstream `pq-accounts/` demo — devnet/Sepolia tooling and a public insecure demo key — is omitted from this repo).

## Prior art
ZKNox **ETHFALCON** replaces SHAKE with a Keccak-based PRNG for EVM gas. This is the Starknet analogue with Poseidon, plus dual signing so one standard key remains interoperable.

## Use cases
Post-quantum Starknet account-abstraction wallets (Falcon in `__validate__` at ~5.2M gas); Falcon PL committee signatures relayed to Starknet (standard SHAKE signature for everyone else, Poseidon signature for cheap on-chain checks).

## Licence
MIT (see `LICENSE`); attribution in `NOTICE.md`.
