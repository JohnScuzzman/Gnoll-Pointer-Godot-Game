extends Control

@onready var play_button = get_node("MainContainer/ButtonContainer/PlayButton")
@onready var quit_button = get_node("MainContainer/ButtonContainer/QuitButton")
@onready var class_item_list = get_node("MainContainer/SelectorContainer/ClassContainer/ClassItemList")
@onready var race_item_list = get_node("MainContainer/SelectorContainer/RaceContainer/RaceItemList")
@onready var name_text_edit = get_node("MainContainer/SelectorContainer/NameTextEdit")

@onready var hp_lvl_value = get_node("MainContainer/SelectorContainer/ClassContainer/ClassStatContainer/HpLvlContainer/Value")
@onready var main_stat_value = get_node("MainContainer/SelectorContainer/ClassContainer/ClassStatContainer/MainStatContainer/Value")
@onready var second_stat_value = get_node("MainContainer/SelectorContainer/ClassContainer/ClassStatContainer/SecondStatContainer/Value")

@onready var hp_value = get_node("MainContainer/SelectorContainer/RaceContainer/RaceStatContainer/StatContainer/StatRowContainer/HpContainer/Value")
@onready var cha_value = get_node("MainContainer/SelectorContainer/RaceContainer/RaceStatContainer/StatContainer/StatRowContainer2/ChaContainer/Value")
@onready var int_value = get_node("MainContainer/SelectorContainer/RaceContainer/RaceStatContainer/StatContainer/StatRowContainer2/IntContainer/Value")
@onready var con_value = get_node("MainContainer/SelectorContainer/RaceContainer/RaceStatContainer/StatContainer/StatRowContainer3/ConContainer/Value")
@onready var str_value = get_node("MainContainer/SelectorContainer/RaceContainer/RaceStatContainer/StatContainer/StatRowContainer3/StrContainer/Value")
@onready var dex_value = get_node("MainContainer/SelectorContainer/RaceContainer/RaceStatContainer/StatContainer/StatRowContainer4/DexContainer/Value")
@onready var wis_value = get_node("MainContainer/SelectorContainer/RaceContainer/RaceStatContainer/StatContainer/StatRowContainer4/WisContainer/Value")

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
