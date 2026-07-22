class_name AimedShot
extends CharacterAbility

func min_damage(entity: BaseEntity) -> int:
	return entity.equiped_ranged_weapon.min_damage + 1

func max_damage(entity: BaseEntity) -> int:
	return entity.equiped_ranged_weapon.max_damage + 1

func ability_range(entity: BaseEntity) -> int:
	return entity.equiped_ranged_weapon.weapon_range

func ability_save(entity: BaseEntity) -> int:
	return entity.stats.attack + 10

@warning_ignore("unused_parameter")
func misc_stat(entity: BaseEntity) -> int:
	return 0
