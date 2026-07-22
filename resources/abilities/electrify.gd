class_name Electrify
extends CharacterAbility

@warning_ignore("unused_parameter")
func min_damage(entity: BaseEntity) -> int:
	return 3

@warning_ignore("unused_parameter")
func max_damage(entity: BaseEntity) -> int:
	return 6

@warning_ignore("unused_parameter")
func ability_range(entity: BaseEntity) -> int:
	return 3

func ability_save(entity: BaseEntity) -> int:
	return entity.stats.attack + 3

@warning_ignore("unused_parameter")
func misc_stat(entity: BaseEntity) -> int:
	return 0
