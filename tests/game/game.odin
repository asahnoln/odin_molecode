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
		{-1, 2, true},
		{-1, 3, true},
		{1, 1, false},
		{-1, 1, false},
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
