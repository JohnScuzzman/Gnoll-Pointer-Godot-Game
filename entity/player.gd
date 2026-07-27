extends BaseEntity

@export var rest_rate = 1

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

var is_resting = false

func _ready():
	add_to_group("player")
	sprite.offset = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.shape.size = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.shape.size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)

func try_move_or_colide(input_direction):
	var new_player_position: Vector2
	
	shape_cast.target_position = Vector2.ZERO
	shape_cast.force_shapecast_update()
	
	if (input_direction.x < 0):
		sprite.flip_h = false
		shape_cast.target_position = Vector2(-(GlobalVariable.tile_size / 2.0), 0)
		new_player_position = get_rounded_vector2(global_position.x - GlobalVariable.tile_size, global_position.y)
	elif (input_direction.x > 0):
		sprite.flip_h = true
		shape_cast.target_position = Vector2((GlobalVariable.tile_size / 2.0), 0)
		new_player_position = get_rounded_vector2(global_position.x + GlobalVariable.tile_size, global_position.y)
	elif (input_direction.y < 0):
		shape_cast.target_position = Vector2(0, -(GlobalVariable.tile_size / 2.0))
		new_player_position = get_rounded_vector2(global_position.x, global_position.y - GlobalVariable.tile_size)
	elif (input_direction.y > 0):
		shape_cast.target_position = Vector2(0, (GlobalVariable.tile_size / 2.0))
		new_player_position = get_rounded_vector2(global_position.x, global_position.y + GlobalVariable.tile_size)
	
	shape_cast.force_shapecast_update()
	
	if shape_cast.is_colliding():
		return shape_cast.get_collider(0)
	else:
		global_position = new_player_position
		
	return null
		
func get_rounded_vector2(x, y) -> Vector2:
	return Vector2(round(x / GlobalVariable.tile_size) * GlobalVariable.tile_size, round(y / GlobalVariable.tile_size) * GlobalVariable.tile_size)
	
func on_hit(value):
	value -= stats.armor_class
	stats.health_points -= value

func can_rest():
	return stats.health_points < stats.max_health_points
	
func on_rest():
	stats.health_points += rest_rate
	if (stats.health_points >= stats.max_health_points):
		stats.health_points = stats.max_health_points
		is_resting = false;
