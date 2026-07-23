extends RigidBody2D

@export var tile_size : float = 16
@export var death_texture : Texture2D

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

#PlaceHolder
var hp = 1
var armor_value = 0

func _ready():
	add_to_group("enemy")

func on_hit(value):
	value -= armor_value
	hp -= value
	if !is_alive():
		on_death()
		
func is_alive():
	return hp > 0

func on_death():
	sprite.texture = death_texture
	collision_shape.disabled = true
	remove_from_group("enemy")
	add_to_group("interactable")

# TODO : Use the global variable instead
func execute_turn(player):
	# Eventualy replace this with actual path finding but this is the concept
	var direction = global_position.direction_to(player.global_position)
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0: 
			global_position = get_rounded_vector2(global_position.x + tile_size, global_position.y)
		else: 
			global_position = get_rounded_vector2(global_position.x - tile_size, global_position.y)
	else:
		if direction.y > 0: 
			global_position = get_rounded_vector2(global_position.x, global_position.y + tile_size)
		else: 
			global_position = get_rounded_vector2(global_position.x, global_position.y - tile_size)
	
	# Implement reverse turn logic where monster hit player 
	# We should probably return a shapecast just like with player 
	#to keep most of the logic in the game level controler

# TODO : Use the global variable instead
func get_rounded_vector2(x, y) -> Vector2:
	return Vector2(round(x / tile_size) * tile_size, round(y / tile_size) * tile_size)
