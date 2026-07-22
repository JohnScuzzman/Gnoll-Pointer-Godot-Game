class_name Item
extends Resource

@export_category("Item Description")
@export var name: String
@export_multiline() var description: String

@export_category("Item Variables")
@export var equippable: bool
@export var lootable: bool
@export var unequippable: bool
@export var isEquipped: bool
@export var quantity: int
@export var type: GlobalEnums.ItemTypes
@export var value: int
