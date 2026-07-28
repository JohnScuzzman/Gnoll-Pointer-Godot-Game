extends RigidBody2D

@export var death_texture : Texture2D

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

var game_level_reference
#PlaceHolder
var entity_name = "Kobold"
var hp = 1
var armor_value = 0

func _ready():
	add_to_group("enemy")
	gravity_scale = 0
	sprite.offset = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.shape.size = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.shape.size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)

func on_hit(value):
	value -= armor_value
	hp -= value
	if !is_alive():
		on_death()
	return value
		
func is_alive():
	return hp > 0

func on_death():
	game_level_reference.active_enemies.erase(self)
	sprite.texture = death_texture
	collision_shape.disabled = true
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
				shape_cast.target_position = Vector2((GlobalVariable.tile_size / 2.0), 0)
				new_position = get_rounded_vector2(global_position.x + GlobalVariable.tile_size, global_position.y)
			else: 
				sprite.flip_h = false
				shape_cast.target_position = Vector2(-(GlobalVariable.tile_size / 2.0), 0)
				new_position = get_rounded_vector2(global_position.x - GlobalVariable.tile_size, global_position.y)
		else:
			if direction.y > 0: 
				shape_cast.target_position = Vector2(0, (GlobalVariable.tile_size / 2.0))
				new_position = get_rounded_vector2(global_position.x, global_position.y + GlobalVariable.tile_size)
			else: 
				shape_cast.target_position = Vector2(0, -(GlobalVariable.tile_size / 2.0))
				new_position = get_rounded_vector2(global_position.x, global_position.y - GlobalVariable.tile_size)
		
		shape_cast.force_shapecast_update()
		
		if shape_cast.is_colliding():
			return shape_cast.get_collider(0)
		else:
			global_position = new_position
			
	return null

# TODO : Use the global variable instead
func get_rounded_vector2(x, y) -> Vector2:
	return Vector2(round(x / GlobalVariable.tile_size) * GlobalVariable.tile_size, round(y / GlobalVariable.tile_size) * GlobalVariable.tile_size)
