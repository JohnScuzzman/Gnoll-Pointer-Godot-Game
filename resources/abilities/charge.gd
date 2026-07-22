class_name Charge
extends CharacterAbility

func min_damage(entity: BaseEntity) -> int:
	return entity.equipped_melee_weapon.min_damage + 1

func max_damage(entity: BaseEntity) -> int:
	return entity.equipped_melee_weapon.max_damage + 1

@warning_ignore("unused_parameter")
func ability_range(entity: BaseEntity) -> int:
	return 5

func ability_save(entity: BaseEntity) -> int:
	return entity.stats.attack + 10

@warning_ignore("unused_parameter")
func misc_stat(entity: BaseEntity) -> int:
	return 0
