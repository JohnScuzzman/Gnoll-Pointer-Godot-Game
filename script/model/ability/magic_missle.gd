class_name MagicMissle
extends CharacterAbility

func min_damage(entity: BaseEntity) -> int:
	return entity.stats.level + 1

func max_damage(entity: BaseEntity) -> int:
	return (entity.stats.level * 4) + 1

@warning_ignore("unused_parameter")
func ability_range(entity: BaseEntity) -> int:
	return 15

@warning_ignore("unused_parameter")
func ability_save(entity: BaseEntity) -> int:
	return 40

@warning_ignore("unused_parameter")
func misc_stat(entity: BaseEntity) -> int:
	return 3
