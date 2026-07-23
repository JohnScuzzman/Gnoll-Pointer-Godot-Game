extends Node2D

@export var player_input_cooldown : float = 0.1
@export var user_interface: CanvasLayer
@export var main_camera: Camera2D

@onready var player_input_cooldown_timer = $PlayerInputCooldown

const PLAYER_SCENE = preload("res://entity/player.tscn")
const ENEMY_EXAMPLE_SCENE = preload("res://entity/enemy_example.tscn")

var player: BaseEntity
var player_name
var player_class
var player_race

var active_enemies: Array
var turns_to_skip = 0
var is_player_turn: bool = true

#Delete this later DebugValue
var turn = 1

func _ready() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = Vector2(64,64)
	add_child(player)
	
	player.get_node("RemoteTransform2D").remote_path = main_camera.get_path()
	
	print("This is where you would set stuff about the player")
	user_interface.get_node("DebugLabel").text = "Name: " + str(player_name) + " Class: " + str(player_class) + " Race: " + str(player_race)

func _physics_process(_delta: float) -> void:
	if (turns_to_skip > 0):
		print("Player turn skipped")
		turns_to_skip -= 1
		enemy_turn()
	
	var input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up"))
			
	if (is_player_turn == true && input_direction != Vector2.ZERO):
		is_player_turn = false
		player_input_cooldown_timer.start(player_input_cooldown)
		
		var player_collision = player.try_move_or_colide(input_direction)
		if (player_collision != null):
			print(player_collision.name)
			if player_collision.is_in_group("enemy"):
				print("Colided with an enemy")
				# TODO : Combat
				player_collision.on_hit(1)
			else:
				print("Colided with an obstacle")
		
		print("End of player turn")
		enemy_turn()

func _unhandled_input(event: InputEvent) -> void:
	if (is_player_turn && event.is_action_pressed("rest") || 
		event.is_action_pressed("interact") || event.is_action_pressed("spawn")):
			
		is_player_turn = false
		player_input_cooldown_timer.start(player_input_cooldown)
		
		if event.is_action_pressed("rest"):
			turns_to_skip = 2;
		
		if event.is_action_pressed("interact"):
			print("Check North, South, West, East, Current Position for an interactable and call its on_interact function")
			
		if event.is_action_pressed("spawn"):
			var test_enemy = ENEMY_EXAMPLE_SCENE.instantiate()
			test_enemy.global_position = Vector2(player.global_position.x + 64, player.global_position.y)
			test_enemy.game_level_reference = self
			add_child(test_enemy)
			active_enemies.append(test_enemy)
		
		print("End of player turn")
		enemy_turn()

func spawn_enemy() -> void:
	is_player_turn = true
	
# TODO : There is a weird behaviour where the enemy can end up under the player 
# as like its trying to move even tho its dead. Investigate
func enemy_turn(): 
	for active_enemy in active_enemies:
		var enemy_collision = active_enemy.execute_turn(player)
		if (enemy_collision != null && enemy_collision.is_in_group("player")):
			print("Enemy colided with player")
			player.on_hit(1)
	
	# This is for debug delete eventually
	print("End of enemy turn")
	turn += 1
	print("Start of turn ", turn)

func _on_player_input_cooldown_timeout() -> void:
	is_player_turn = true
