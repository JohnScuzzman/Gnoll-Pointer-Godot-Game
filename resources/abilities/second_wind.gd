class_name SecondWind
extends CharacterAbility

@export_category("Ability Stat Constants")
@export var min_damage_value: int = 2
@export var max_damage_value: int = 8

@warning_ignore("unused_parameter")
func min_damage(entity: BaseEntity) -> int:
	return min_damage_value

@warning_ignore("unused_parameter")
func max_damage(entity: BaseEntity) -> int:
	return max_damage_value

@warning_ignore("unused_parameter")
func ability_range(entity: BaseEntity) -> int:
	return 0

@warning_ignore("unused_parameter")
func ability_save(entity: BaseEntity) -> int:
	return 0

@warning_ignore("unused_parameter")
func misc_stat(entity: BaseEntity) -> int:
	return randi_range(min_damage_value, max_damage_value)
