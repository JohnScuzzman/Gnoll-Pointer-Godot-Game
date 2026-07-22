class_name SelfRepair
extends CharacterAbility

const min_damage_number: int = 1
const max_damage_number: int = 6

@warning_ignore("unused_parameter")
func min_damage(entity: BaseEntity) -> int:
	return min_damage_number

@warning_ignore("unused_parameter")
func max_damage(entity: BaseEntity) -> int:
	return max_damage_number

@warning_ignore("unused_parameter")
func ability_range(entity: BaseEntity) -> int:
	return 0

@warning_ignore("unused_parameter")
func ability_save(entity: BaseEntity) -> int:
	return 0

@warning_ignore("unused_parameter")
func misc_stat(entity: BaseEntity) -> int:
	return randi_range(min_damage_number, max_damage_number)
