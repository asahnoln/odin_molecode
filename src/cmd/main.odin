package main

import "core:fmt"
import "core:strings"
import "src:beat"
import rl "vendor:raylib"

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
		pattern = {4, 2, 2},
	}

	rl.PlayMusicStream(m)

	i := 0
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
		rl.DrawText(
			strings.clone_to_cstring(fmt.tprintf("%v", rl.GetTime())),
			200,
			400,
			20,
			rl.RED,
		)
		rl.DrawText(
			strings.clone_to_cstring(fmt.tprintf("%v", rl.GetMusicTimePlayed(m))),
			200,
			100,
			20,
			rl.YELLOW,
		)

		if rl.IsKeyPressed(.SPACE) {
			if beat.is_hit(p, rl.GetMusicTimePlayed(m)) {
				rl.PlaySound(s)
				rl.DrawText("HIT", 300, 200, 20, rl.GREEN)
			} else {

				rl.DrawText("MISS", 400, 200, 20, rl.RED)
			}
		}


		if beat.is_sol_hit(p, i, rl.GetMusicTimePlayed(m)) {
			rl.PlaySound(s)
			i = (i + 1) % len(p.pattern)
		}
	}
}
