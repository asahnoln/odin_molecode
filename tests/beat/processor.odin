package beat_test

import "core:testing"
import "core:time"
import "src:beat"

@(test)
hit :: proc(t: ^testing.T) {
	p := beat.Processor {
		apm = 60,
	}

	tests := []struct {
		time:    time.Duration,
		pattern: []int,
		want:    bool,
	} {
		// Format
		{1 * time.Second, {4}, true},
		{1500 * time.Millisecond, {2}, true},
		{2 * time.Second, {4}, true},
		{1750 * time.Millisecond, {4}, false},
		{500 * time.Millisecond, {2, 4}, true},
		{1000 * time.Millisecond, {4, 2}, true},
		{1500 * time.Millisecond, {4, 2, 2}, true},
		{3500 * time.Millisecond, {2, 4, 2}, true},
		{5000 * time.Millisecond, {3, 3, 3, 1, 1, 1, 1, 1}, true},
		{4000 * time.Millisecond, {3, 3, 3, 1, 1, 1, 1, 1}, false},
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

player_hit_specific_sol :: proc(t: ^testing.T) {
	p := beat.Processor {
		apm     = 60,
		pattern = {2, 4, 2},
	}

	got := beat.is_sol_hit(p, 2, 1500 * time.Millisecond)
	testing.expect(t, got)
}
