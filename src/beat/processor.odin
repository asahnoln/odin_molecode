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
}

is_hit :: proc(using p: Processor, t: time.Duration) -> bool {
	matra := SECONDS_IN_MINUTE / apm / MATRAS_PER_AKCHARAM

	pattern_sum := math.sum(pattern)

	hit := math.mod(time.duration_seconds(t), matra * cast(f64)pattern_sum) == 0

	if !hit {
		m := math.mod(time.duration_seconds(t), matra * cast(f64)pattern_sum)

		s: f64 = 0
		for p in pattern {
			s += cast(f64)p * matra
			if m == s {
				return true
			}
		}
	}

	return hit
}
