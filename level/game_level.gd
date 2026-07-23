extends Node2D

@export var player_input_cooldown : float = 0.1
@export var user_interface: CanvasLayer
@export var main_camera: Camera2D

@onready var player_input_cooldown_timer = $PlayerInputCooldown

const PLAYER_SCENE = preload("res://entity/player.tscn")

var player: BaseEntity
var player_name
var player_class
var player_race

var can_move: bool = true

func _ready() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = Vector2(64,64)
	add_child(player)
	
	player.get_node("RemoteTransform2D").remote_path = main_camera.get_path()
	
	print("This is where you would set stuff about the player")
	user_interface.get_node("DebugLabel").text = "Name: " + str(player_name) + " Class: " + str(player_class) + " Race: " + str(player_race)

func _unhandled_input(_event):
	if ((Input.is_action_just_pressed("right") || Input.is_action_just_pressed("left") || 
		Input.is_action_just_pressed("down") || Input.is_action_just_pressed("up")) &&
		can_move == true):
			
		var input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up"))
			
		if (input_direction != Vector2.ZERO):
			can_move = false
			player_input_cooldown_timer.start(player_input_cooldown)
			
			var player_collision = player.try_move_or_colide(input_direction)
			if (player_collision != null):
				print(player_collision.name)
				if player_collision.is_in_group("enemy"):
					print("Colided with an enemy")
					
					#This is just an example but basically do any sort of combat 
					#calculation with whoever is invovled
					player_collision.on_hit()
					player.on_hit()
				else:
					print("Colided with an obstacle")
			
			print("End of turn")
			
func _on_player_input_cooldown_timeout() -> void:
	can_move = true
	
# I Recomend moving this in a bar entity or whatever
func _on_bar_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
