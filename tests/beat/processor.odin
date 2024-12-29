package beat_test

import "core:testing"
import "src:beat"

@(test)
hit :: proc(t: ^testing.T) {
	p := beat.Processor {
		apm = 60,
	}

	tests := []struct {
		time:    f32,
		pattern: []int,
		want:    bool,
	} {
		// Format
		{1, {4}, true},
		{1.5, {2}, true},
		{2, {4}, true},
		{1.75, {4}, false},
		{0.5, {2, 4}, true},
		{1, {4, 2}, true},
		{1.5, {4, 2, 2}, true},
		{3.5, {2, 4, 2}, true},
		{5, {3, 3, 3, 1, 1, 1, 1, 1}, true},
		{4, {3, 3, 3, 1, 1, 1, 1, 1}, false},
	}

	for tt in tests {
		p.pattern = tt.pattern
		got := beat.is_hit(p, tt.time)
		testing.expectf(
			t,
			got == tt.want,
			"For pattern %v in apm %v hit in time %v want %v, got %v",
			tt.pattern,
			p.apm,
			tt.time,
			tt.want,
			got,
		)
	}
}

@(test)
player_hit_specific_sol :: proc(t: ^testing.T) {
	p := beat.Processor {
		apm     = 60,
		pattern = {2, 4, 2},
	}

	tests := []struct {
		sol:  int,
		time: f32,
		want: bool,
	} {
		// Format
		{2, 1.5, true},
		{1, 1.5, false},
	}

	for tt in tests {
		got := beat.is_sol_hit(p, tt.sol, tt.time)
		testing.expectf(
			t,
			got == tt.want,
			"For sol %v in time %v want %v, got %v",
			tt.sol,
			tt.time,
			tt.want,
			got,
		)
	}
}

@(test)
hit_has_a_leeway :: proc(t: ^testing.T) {
	p := beat.Processor {
		apm     = 60,
		pattern = {2, 4, 2},
		leeway  = {0.05, 0.1},
	}

	got := beat.is_hit(p, 0.6)
	testing.expect(t, got)

	got = beat.is_hit(p, 0.45)
	testing.expect(t, got)

	got = beat.is_hit(p, 2.1)
	testing.expect(t, got)
}
//
// @(test)
// hit_has_a_leeway_before :: proc(t: ^testing.T) {
// 	p := beat.Processor {
// 		apm           = 60,
// 		pattern       = {2, 4, 2},
// 		leeway        = 0.1,
// 		leeway_before = 0.1,
// 	}
//
// 	got := beat.is_hit(p, 0.55)
// 	testing.expect(t, got)
// }
