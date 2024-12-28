package main

import "core:fmt"
import "core:strings"
import "core:time"
import "src:beat"
import rl "vendor:raylib"

// Convert float seconds to time.Duration seconds
f2s :: proc(t: f32) -> time.Duration {
	return time.Duration(t * f32(time.Second))
}

f64tos :: proc(t: f64) -> time.Duration {
	return time.Duration(t * f64(time.Second))
}

main :: proc() {
	rl.InitWindow(640, 480, "molecode")
	defer rl.CloseWindow()

	rl.InitAudioDevice()
	defer rl.CloseAudioDevice()

	rl.SetTargetFPS(60)

	m := rl.LoadMusicStream(#directory + "../../audio/rhythm_test.ogg")
	defer rl.UnloadMusicStream(m)

	s := rl.LoadSound(#directory + "../../audio/molecode.wav")
	defer rl.UnloadSound(s)

	p := beat.Processor {
		apm     = 60,
		pattern = {2, 2},
		leeway  = 100 * time.Millisecond,
	}

	rl.PlayMusicStream(m)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.UpdateMusicStream(m)

		rl.ClearBackground(rl.WHITE)

		rl.DrawText(
			strings.clone_to_cstring(fmt.tprintf("%v", rl.GetMusicTimePlayed(m))),
			200,
			200,
			20,
			rl.RED,
		)

		if rl.IsKeyPressed(.SPACE) {
			if beat.is_hit(p, f2s(rl.GetMusicTimePlayed(m))) {
				rl.PlaySound(s)
				rl.DrawText("HIT", 300, 200, 20, rl.GREEN)
			} else {

				rl.DrawText("MISS", 400, 200, 20, rl.RED)
			}
		}


		// if beat.is_hit(p, f64tos(rl.GetTime())) {
		// 	// FIX: Multiple sounds
		// 	rl.PlaySound(s)
		// }
	}
}
