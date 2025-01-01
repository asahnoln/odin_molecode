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
		pattern = {4, 2, 2},
		leeway  = {0.05, 0.25},
	}
	players := game.Players{.Mole, .Mole, .Mole, .Player}

	rl.PlayMusicStream(m)

	i := 0
	j := 0
	c := 0
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		for pl, x in players {
			cl := rl.YELLOW if pl == .Player else rl.BLACK
			rl.DrawRectangle(98 + cast(i32)x * 100, 98, 54, 54, x + 1 == j ? rl.GREEN : rl.GRAY)
			rl.DrawRectangle(100 + cast(i32)x * 100, 100, 50, 50, cl)
		}
		defer rl.EndDrawing()

		rl.UpdateMusicStream(m)

		rl.ClearBackground(rl.WHITE)

		if beat.is_sol_hit(p, i, rl.GetMusicTimePlayed(m)) {
			if players[j] != .Player {
				rl.PlaySound(s)
			}
			i = (i + 1) % len(p.pattern)
			j = (j + 1) % len(players)

			if i == 0 {
				c = j
			}
		}

		if rl.IsKeyPressed(.SPACE) {
			s := beat.which_sol_hit(p, rl.GetMusicTimePlayed(m))
			if game.check_player_turn(p.pattern, players, s, c) {
				rl.PlaySound(ps)
				rl.DrawText("HIT", 300, 200, 20, rl.GREEN)
			} else {
				rl.DrawText("MISS", 400, 200, 20, rl.RED)
			}
		}


	}
}
