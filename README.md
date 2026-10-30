# falcon-starknet-poseidon

Falcon-512 signature verification on Starknet using a Poseidon hash-to-point. It costs about 5.0M L2 gas.

By BEARTEC / Falcon PL (falcon-fpl.com). This is a prototype and it is not audited.

## What this is

This builds on OpenZeppelin's cairo-pq-verifiers. That repo already has a Falcon-512 variant with a Poseidon hash-to-point at about 12.0M gas. It also uses the optimised code from the Starknet Falcon Challenge record, held by rukafe0x.

Our Poseidon variant measured a mean of 5,013,399 gas. That is about 2.4x cheaper than the OpenZeppelin Poseidon variant. Most of the saving comes from the record's faster core. For context the SHAKE256 challenge record is about 24.1M.

## Dual mode

One standard Falcon-512 key can sign a message two ways. Mode 0 uses standard SHAKE256 and checks against PQClean and falcon.py. Mode 1 uses Poseidon and is cheap on Starknet. The verifier accepts either.

Mode 0 measured about 23.6M gas and mode 1 about 5.01M gas, over 8 signatures each with snforge 0.59.0 and Scarb 2.18.0.

## Caveats

Poseidon mode is not standard Falcon. Its signatures do not verify with normal Falcon libraries. It also relies on Poseidon acting as a random oracle.

It is not eligible for the Falcon Challenge, since the rules require SHAKE256. We did not submit it. This is the same trade-off ZKNox made with ETHFALCON on the EVM.

Each contract should fix its mode and not let the caller choose. Never reuse a salt.

No secret keys are in this repo.

## Reproduce

This installs the pinned toolchain, builds the PQClean verifier, checks the vectors, runs the tests and prints the gas table.

```
./reproduce.sh
```

## How it works

The 40 byte Falcon salt is split into two 20 byte felts. These are hashed with a version tag, then with the message hash. Each Poseidon output felt gives 15 words of 16 bits. A word is kept if it is below 5q, and the coefficient is that word mod q. This repeats until there are 512 coefficients.

The Cairo code is in crates/falcon_512. The signing tool is tools/dualsign/dualsign.py. TUNING.md lists what we tried to make it faster.

## Tests

The vectors folder has 8 public test vectors. PQClean, falcon.py and a Python check all accept them. The Cairo tests check that wrong keys, swapped modes, changed messages and bad modes are rejected. An untagged OpenZeppelin Poseidon signature is also rejected.

## Credits

Thanks to OpenZeppelin for cairo-pq-verifiers, rukafe0x and the other Falcon Challenge record holders, ZKNox for ETHFALCON, Thomas Prest for falcon.py, and PQClean.

## Licence

MIT. See LICENSE and NOTICE.md.
