package beat

import "core:math"

SECONDS_IN_MINUTE :: 60
MATRAS_PER_AKCHARAM :: 4

Pattern :: []int

// apm = akcharams per minute (nearly same as beats per minute, but not quite)
Processor :: struct {
	apm:     f32,
	pattern: Pattern,
}

which_sol_hit :: proc(using p: Processor, t: f32) -> int {
	matra := SECONDS_IN_MINUTE / apm / MATRAS_PER_AKCHARAM

	pattern_sum := cast(f32)math.sum(pattern)
	mod := math.mod(t, matra * pattern_sum)
	if mod == 0 {
		return 0
	}

	s: f32 = 0
	for p, i in pattern {
		s += cast(f32)p * matra
		if s == pattern_sum {
			break
		}
		if mod != s {
			continue
		}

		return i + 1
	}

	return -1
}

is_hit :: proc(using p: Processor, t: f32) -> bool {
	return which_sol_hit(p, t) != -1
}

is_sol_hit :: proc(using p: Processor, i: int, t: f32) -> bool {
	return which_sol_hit(p, t) == i
}

correct_hit_time :: proc(using p: Processor, t: f32, leeway: [2]f32) -> (f: f32, ok: bool) {
	matra := SECONDS_IN_MINUTE / apm / MATRAS_PER_AKCHARAM
	s: f32 = 0
	for p in pattern {
		s += cast(f32)p * matra

		if t - s >= 0 && t - s <= leeway[1] {
			return s, true
		}
	}

	return 0, false
}
