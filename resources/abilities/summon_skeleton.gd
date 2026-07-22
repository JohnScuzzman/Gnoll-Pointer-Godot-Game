class_name SummonSkeleton
extends CharacterAbility

func min_damage(entity: BaseEntity) -> int:
	return entity.stats.level % 2

func max_damage(entity: BaseEntity) -> int:
	return entity.stats.level % 2 + 5

@warning_ignore("unused_parameter")
func ability_range(entity: BaseEntity) -> int:
	return 1

func ability_save(entity: BaseEntity) -> int:
	return entity.stats.level % 2

func misc_stat(entity: BaseEntity) -> int:
	@warning_ignore("integer_division")
	return (((entity.stats.level) - 10) / 2) + 8
