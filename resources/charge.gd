class_name Charge
extends CharacterAbility

func min_damage(player_stat: int = 0) -> int:
	return player_stat + 1

func max_damage(player_stat: int = 0) -> int:
	return player_stat + 1

@warning_ignore("unused_parameter")
func ability_range(player_stat: int = 0) -> int:
	return 5

func ability_save(player_stat: int = 0) -> int:
	return player_stat + 10
