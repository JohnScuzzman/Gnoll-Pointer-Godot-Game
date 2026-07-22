@abstract class_name CharacterAbility
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

@abstract func min_damage(entity: BaseEntity) -> int
@abstract func max_damage(entity: BaseEntity) -> int
@abstract func ability_range(entity: BaseEntity) -> int
@abstract func ability_save(entity: BaseEntity) -> int
@abstract func misc_stat(entity: BaseEntity) -> int
