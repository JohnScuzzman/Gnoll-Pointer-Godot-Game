extends Control

@export var play_button: Button
@export var quit_button: Button
@export var class_item_list: ItemList
@export var race_item_list: ItemList
@export var name_text_edit: TextEdit

@export var hp_lvl_value: Label
@export var main_stat_value: Label
@export var second_stat_value: Label

@export var hp_value: Label
@export var cha_value: Label
@export var int_value: Label
@export var con_value: Label
@export var str_value: Label
@export var dex_value: Label
@export var wis_value: Label

var classes: Array[Resource] = []
var races: Array[Resource] = []

func _ready() -> void:
	for classKey: String in GlobalEnums.Clases.keys():
		var classDef: CharacterClass = load("res://data/class/" + classKey + ".tres")
		classes.append(classDef)
		class_item_list.add_item(classDef.name)
	class_item_list.select(0)
	_on_class_item_list_item_selected(0)
	
	for raceKey: String in GlobalEnums.Races.keys():
		var raceDef: Stats = load("res://data/race/" + raceKey + ".tres")
		races.append(raceDef)
		race_item_list.add_item(raceDef.name)
	race_item_list.select(0)
	_on_race_item_list_item_selected(0)

func _on_start_pressed() -> void:
	var next_scene_packed: PackedScene = load("res://scene/level/avia.tscn")
	var next_scene_instance: Node = next_scene_packed.instantiate()
	next_scene_instance.player_name = name_text_edit.text
	next_scene_instance.player_class = classes[class_item_list.get_selected_items()[0]]
	next_scene_instance.player_race = races[race_item_list.get_selected_items()[0]]
	get_tree().root.add_child(next_scene_instance)
	get_tree().current_scene = next_scene_instance
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()

# Obviously change this to real values
func _on_race_item_list_item_selected(index: int) -> void:
	var racedef: Stats = races[index]
	hp_value.text = str(racedef.health_points)
	cha_value.text = str(racedef.charisma)
	int_value.text = str(racedef.intelligence)
	con_value.text = str(racedef.constitution)
	str_value.text = str(racedef.strength)
	dex_value.text = str(racedef.dexterity)
	wis_value.text = str(racedef.wisdom)

# Obviously change this to real values
func _on_class_item_list_item_selected(index: int) -> void:
	var classDef: CharacterClass = classes[index]
	hp_lvl_value.text = str(classDef.hp_per_lvl)
	main_stat_value.text = str(GlobalEnums.StatType.find_key(classDef.main_stat))
	second_stat_value.text = str(GlobalEnums.StatType.find_key(classDef.secondary_stat))
