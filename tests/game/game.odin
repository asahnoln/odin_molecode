package game_test

import "core:testing"
import "src:game"

@(test)
play :: proc(t: ^testing.T) {
	pattern := {4, 2, 2}
	ps := {.Mole, .Player, .Mole, .Mole}

	tests = []struct {
		sol, start: int,
		want:       bool,
	}{{1, 0, true}, {0, 1, true}, {-1, 2, true}, {2, 3, true}, {1, 1, false}}

	for tt in tests {
		got := game.check_player_turn(pattern, ps, 1, 0)
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
