use pqbench_falcon_512::fixtures;
use pqbench_falcon_512::hashing::hash_to_point as H;
fn args() -> (felt252, felt252, felt252) { let s = fixtures::d0::sig_poseidon(); (fixtures::d0::msg(), *s.at(29), *s.at(30)) }
#[test] fn tu_args() { let (m, a, b) = args(); assert!(m + a + b != 1); }
#[test] fn tu_v1() { let (m, a, b) = args(); assert!(H::hash_to_point_poseidon_raw(m, a, b).unwrap().len() >= 512); }
