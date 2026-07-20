class_name CharacterAbility
extends Resource

@export_category("Ability Description")
@export var name: String
@export_multiline() var description: String

@export_category("Ability Variables")
@export var is_attack: bool
@export var is_magic: bool
@export var is_ranged: bool
@export var pre_combat_effects: bool
@export var post_combat_effects: bool
@export var duration: int
@export var mana_cost: int

#
# Empty methods to implement for each ability
#

@warning_ignore("unused_parameter")
func min_damage(player_stat: int = 0) -> int:
	return 0

@warning_ignore("unused_parameter")
func max_damage(player_stat: int = 0) -> int:
	return 0

@warning_ignore("unused_parameter")
func ability_range(player_stat: int = 0) -> int:
	return 0

@warning_ignore("unused_parameter")
func ability_save(player_stat: int = 0) -> int:
	return 0

@warning_ignore("unused_parameter")
func misc_stat(player_stat: int = 0) -> int:
	return 0
