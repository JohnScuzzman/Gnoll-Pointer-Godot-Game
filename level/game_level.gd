extends Node2D

@export var turn_cooldown : float = 0.1
@export var user_interface: CanvasLayer
@export var main_camera: Camera2D
@export var tile_map_layer: TileMapLayer

@onready var turn_timer = $TurnTimer

const PLAYER_SCENE = preload("res://entity/player.tscn")
const ENEMY_EXAMPLE_SCENE = preload("res://entity/enemy_example.tscn")

var player: BaseEntity
var player_name
var player_class: Resource
var player_race: Resource

var active_enemies: Array
var is_player_turn: bool = true

var events_container: BoxContainer
var event_box_scroll_container: ScrollContainer
var astar: AStarGrid2D = AStarGrid2D.new()

#Delete this later DebugValue
var turn = 1

func _ready() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = Vector2(GlobalVariable.tile_size * 3, GlobalVariable.tile_size * 3)
	var stats = Stats.new()
	stats.name = str(player_name)
	stats.max_health_points = player_race.max_health_points
	stats.health_points = player_race.health_points
	stats.charisma = player_race.charisma
	stats.intelligence = player_race.intelligence
	stats.constitution = player_race.constitution
	stats.strength = player_race.strength
	stats.dexterity = player_race.dexterity
	stats.wisdom = player_race.wisdom
	player.stats = stats
	player.character_class = player_class
	player.race = player_race
	player.game_level = self
	add_child(player)
	
	player.get_node("RemoteTransform2D").remote_path = main_camera.get_path()
	
	event_box_scroll_container = user_interface.get_node("EventBoxContainer/EventBoxScrollContainer")
	events_container = event_box_scroll_container.get_node("EventsContainer")
	
	print("Start of turn " + str(turn))
	initialize_astar()

func initialize_astar() -> void:
	var rect = tile_map_layer.get_used_rect()
	astar.region = rect
	astar.cell_size = tile_map_layer.tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()

	for cell in tile_map_layer.get_used_cells():
		var tile_data = tile_map_layer.get_cell_tile_data(cell)
		if tile_data and tile_data.get_collision_polygons_count(0) > 0:
			astar.set_point_solid(cell, true)

func update_ui():
		user_interface.get_node("DebugLabel").text = "Name: " + str(player.stats.name) + "\n" + \
			"Class: " + str(player.character_class.name) + "\n" + \
			"Race: " + str(player.race.name) + "\n" + \
			"HP: " + str(player.stats.health_points)

func _physics_process(_delta: float) -> void:
	update_ui()
	
	if (is_player_turn):
		if (player.is_resting):
			player.on_rest()
			end_player_turn()
	
		var input_direction = Vector2(
				Input.get_action_strength("right") - Input.get_action_strength("left"),
				Input.get_action_strength("down") - Input.get_action_strength("up"))
				
		if (input_direction != Vector2.ZERO):
			var player_collision = player.try_move_or_colide(input_direction)
			if (player_collision != null):
				if player_collision.is_in_group("enemy"):
					print("Player colided with an enemy")
					add_event_log("You hit " + player_collision.entity_name + " for " + str(player_collision.on_hit(1)) + " damage")
					end_player_turn()
				else:
					print("Player colided with an obstacle")
			else:
				end_player_turn()

func _unhandled_input(event: InputEvent) -> void:
	if (is_player_turn && event.is_action_pressed("rest") || 
		event.is_action_pressed("interact") || event.is_action_pressed("spawn") ||
		event.is_action_pressed("skip_turn")):
		
		if (event.is_action_pressed("skip_turn")):
			end_player_turn()
		
		if (event.is_action_pressed("rest") && player.can_rest()):
			player.is_resting = true
			end_player_turn()
		
		if event.is_action_pressed("interact"):
			print("Check North, South, West, East, Current Position for an interactable and call its on_interact function")
			
		if event.is_action_pressed("spawn"):
			var test_enemy = ENEMY_EXAMPLE_SCENE.instantiate()
			test_enemy.global_position = Vector2(player.global_position.x + (GlobalVariable.tile_size * 3), player.global_position.y)
			test_enemy.game_level_reference = self
			test_enemy.astar = astar
			add_child(test_enemy)
			active_enemies.append(test_enemy)

func end_player_turn():
	print("End of player turn")
	is_player_turn = false
	turn_timer.start(turn_cooldown)
	
func _on_turn_timer_timeout() -> void:
	enemy_turn()
	
func enemy_turn(): 
	print("Start of enemy turn")
	
	for active_enemy in active_enemies:
		var enemy_collision = active_enemy.execute_turn(player)
		if (enemy_collision != null && enemy_collision.is_in_group("player")):
			add_event_log(active_enemy.entity_name + " hit you for " + str(player.on_hit(1)) +  " damage")
					
	
	# This is for debug delete eventually
	print("End of enemy turn")
	turn += 1
	print("Start of turn " + str(turn))
	is_player_turn = true
	
func add_event_log(message):
	var new_log = Label.new()
	new_log.text = message
	events_container.add_child(new_log)
	# TODO: This technically locks the entire game for a single frame using a signal would be better
	await get_tree().process_frame
	event_box_scroll_container.scroll_vertical = int(event_box_scroll_container.get_v_scroll_bar().max_value)
