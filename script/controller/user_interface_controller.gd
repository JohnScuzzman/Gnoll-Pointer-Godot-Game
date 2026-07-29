extends CanvasLayer

@export var events_container: BoxContainer
@export var event_box_scroll_container: ScrollContainer

@export var game_over_panel: Panel
@export var game_over_container: BoxContainer
@export var main_menu_button: Button

var game_over_visible: bool

func _ready() -> void:
	game_over_panel.visible = false
	game_over_container.visible = false
	game_over_visible = false

func add_event_log(message: String) -> void:
	var new_log: Label = Label.new()
	new_log.text = message
	events_container.add_child(new_log)
	# TODO: This technically locks the entire game for a single frame using a signal would be better
	await get_tree().process_frame
	event_box_scroll_container.scroll_vertical = int(event_box_scroll_container.get_v_scroll_bar().max_value)

func show_game_over_screen() -> void:
	game_over_panel.visible = true
	game_over_container.visible = true

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu/main_menu.tscn")
