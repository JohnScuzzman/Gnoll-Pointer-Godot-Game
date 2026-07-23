extends RigidBody2D

@export var tile_size : float = 16
@export var death_texture : Texture2D

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

var game_level_reference
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
	game_level_reference.active_enemies.erase(self)
	sprite.texture = death_texture
	collision_shape.set_deferred("disabled",true)
	remove_from_group("enemy")
	add_to_group("interactable")

# TODO : Use the global variable instead
func execute_turn(player):
	if (is_alive):
		shape_cast.target_position = Vector2.ZERO
		shape_cast.force_shapecast_update()
		
		var new_position: Vector2
		
		# TODO : Implement actual path finding instead of going for the player only
		var direction = global_position.direction_to(player.global_position)
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0: 
				sprite.flip_h = true
				shape_cast.target_position = Vector2((tile_size / 2), 0)
				new_position = get_rounded_vector2(global_position.x + tile_size, global_position.y)
			else: 
				sprite.flip_h = false
				shape_cast.target_position = Vector2(-(tile_size / 2), 0)
				new_position = get_rounded_vector2(global_position.x - tile_size, global_position.y)
		else:
			if direction.y > 0: 
				shape_cast.target_position = Vector2(0, (tile_size / 2))
				new_position = get_rounded_vector2(global_position.x, global_position.y + tile_size)
			else: 
				shape_cast.target_position = Vector2(0, -(tile_size / 2))
				new_position = get_rounded_vector2(global_position.x, global_position.y - tile_size)
		
		shape_cast.force_shapecast_update()
		
		if shape_cast.is_colliding():
			return shape_cast.get_collider(0)
		else:
			global_position = new_position
			
	return null

# TODO : Use the global variable instead
func get_rounded_vector2(x, y) -> Vector2:
	return Vector2(round(x / tile_size) * tile_size, round(y / tile_size) * tile_size)
