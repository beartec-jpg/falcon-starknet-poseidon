#!/usr/bin/env bash
# Build a standalone Falcon-512 detached-signature verifier from PQClean (pinned commit).
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"; TP="$D/../../third_party"; mkdir -p "$TP"
PQC_COMMIT=0586a824fc0d49df0b6b6e9179d8d15d06d0974f
if [ ! -d "$TP/PQClean" ]; then git clone -q https://github.com/PQClean/PQClean "$TP/PQClean"; fi
git -C "$TP/PQClean" checkout -q "$PQC_COMMIT"
P="$TP/PQClean/crypto_sign/falcon-512/clean"
cc -O2 -I"$P" -I"$TP/PQClean/common" "$D/pqverify.c" "$P"/*.c "$TP/PQClean/common/fips202.c" "$TP/PQClean/common/randombytes.c" -o "$D/pqverify"
echo "built $D/pqverify"
