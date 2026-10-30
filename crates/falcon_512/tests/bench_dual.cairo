use pqbench_falcon_512::falcon512_dual_verify;
use pqbench_falcon_512::fixtures;
#[test] fn du_shake_0() { assert!(falcon512_dual_verify(0, fixtures::d0::msg(), fixtures::d0::public_key().span(), fixtures::d0::sig_shake().span())); }
#[test] fn du_pos_0() { assert!(falcon512_dual_verify(1, fixtures::d0::msg(), fixtures::d0::public_key().span(), fixtures::d0::sig_poseidon().span())); }
#[test] fn du_swap_sp_0() { assert!(!falcon512_dual_verify(1, fixtures::d0::msg(), fixtures::d0::public_key().span(), fixtures::d0::sig_shake().span())); }
#[test] fn du_swap_ps_0() { assert!(!falcon512_dual_verify(0, fixtures::d0::msg(), fixtures::d0::public_key().span(), fixtures::d0::sig_poseidon().span())); }
#[test] fn du_wk_s_0() { assert!(!falcon512_dual_verify(0, fixtures::d0::msg(), fixtures::d4::public_key().span(), fixtures::d0::sig_shake().span())); }
#[test] fn du_wk_p_0() { assert!(!falcon512_dual_verify(1, fixtures::d0::msg(), fixtures::d4::public_key().span(), fixtures::d0::sig_poseidon().span())); }
#[test] fn du_msg_p_0() { assert!(!falcon512_dual_verify(1, fixtures::d0::msg() + 1, fixtures::d0::public_key().span(), fixtures::d0::sig_poseidon().span())); }
#[test] fn du_mode_0() { assert!(!falcon512_dual_verify(2, fixtures::d0::msg(), fixtures::d0::public_key().span(), fixtures::d0::sig_poseidon().span())); }
#[test] fn du_shake_1() { assert!(falcon512_dual_verify(0, fixtures::d1::msg(), fixtures::d1::public_key().span(), fixtures::d1::sig_shake().span())); }
#[test] fn du_pos_1() { assert!(falcon512_dual_verify(1, fixtures::d1::msg(), fixtures::d1::public_key().span(), fixtures::d1::sig_poseidon().span())); }
#[test] fn du_swap_sp_1() { assert!(!falcon512_dual_verify(1, fixtures::d1::msg(), fixtures::d1::public_key().span(), fixtures::d1::sig_shake().span())); }
#[test] fn du_swap_ps_1() { assert!(!falcon512_dual_verify(0, fixtures::d1::msg(), fixtures::d1::public_key().span(), fixtures::d1::sig_poseidon().span())); }
#[test] fn du_wk_s_1() { assert!(!falcon512_dual_verify(0, fixtures::d1::msg(), fixtures::d5::public_key().span(), fixtures::d1::sig_shake().span())); }
#[test] fn du_wk_p_1() { assert!(!falcon512_dual_verify(1, fixtures::d1::msg(), fixtures::d5::public_key().span(), fixtures::d1::sig_poseidon().span())); }
#[test] fn du_msg_p_1() { assert!(!falcon512_dual_verify(1, fixtures::d1::msg() + 1, fixtures::d1::public_key().span(), fixtures::d1::sig_poseidon().span())); }
#[test] fn du_mode_1() { assert!(!falcon512_dual_verify(2, fixtures::d1::msg(), fixtures::d1::public_key().span(), fixtures::d1::sig_poseidon().span())); }
#[test] fn du_shake_2() { assert!(falcon512_dual_verify(0, fixtures::d2::msg(), fixtures::d2::public_key().span(), fixtures::d2::sig_shake().span())); }
#[test] fn du_pos_2() { assert!(falcon512_dual_verify(1, fixtures::d2::msg(), fixtures::d2::public_key().span(), fixtures::d2::sig_poseidon().span())); }
#[test] fn du_swap_sp_2() { assert!(!falcon512_dual_verify(1, fixtures::d2::msg(), fixtures::d2::public_key().span(), fixtures::d2::sig_shake().span())); }
#[test] fn du_swap_ps_2() { assert!(!falcon512_dual_verify(0, fixtures::d2::msg(), fixtures::d2::public_key().span(), fixtures::d2::sig_poseidon().span())); }
#[test] fn du_wk_s_2() { assert!(!falcon512_dual_verify(0, fixtures::d2::msg(), fixtures::d6::public_key().span(), fixtures::d2::sig_shake().span())); }
#[test] fn du_wk_p_2() { assert!(!falcon512_dual_verify(1, fixtures::d2::msg(), fixtures::d6::public_key().span(), fixtures::d2::sig_poseidon().span())); }
#[test] fn du_msg_p_2() { assert!(!falcon512_dual_verify(1, fixtures::d2::msg() + 1, fixtures::d2::public_key().span(), fixtures::d2::sig_poseidon().span())); }
#[test] fn du_mode_2() { assert!(!falcon512_dual_verify(2, fixtures::d2::msg(), fixtures::d2::public_key().span(), fixtures::d2::sig_poseidon().span())); }
#[test] fn du_shake_3() { assert!(falcon512_dual_verify(0, fixtures::d3::msg(), fixtures::d3::public_key().span(), fixtures::d3::sig_shake().span())); }
#[test] fn du_pos_3() { assert!(falcon512_dual_verify(1, fixtures::d3::msg(), fixtures::d3::public_key().span(), fixtures::d3::sig_poseidon().span())); }
#[test] fn du_swap_sp_3() { assert!(!falcon512_dual_verify(1, fixtures::d3::msg(), fixtures::d3::public_key().span(), fixtures::d3::sig_shake().span())); }
#[test] fn du_swap_ps_3() { assert!(!falcon512_dual_verify(0, fixtures::d3::msg(), fixtures::d3::public_key().span(), fixtures::d3::sig_poseidon().span())); }
#[test] fn du_wk_s_3() { assert!(!falcon512_dual_verify(0, fixtures::d3::msg(), fixtures::d7::public_key().span(), fixtures::d3::sig_shake().span())); }
#[test] fn du_wk_p_3() { assert!(!falcon512_dual_verify(1, fixtures::d3::msg(), fixtures::d7::public_key().span(), fixtures::d3::sig_poseidon().span())); }
#[test] fn du_msg_p_3() { assert!(!falcon512_dual_verify(1, fixtures::d3::msg() + 1, fixtures::d3::public_key().span(), fixtures::d3::sig_poseidon().span())); }
#[test] fn du_mode_3() { assert!(!falcon512_dual_verify(2, fixtures::d3::msg(), fixtures::d3::public_key().span(), fixtures::d3::sig_poseidon().span())); }
#[test] fn du_shake_4() { assert!(falcon512_dual_verify(0, fixtures::d4::msg(), fixtures::d4::public_key().span(), fixtures::d4::sig_shake().span())); }
#[test] fn du_pos_4() { assert!(falcon512_dual_verify(1, fixtures::d4::msg(), fixtures::d4::public_key().span(), fixtures::d4::sig_poseidon().span())); }
#[test] fn du_swap_sp_4() { assert!(!falcon512_dual_verify(1, fixtures::d4::msg(), fixtures::d4::public_key().span(), fixtures::d4::sig_shake().span())); }
#[test] fn du_swap_ps_4() { assert!(!falcon512_dual_verify(0, fixtures::d4::msg(), fixtures::d4::public_key().span(), fixtures::d4::sig_poseidon().span())); }
#[test] fn du_wk_s_4() { assert!(!falcon512_dual_verify(0, fixtures::d4::msg(), fixtures::d0::public_key().span(), fixtures::d4::sig_shake().span())); }
#[test] fn du_wk_p_4() { assert!(!falcon512_dual_verify(1, fixtures::d4::msg(), fixtures::d0::public_key().span(), fixtures::d4::sig_poseidon().span())); }
#[test] fn du_msg_p_4() { assert!(!falcon512_dual_verify(1, fixtures::d4::msg() + 1, fixtures::d4::public_key().span(), fixtures::d4::sig_poseidon().span())); }
#[test] fn du_mode_4() { assert!(!falcon512_dual_verify(2, fixtures::d4::msg(), fixtures::d4::public_key().span(), fixtures::d4::sig_poseidon().span())); }
#[test] fn du_shake_5() { assert!(falcon512_dual_verify(0, fixtures::d5::msg(), fixtures::d5::public_key().span(), fixtures::d5::sig_shake().span())); }
#[test] fn du_pos_5() { assert!(falcon512_dual_verify(1, fixtures::d5::msg(), fixtures::d5::public_key().span(), fixtures::d5::sig_poseidon().span())); }
#[test] fn du_swap_sp_5() { assert!(!falcon512_dual_verify(1, fixtures::d5::msg(), fixtures::d5::public_key().span(), fixtures::d5::sig_shake().span())); }
#[test] fn du_swap_ps_5() { assert!(!falcon512_dual_verify(0, fixtures::d5::msg(), fixtures::d5::public_key().span(), fixtures::d5::sig_poseidon().span())); }
#[test] fn du_wk_s_5() { assert!(!falcon512_dual_verify(0, fixtures::d5::msg(), fixtures::d1::public_key().span(), fixtures::d5::sig_shake().span())); }
#[test] fn du_wk_p_5() { assert!(!falcon512_dual_verify(1, fixtures::d5::msg(), fixtures::d1::public_key().span(), fixtures::d5::sig_poseidon().span())); }
#[test] fn du_msg_p_5() { assert!(!falcon512_dual_verify(1, fixtures::d5::msg() + 1, fixtures::d5::public_key().span(), fixtures::d5::sig_poseidon().span())); }
#[test] fn du_mode_5() { assert!(!falcon512_dual_verify(2, fixtures::d5::msg(), fixtures::d5::public_key().span(), fixtures::d5::sig_poseidon().span())); }
#[test] fn du_shake_6() { assert!(falcon512_dual_verify(0, fixtures::d6::msg(), fixtures::d6::public_key().span(), fixtures::d6::sig_shake().span())); }
#[test] fn du_pos_6() { assert!(falcon512_dual_verify(1, fixtures::d6::msg(), fixtures::d6::public_key().span(), fixtures::d6::sig_poseidon().span())); }
#[test] fn du_swap_sp_6() { assert!(!falcon512_dual_verify(1, fixtures::d6::msg(), fixtures::d6::public_key().span(), fixtures::d6::sig_shake().span())); }
#[test] fn du_swap_ps_6() { assert!(!falcon512_dual_verify(0, fixtures::d6::msg(), fixtures::d6::public_key().span(), fixtures::d6::sig_poseidon().span())); }
#[test] fn du_wk_s_6() { assert!(!falcon512_dual_verify(0, fixtures::d6::msg(), fixtures::d2::public_key().span(), fixtures::d6::sig_shake().span())); }
#[test] fn du_wk_p_6() { assert!(!falcon512_dual_verify(1, fixtures::d6::msg(), fixtures::d2::public_key().span(), fixtures::d6::sig_poseidon().span())); }
#[test] fn du_msg_p_6() { assert!(!falcon512_dual_verify(1, fixtures::d6::msg() + 1, fixtures::d6::public_key().span(), fixtures::d6::sig_poseidon().span())); }
#[test] fn du_mode_6() { assert!(!falcon512_dual_verify(2, fixtures::d6::msg(), fixtures::d6::public_key().span(), fixtures::d6::sig_poseidon().span())); }
#[test] fn du_shake_7() { assert!(falcon512_dual_verify(0, fixtures::d7::msg(), fixtures::d7::public_key().span(), fixtures::d7::sig_shake().span())); }
#[test] fn du_pos_7() { assert!(falcon512_dual_verify(1, fixtures::d7::msg(), fixtures::d7::public_key().span(), fixtures::d7::sig_poseidon().span())); }
#[test] fn du_swap_sp_7() { assert!(!falcon512_dual_verify(1, fixtures::d7::msg(), fixtures::d7::public_key().span(), fixtures::d7::sig_shake().span())); }
#[test] fn du_swap_ps_7() { assert!(!falcon512_dual_verify(0, fixtures::d7::msg(), fixtures::d7::public_key().span(), fixtures::d7::sig_poseidon().span())); }
#[test] fn du_wk_s_7() { assert!(!falcon512_dual_verify(0, fixtures::d7::msg(), fixtures::d3::public_key().span(), fixtures::d7::sig_shake().span())); }
#[test] fn du_wk_p_7() { assert!(!falcon512_dual_verify(1, fixtures::d7::msg(), fixtures::d3::public_key().span(), fixtures::d7::sig_poseidon().span())); }
#[test] fn du_msg_p_7() { assert!(!falcon512_dual_verify(1, fixtures::d7::msg() + 1, fixtures::d7::public_key().span(), fixtures::d7::sig_poseidon().span())); }
#[test] fn du_mode_7() { assert!(!falcon512_dual_verify(2, fixtures::d7::msg(), fixtures::d7::public_key().span(), fixtures::d7::sig_poseidon().span())); }
#[test] fn du_untagged_rejected() { assert!(!falcon512_dual_verify(1, fixtures::poseidon::msg(), fixtures::poseidon::public_key().span(), fixtures::poseidon::signature().span())); }
#[test] fn du_fixture_only() { let a = fixtures::d0::public_key(); let b = fixtures::d0::sig_shake(); assert!(a.len() + b.len() == 89); }
