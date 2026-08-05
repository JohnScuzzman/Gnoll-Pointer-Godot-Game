extends Node2D

@export var turn_cooldown : float = 0.1
@export var user_interface: CanvasLayer
@export var dialogue_interface: CanvasLayer
@export var main_camera: Camera2D
@export var tile_map_layer_floor: TileMapLayer

@onready var turn_timer: Timer = $TurnTimer

const PLAYER_SCENE = preload("res://scene/entity/player.tscn")
const ENEMY_EXAMPLE_SCENE = preload("res://scene/entity/enemy/enemy_example.tscn")

var is_scene_ready: bool = false
var player: BaseEntity
var player_name: String
var player_class: Resource
var player_race: Resource

var active_entities: Array[Node]
var is_player_turn: bool = true
var is_game_over: bool = false

var astar: AStarGrid2D = AStarGrid2D.new()

#Delete this later DebugValue
var turn: int = 1

func _ready() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = Vector2(GlobalVariable.tile_size * 3, GlobalVariable.tile_size * 3)
	var stats: Stats = Stats.new()
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
	player.user_interface = user_interface
	player.game_level_reference = self
	add_child(player)
	
	player.get_node("RemoteTransform2D").remote_path = main_camera.get_path()
	
	print("Start of turn " + str(turn))
	initialize_astar()

func initialize_astar() -> void:
	astar.region = tile_map_layer_floor.get_used_rect()
	astar.cell_size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar.update()
		
	for layer: TileMapLayer in find_children("", "TileMapLayer", true, false):
		for cell: Vector2i in layer.get_used_cells():
			var tile_data: TileData = layer.get_cell_tile_data(cell)
			if tile_data && tile_data.get_collision_polygons_count(0) > 0:
				astar.set_point_solid(cell, true)

func _physics_process(_delta: float) -> void:
	if (!is_game_over):
		if (player.is_dead && !user_interface.game_over_visible):
			user_interface.show_game_over_screen()
			is_game_over = true
			
		if (is_player_turn && player.can_move):
			if (player.is_resting):
				player.on_rest()
				end_player_turn()
				return
			
			var next_move: Variant = player.get_next_target_position_step()
			if (player.target_position == null):
				next_move = Vector2(
					Input.get_action_strength("right") - Input.get_action_strength("left"),
					Input.get_action_strength("down") - Input.get_action_strength("up"))
					
			if ((next_move != null && next_move != Vector2.ZERO) || player.target_interaction != null):
				
				var interacted_entity: Object 
				if (next_move != null && next_move != Vector2.ZERO):
					interacted_entity = player.try_move_or_colide(next_move)
				else:
					interacted_entity = player.target_interaction
					player.target_interaction = null
				
				if (interacted_entity != null):
					if (interacted_entity.is_in_group("enemy")):
						print("Player colided with an enemy")
						user_interface.add_event_log("You hit " + interacted_entity.entity_name + " for " + str(interacted_entity.on_hit(1)) + " damage")
						if (interacted_entity.is_dead):
							player.update_xp(interacted_entity.xp_drop)
						end_player_turn()
					elif (interacted_entity.is_in_group("interactable")):
						user_interface.toggle_inventory_screen(player, interacted_entity)
					elif (interacted_entity.is_in_group("npc")):
						dialogue_interface.start_dialogue(interacted_entity.entity_name, interacted_entity.dialogue_lines)
				else:
					if(dialogue_interface):
						dialogue_interface.end_dialogue()
					end_player_turn()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("skip_turn")):
		end_player_turn()
	
	if (event.is_action_pressed("inventory")):
		user_interface.toggle_inventory_screen(player, null)
	
	if (event.is_action_pressed("rest") && player.can_rest):
		player.is_resting = true
		end_player_turn()
	
	if event.is_action_pressed("interact"):
		var colider: Object = player.check_for_interactable()
		if colider != null && colider.get_parent().is_in_group("interactable"):
			user_interface.toggle_inventory_screen(player, colider.get_parent())
		
	if event.is_action_pressed("spawn"):
		var test_enemy: Node = ENEMY_EXAMPLE_SCENE.instantiate()
		test_enemy.global_position = Vector2(player.global_position.x + (GlobalVariable.tile_size * 3), player.global_position.y)
		test_enemy.game_level_reference = self
		add_child(test_enemy)
		
	if (event is InputEventMouseButton and event.pressed &&
			event.button_index == MOUSE_BUTTON_LEFT && player.can_move):
		player.set_target_position(get_global_mouse_position())

func end_player_turn() -> void:
	print("End of player turn")
	is_player_turn = false
	turn_timer.start(turn_cooldown)
	
func _on_turn_timer_timeout() -> void:
	enemy_turn()

func enemy_turn() -> void: 
	print("Start of enemy turn")
	
	for active_entity: Node in active_entities:
		if (active_entity.is_in_group("enemy") && active_entity.is_aggressive):
			var enemy_collision: Object = active_entity.execute_turn(player)
			if (enemy_collision != null && enemy_collision.is_in_group("player")):
				user_interface.add_event_log(active_entity.entity_name + " hit you for " + str(player.on_hit(1)) +  " damage")
				
	# This is for debug delete eventually
	print("End of enemy turn")
	turn += 1
	print("Start of turn " + str(turn))
	is_player_turn = true
