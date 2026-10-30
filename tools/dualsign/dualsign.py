#!/usr/bin/env python3
"""dualsign: one Falcon-512 key, two signatures per message (FIPS/round-3 SHAKE256 + Poseidon h2p).
  dualsign keygen DIR
  dualsign sign DIR MSG_FELT OUTDIR
  dualsign verify DIR OUTDIR [--pqclean /path/pqverify]
  dualsign cairo DIR OUTDIR NAME FILE.cairo   # emit Cairo fixture module
Secret key stays in DIR/sk.json (never printed)."""
import sys, os, json, subprocess
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.environ.get("FALCON_PY", os.path.join(HERE, "../../third_party/falcon.py"))); sys.path.insert(0, os.path.join(HERE, "../../scripts"))
import falcon as fpy
from ntt import div_zq, mul_zq, ntt
import gen_falcon_fixture as G
Q = 12289; S = fpy.Falcon(512); BOUND = S.param.sig_bound; CBYTES = S.param.sig_bytelen - 41

P = 2**251 + 17 * 2**192 + 1
TAG = int.from_bytes(b"FALCON512-POSEIDON-H2P-v1", "big")
def h2p_poseidon_v1(m, sa, sb, n=512):
    """Domain-separated Poseidon XOF -> 512 coeffs mod q (must match hash_to_point_poseidon_raw)."""
    t0, t1, t2 = G.poseidon_perm(sa, sb, TAG)
    s0, s1, s2 = G.poseidon_perm((t0 + m) % P, t1, t2)
    out = []
    while True:
        for felt in (s0, s1):
            for j in range(15):
                w = (felt >> (16 * j)) & 0xFFFF
                if w < 5 * Q and len(out) < n: out.append(w % Q)
        if len(out) >= n: return out
        s0, s1, s2 = G.poseidon_perm(s0, s1, s2)

def comp_encode(s1):
    bits = []
    for x in s1:
        a = abs(x); bits.append(1 if x < 0 else 0)
        bits += [(a >> i) & 1 for i in range(6, -1, -1)]
        bits += [0] * (a >> 7) + [1]
    if len(bits) > 8 * CBYTES: return None
    bits += [0] * (-len(bits) % 8)
    return bytes(int("".join(map(str, bits[i:i+8])), 2) for i in range(0, len(bits), 8))

def pk_fips(h):
    acc = 0
    for c in h: acc = (acc << 14) | c
    return bytes([0x09]) + acc.to_bytes(896, "big")

def load_sk(d):
    p = json.load(open(f"{d}/sk.json")); sk, vk = S.keygen([p["f"], p["g"], p["F"], p["G"]])
    return sk, div_zq(p["g"], p["f"])

def keygen(d):
    os.makedirs(d, exist_ok=True); sk, _ = S.keygen(); f, g, F, G_, _, _ = sk
    fd = os.open(f"{d}/sk.json", os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with os.fdopen(fd, "w") as fh: json.dump({"f": f, "g": g, "F": F, "G": G_}, fh)
    h = div_zq(g, f); open(f"{d}/pk.bin", "wb").write(pk_fips(h))
    json.dump({"h": h, "cairo_pk": [hex(x) for x in G.pack_512(ntt(h))]}, open(f"{d}/pk.json", "w"))
    print("keygen ok; pk.bin (897-byte FIPS/round-3 encoding) written")

def sample(sk, h, point):
    _, _, _, _, B0, T = sk
    while True:
        s = S.__sample_preimage__(B0, T, point)
        if sum(c*c for c in s[0]) + sum(c*c for c in s[1]) <= BOUND:
            enc = comp_encode(s[1])
            if enc is not None: return s, enc

def cairo_sig(h, s, salt):
    s1 = [c % Q for c in s[1]]; hint = mul_zq(s1, h)
    return [hex(x) for x in G.pack_512(s1) + [int.from_bytes(salt[:20], "little"), int.from_bytes(salt[20:], "little")] + G.pack_512(hint)]

def sign(d, m, out):
    os.makedirs(out, exist_ok=True); sk, h = load_sk(d); m = int(m, 0)
    msg = m.to_bytes(32, "little"); open(f"{out}/msg.bin", "wb").write(msg)
    salt_s = os.urandom(40); salt_p = os.urandom(40)   # independent salts per mode
    s, enc = sample(sk, h, S.__hash_to_point__(msg, salt_s))
    open(f"{out}/sig_shake.bin", "wb").write(bytes([0x39]) + salt_s + enc)
    sp, _ = sample(sk, h, h2p_poseidon_v1(m, int.from_bytes(salt_p[:20], "little"), int.from_bytes(salt_p[20:], "little")))
    json.dump({"msg": hex(m), "shake": cairo_sig(h, s, salt_s), "poseidon": cairo_sig(h, sp, salt_p)}, open(f"{out}/sig_cairo.json", "w"))
    print("signed: sig_shake.bin (FIPS detached) + sig_cairo.json (shake & poseidon felts)")

def eq_check(h, felts, point):
    f = [int(x, 16) for x in felts]; s1 = G.unpack_512(f[:29]); hint = G.unpack_512(f[31:])
    if mul_zq(s1, h) != hint: return False
    return sum(G.centered((point[i]-hint[i]) % Q)**2 + G.centered(s1[i])**2 for i in range(512)) <= BOUND

def verify(d, out, pq=None):
    h = json.load(open(f"{d}/pk.json"))["h"]; sig = open(f"{out}/sig_shake.bin", "rb").read(); msg = open(f"{out}/msg.bin", "rb").read()
    J = json.load(open(f"{out}/sig_cairo.json")); m = int(J["msg"], 16); ok = True
    pad = sig + bytes(41 + CBYTES - len(sig))
    r = S.verify(fpy.serialize_poly(h), msg, pad); print("falcon.py verify (shake):", r); ok &= r
    if pq:
        r = subprocess.run([pq, f"{d}/pk.bin", f"{out}/sig_shake.bin", f"{out}/msg.bin"]).returncode == 0; ok &= r
    for mode in ("shake", "poseidon"):
        f = [int(x, 16) for x in J[mode]]; salt = f[29].to_bytes(20, "little") + f[30].to_bytes(20, "little")
        pt = S.__hash_to_point__(msg, salt) if mode == "shake" else h2p_poseidon_v1(m, f[29], f[30])
        r = eq_check(h, J[mode], pt); print(f"python cairo-equation ({mode}):", r); ok &= r
    print("ALL OK" if ok else "FAILED"); return ok

def cairo(d, out, name, path):
    pk = json.load(open(f"{d}/pk.json"))["cairo_pk"]; J = json.load(open(f"{out}/sig_cairo.json"))
    arr = lambda xs: "array![" + ", ".join(xs) + "]"
    open(path, "w").write(f"//! dualsign fixture {name}\npub fn msg() -> felt252 {{ {J['msg']} }}\n"
        f"pub fn public_key() -> Array<felt252> {{ {arr(pk)} }}\npub fn sig_shake() -> Array<felt252> {{ {arr(J['shake'])} }}\n"
        f"pub fn sig_poseidon() -> Array<felt252> {{ {arr(J['poseidon'])} }}\n")

if __name__ == "__main__":
    a = sys.argv[1:]
    if not a: print(__doc__); sys.exit(2)
    if a[0] == "keygen": keygen(a[1])
    elif a[0] == "sign": sign(a[1], a[2], a[3])
    elif a[0] == "verify": sys.exit(0 if verify(a[1], a[2], a[4] if len(a) > 4 and a[3] == "--pqclean" else None) else 1)
    elif a[0] == "cairo": cairo(*a[1:5])
