#!/usr/bin/env bash
# One-command reproduction: toolchain, reference tools, vector checks, Cairo tests, gas table.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"; cd "$ROOT"
SCARB_V=2.18.0; SNFORGE_V=0.59.0; FALCON_PY_COMMIT=5145a818c9512b4a443507d3375e75dae3076af6
export PATH="$HOME/.local/bin:$PATH"
if ! scarb --version 2>/dev/null | grep -q "$SCARB_V"; then
  curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh -s -- -v "$SCARB_V"; fi
if ! snforge --version 2>/dev/null | grep -q "$SNFORGE_V"; then
  curl -sSfL https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
  snfoundryup -v "$SNFORGE_V"; fi
scarb --version | head -1; snforge --version
mkdir -p third_party
[ -d third_party/falcon.py ] || git clone -q https://github.com/tprest/falcon.py third_party/falcon.py
git -C third_party/falcon.py checkout -q "$FALCON_PY_COMMIT"
[ -d .venv ] || python3 -m venv .venv
.venv/bin/pip install -q pycryptodome numpy beartype
bash tools/pqverify/build.sh
echo "== reference checks on public vectors (PQClean C, falcon.py, Python Cairo-equation) =="
for v in vectors/v*; do .venv/bin/python tools/dualsign/dualsign.py verify "$v" "$v" --pqclean tools/pqverify/pqverify | tr '\n' ' '; echo; done
echo "== negative: tampered SHAKE signature must fail PQClean =="
cp vectors/v0/sig_shake.bin /tmp/_bad.bin; printf '\x01' | dd of=/tmp/_bad.bin bs=1 seek=60 conv=notrunc 2>/dev/null
if tools/pqverify/pqverify vectors/v0/pk.bin /tmp/_bad.bin vectors/v0/msg.bin; then echo "UNEXPECTED ACCEPT"; exit 1; fi
echo "== snforge: full test suite =="
snforge test 2>&1 | tee snforge_all.log | grep -E "^Tests:|FAIL" || true
if grep -q "\[FAIL\]" snforge_all.log; then echo "TEST FAILURES"; exit 1; fi
echo "== gas table (dual entry, L2 gas incl. ~27k fixture build) =="
grep -E "du_(shake|pos)_[0-9]+ " snforge_all.log | sed -E 's/.*du_(shake|pos)_([0-9]+) .*l2_gas: ~([0-9]+).*/\1 \2 \3/' | sort -k1,1 -k2,2n | awk '
 {g[$1]=g[$1]" "$3; s[$1]+=$3; n[$1]++}
 END{rec=24097870; printf "%-9s %-4s %-12s %s\n","mode","n","mean","vs record 24,097,870";
 for(m in s){mean=s[m]/n[m]; printf "%-9s %-4d %-12d %+.2f%%\n",(m=="pos"?"poseidon":"shake"),n[m],mean,100*(mean-rec)/rec; print "  per-sig:"g[m]}}'
