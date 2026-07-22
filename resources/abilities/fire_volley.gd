class_name FireVolley
extends CharacterAbility

func min_damage(entity: BaseEntity) -> int:
	return entity.equipped_ranged_weapon.min_damage * misc_stat(entity)

func max_damage(entity: BaseEntity) -> int:
	return entity.equipped_ranged_weapon.max_damage * misc_stat(entity)

func ability_range(entity: BaseEntity) -> int:
	return entity.equipped_ranged_weapon.weapon_range

func ability_save(entity: BaseEntity) -> int:
	return entity.stats.attack + 6

func misc_stat(entity: BaseEntity) -> int:
	return entity.stats.level + 1
