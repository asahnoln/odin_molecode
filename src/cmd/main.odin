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

	m := rl.LoadMusicStream(#directory + "../../audio/rhythm_test.wav")
	defer rl.UnloadMusicStream(m)

	s := rl.LoadSound(#directory + "../../audio/molecode.wav")
	defer rl.UnloadSound(s)

	ps := rl.LoadSound(#directory + "../../audio/player.wav")
	defer rl.UnloadSound(ps)

	p := beat.Processor {
		apm     = 60,
		// pattern = {4},
		pattern = {3, 3, 3, 1, 1, 1, 1, 1, 2},
		leeway  = {0.05, 0.2},
	}
	npc := beat.Processor {
		apm     = 60,
		pattern = {3, 3, 3, 1, 1, 1, 1, 1, 2},
		leeway  = {0, 0.1},
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
				rl.PlaySound(ps)
				rl.DrawText("HIT", 300, 200, 20, rl.GREEN)
			} else {

				rl.DrawText("MISS", 400, 200, 20, rl.RED)
			}
		}


		if beat.is_sol_hit(npc, i, rl.GetMusicTimePlayed(m)) {
			rl.PlaySound(s)
			i = (i + 1) % len(npc.pattern)
		}
	}
}
