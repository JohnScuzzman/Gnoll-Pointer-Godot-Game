extends CanvasLayer

@export var events_container: BoxContainer
@export var event_box_scroll_container: ScrollContainer

@export var game_over_panel: Panel
@export var game_over_container: BoxContainer
@export var main_menu_button: Button

@export var debug_label: Label

@export var player_inventory_panel: Panel
@export var player_inventory_list: ItemList
@export var external_inventory_panel: Panel
@export var external_inventory_list: ItemList

var game_over_visible: bool

var inventory_visible: bool
var player_inventory_owner: BaseEntity
var external_inventory_owner: Node

func _ready() -> void:
	game_over_panel.visible = false
	game_over_container.visible = false
	game_over_visible = false
	
	player_inventory_panel.visible = false
	external_inventory_panel.visible = false
	inventory_visible = false

func update_ui(player: BaseEntity) -> void:
		debug_label.text = "Name: " + str(player.stats.name) + "\n" + \
			"Class: " + str(player.character_class.name) + "\n" + \
			"Race: " + str(player.race.name) + "\n" + \
			"HP: " + str(player.stats.health_points) + "\n" + \
			"Level: " + str(player.stats.level) + "\n" + \
			"XP: " + str(player.stats.experience) + " / " + str(player.stats.next_level_experience)

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

func toggle_inventory_screen(player: BaseEntity, external: Node) -> void:
	if (inventory_visible):
		player.can_move = true
		player_inventory_panel.visible = false
		external_inventory_panel.visible = false
		inventory_visible = false
		external_inventory_list.clear()
		player_inventory_list.clear()
	else:
		player.can_move = false
		player_inventory_panel.visible = true
		external_inventory_panel.visible = true
		inventory_visible = true
		fill_player_inventory(player.inventory)
		player_inventory_owner = player
		if (external != null):
			fill_external_inventory(external.inventory)
			external_inventory_owner = external

# TODO : Probably make this more granular we dont need to refresh the whole thing
func fill_player_inventory(player_inventory: Array[Item]) -> void:
	for player_item in player_inventory:
		player_inventory_list.add_item(player_item.name)

# TODO : Probably make this more granular we dont need to refresh the whole thing
func fill_external_inventory(external_inventory: Array[Item]) -> void:
	for external_item in external_inventory:
		external_inventory_list.add_item(external_item.name)

func _on_drop_button_pressed() -> void:
	if player_inventory_list.get_selected_items().size() > 0:
		var item_index:int = player_inventory_list.get_selected_items()[0]
		var item_name:String = player_inventory_list.get_item_text(item_index)
		
		external_inventory_list.add_item(item_name)
		player_inventory_list.remove_item(item_index)
		
		var index:int = 0
		var target_item:Item
		
		for item: Item in player_inventory_owner.inventory:
			if item.name == item_name:
				target_item = item
				break
			index += 1
		
		if (target_item != null):
			external_inventory_owner.inventory.append(target_item)
			player_inventory_owner.inventory.remove_at(index)
		

func _on_equip_button_pressed() -> void:
	if player_inventory_list.get_selected_items().size() > 0:
		var item_index:int = player_inventory_list.get_selected_items()[0]
		print("Equiping " + player_inventory_list.get_item_text(item_index))

func _on_take_button_pressed() -> void:
	if external_inventory_list.get_selected_items().size() > 0:
		var item_index:int = external_inventory_list.get_selected_items()[0]
		var item_name:String = external_inventory_list.get_item_text(item_index)
		
		player_inventory_list.add_item(item_name)
		external_inventory_list.remove_item(item_index)
		
		var index:int = 0
		var target_item:Item
		
		for item: Item in external_inventory_owner.inventory:
			if item.name == item_name:
				target_item = item
				break
			index += 1
		
		if (target_item != null):
			player_inventory_owner.inventory.append(target_item)
			external_inventory_owner.inventory.remove_at(index)

func _on_close_button_pressed() -> void:
	toggle_inventory_screen(player_inventory_owner, external_inventory_owner)
