package beat

import "core:math"
import "core:time"

SECONDS_IN_MINUTE :: 60
MATRAS_PER_AKCHARAM :: 4

Pattern :: []int

// apm = akcharams per minute (nearly same as beats per minute, but not quite)
Processor :: struct {
	apm:     f64,
	pattern: Pattern,
	leeway:  time.Duration,
}

which_sol_hit :: proc(using p: Processor, t: time.Duration) -> int {
	matra := SECONDS_IN_MINUTE / apm / MATRAS_PER_AKCHARAM

	pattern_sum := cast(f64)math.sum(pattern)
	mod := math.mod(time.duration_seconds(t), matra * pattern_sum)
	if mod == 0 {
		return 0
	}

	s: f64 = 0
	for p, i in pattern {
		s += cast(f64)p * matra
		if s == pattern_sum {
			break
		}
		if abs(s - mod) > time.duration_seconds(leeway) {
			continue
		}

		return i + 1
	}

	return -1
}

is_hit :: proc(using p: Processor, t: time.Duration) -> bool {
	return which_sol_hit(p, t) != -1
}

is_sol_hit :: proc(using p: Processor, i: int, t: time.Duration) -> bool {
	return which_sol_hit(p, t) == i
}
