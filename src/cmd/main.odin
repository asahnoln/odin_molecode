package main

import "core:fmt"
import "core:strings"
import "src:beat"
import "src:game"
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
		pattern = {4, 2, 2, 4},
		leeway  = {0.05, 0.2},
	}
	players := game.Players{.Mole, .Mole, .Mole, .Player}

	rl.PlayMusicStream(m)

	i := 0
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.UpdateMusicStream(m)

		rl.ClearBackground(rl.WHITE)

		if beat.is_sol_hit(p, i, rl.GetMusicTimePlayed(m)) {
			if players[i] != .Player {
				rl.PlaySound(s)
			}
			i = (i + 1) % len(p.pattern)
		}

		if rl.IsKeyPressed(.SPACE) {
			s := beat.which_sol_hit(p, rl.GetMusicTimePlayed(m))
			if game.check_player_turn(p.pattern, players, s, 0) {
				rl.PlaySound(ps)
				rl.DrawText("HIT", 300, 200, 20, rl.GREEN)
			} else {
				rl.DrawText("MISS", 400, 200, 20, rl.RED)
			}
		}


	}
}
