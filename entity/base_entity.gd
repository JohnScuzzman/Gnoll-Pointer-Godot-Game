class_name BaseEntity
extends CharacterBody2D

@export var ch: String # Unsure what this is
@export var stats: Stats
@export var armor: Armor
@export var equiped_melee_weapon: Weapon
@export var equiped_ranged_weapon: Weapon
@export var equiped_ammo: GlobalEnums.AmmoTypes
@export var character_class: CharacterClass
@export var inventory: Array[Item]
@export var race: GlobalEnums.Races
