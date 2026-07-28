class_name Weapon
extends Item

@export var is_magic: bool
@export var is_enchanted: bool
@export var is_ranged: bool
@export var capacity: int
@export var enchant_level: int
@export var min_damage: int
@export var max_damage: int
@export var weapon_range: int
@export var ammo_type: GlobalEnums.AmmoTypes
@export var stat_requirement: int
@export var stat_used: GlobalEnums.StatType
