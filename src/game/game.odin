package game

import "src:beat"

Players :: []Player_Type

Player_Type :: enum {
	Mole,
	Player,
}

check_player_turn :: proc(p: beat.Pattern, ps: Players, sol_index, start_index: int) -> bool {
	if sol_index >= len(p) || sol_index < 0 {
		return false
	}

	return ps[(start_index + sol_index) % len(ps)] == .Player
}
