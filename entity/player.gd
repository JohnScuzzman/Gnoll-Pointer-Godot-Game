extends CharacterBody2D

@export var walk_cooldown : float = 0.1
@export var tile_size : float = 16

@onready var sprite = $Sprite2D
@onready var timer = $Timer

var can_move: bool = true
var hitbox_tile_size : float

func _ready() -> void:
	# Margin to avoid clipping through collisions
	hitbox_tile_size = tile_size - 7

func _physics_process(delta: float) -> void:
	var input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
	
	if can_move == true && input_direction != Vector2.ZERO:
		timer.start(walk_cooldown)
		
		var target_position: Vector2
		if (input_direction.x < 0):
			sprite.flip_h = false
			target_position = Vector2(global_position.x - hitbox_tile_size, global_position.y)
		elif (input_direction.x > 0):
			sprite.flip_h = true
			target_position = Vector2(global_position.x + hitbox_tile_size, global_position.y)
		elif (input_direction.y < 0):
			target_position = Vector2(global_position.x, global_position.y - hitbox_tile_size)
		elif (input_direction.y > 0):
			target_position = Vector2(global_position.x, global_position.y + hitbox_tile_size)
		can_move = false
		
		var distance_to_target = position.distance_to(target_position)
		if distance_to_target > 0:
			# Move velocity directly towards target
			velocity = position.direction_to(target_position) * 100000
			
			# If speed will overshoot, cap it exactly at the target
			if distance_to_target < velocity.length() * delta:
				velocity = Vector2.ZERO
				position = target_position
		
		move_and_slide()
		global_position = get_rounded_vector2(global_position)

func get_rounded_vector2(position_value: Vector2) -> Vector2:
	return Vector2(round(position_value.x / tile_size) * tile_size, round(position_value.y / tile_size) * tile_size)

func _on_timer_timeout() -> void:
	can_move = true
