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

func _ready() -> void:
	class_item_list.select(0)
	_on_class_item_list_item_selected(0)
	race_item_list.select(0)
	_on_race_item_list_item_selected(0)

func _on_start_pressed() -> void:
	var next_scene_packed = load("res://level/game_level.tscn")
	var next_scene_instance = next_scene_packed.instantiate()
	next_scene_instance.player_name = name_text_edit.text
	next_scene_instance.player_class = class_item_list.get_item_text(class_item_list.get_selected_items()[0])
	next_scene_instance.player_race = race_item_list.get_item_text(race_item_list.get_selected_items()[0])
	get_tree().root.add_child(next_scene_instance)
	get_tree().current_scene = next_scene_instance
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()

# Obviously change this to real values
func _on_race_item_list_item_selected(index: int) -> void:
	hp_value.text = str(randi_range(1, 10))
	cha_value.text = str(randi_range(1, 10))
	int_value.text = str(randi_range(1, 10))
	con_value.text = str(randi_range(1, 10))
	str_value.text = str(randi_range(1, 10))
	dex_value.text = str(randi_range(1, 10))
	wis_value.text = str(randi_range(1, 10))

# Obviously change this to real values
func _on_class_item_list_item_selected(index: int) -> void:
	hp_lvl_value.text = str(randi_range(1, 10))
	main_stat_value.text = str(randi_range(1, 10))
	second_stat_value.text = str(randi_range(1, 10))
