class_name CharacterClass
extends Resource

@export_category("Class Description")
@export var name: String
@export_multiline var description: String

@export_category("Class Variables")
@export var is_caster: bool
@export var hp_per_lvl: int
@export var mana_per_lvl: int
@export var main_stat: GlobalEnums.StatType
@export var secondary_stat: GlobalEnums.StatType
@export var abilities: Array[CharacterAbility]
