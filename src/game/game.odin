package game

import "src:beat"

Players :: []Player_Type

Player_Type :: enum {
	Mole,
	Player,
}

check_player_turn :: proc(p: beat.Pattern, ps: Players, sol_index, start_index: int) -> bool {
	if sol_index >= len(p) {
		return false
	}

	for _, i in p {
		if ps[(start_index + i) % len(ps)] == .Player {
			if sol_index == -1 {
				return false
			}
			if sol_index == i {
				return true
			}
		}
	}

	return sol_index == -1
}
