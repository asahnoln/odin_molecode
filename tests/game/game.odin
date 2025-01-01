package game_test

import "core:testing"
import "src:beat"
import "src:game"


@(test)
play :: proc(t: ^testing.T) {
	pattern := beat.Pattern{4, 2}
	ps := game.Players{.Mole, .Player, .Mole, .Mole}

	tests := []struct {
		sol, start: int,
		want:       bool,
	} {
		// Format
		{1, 0, true},
		{0, 1, true},
		{-10, 0, false},
		{-1, 2, false},
		{1, 1, false},
		{1, 1, false},
		{5, 0, false},
	}

	for tt in tests {
		got := game.check_player_turn(pattern, ps, tt.sol, tt.start)
		testing.expectf(
			t,
			got == tt.want,
			"For sol %v starting from %v got %v, want %v",
			tt.sol,
			tt.start,
			got,
			tt.want,
		)
	}

}

@(test)
play_longer :: proc(t: ^testing.T) {
	pattern := beat.Pattern{4, 2, 2, 4, 3}
	ps := game.Players{.Mole, .Player, .Mole, .Mole}

	tests := []struct {
		sol, start: int,
		want:       bool,
	} {
		// Format
		{1, 0, true},
		{0, 1, true},
		{4, 1, true},
		{0, 0, false},
	}

	for tt in tests {
		got := game.check_player_turn(pattern, ps, tt.sol, tt.start)
		testing.expectf(
			t,
			got == tt.want,
			"For sol %v starting from %v got %v, want %v",
			tt.sol,
			tt.start,
			got,
			tt.want,
		)
	}

}

// @(test)
// get_new_start :: proc(t: ^testing.T) {
// 	testing.expect(t, false)
// }
//
// @(test)
// do_smth_when_player_right_or_wrong :: proc(t: ^testing.T) {
// 	testing.expect(t, false)
// }
//
// @(test)
// do_smth_when_moles_turn :: proc(t: ^testing.T) {
// 	testing.expect(t, false)
// }

// @(test)
// run_proc_when_its_not_players_turn :: proc(t: ^testing.T) {
// 	p := beat.Processor{}
// 	pr := proc(p: ^beat.Processor) {
// 		p.apm = 9999
// 	}
//
// 	ps := game.ps{.Mole, .Mole, .Player}
// 	game.proc_run_on_mole(p, ps, 3, pr)
//
// 	testing.pa(t)
// }
