package beat

import "core:math"

SECONDS_IN_MINUTE :: 60
MATRAS_PER_AKCHARAM :: 4
MATH_LEEWAY :: 0.00001

Pattern :: []int

// apm = akcharams per minute (nearly same as beats per minute, but not quite)
Processor :: struct {
	apm:     f32,
	pattern: Pattern,
	leeway:  [2]f32,
}

which_sol_hit :: proc(using p: Processor, t: f32) -> int {
	matra := SECONDS_IN_MINUTE / apm / MATRAS_PER_AKCHARAM

	pattern_sum := cast(f32)math.sum(pattern)
	mod := math.mod(t, matra * pattern_sum)
	if in_leeway(mod, leeway) {
		return 0
	}

	s: f32 = 0
	for p, i in pattern {
		s += cast(f32)p * matra
		if s == pattern_sum {
			break
		}

		diff := mod - s
		if !in_leeway(diff, leeway) {
			continue
		}

		return i + 1
	}

	return -1
}

in_leeway :: proc(mod: f32, leeway: [2]f32) -> bool {
	return mod >= -leeway[0] - MATH_LEEWAY && mod <= leeway[1] + MATH_LEEWAY
}

is_hit :: proc(using p: Processor, t: f32) -> bool {
	return which_sol_hit(p, t) != -1
}

is_sol_hit :: proc(using p: Processor, i: int, t: f32) -> bool {
	return which_sol_hit(p, t) == i
}
