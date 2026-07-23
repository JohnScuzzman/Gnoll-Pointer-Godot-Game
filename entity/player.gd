extends BaseEntity

@export var tile_size : float = 16

@onready var sprite = $Sprite2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

func _ready():
	add_to_group("player")

func try_move_or_colide(input_direction):
	var new_player_position: Vector2
	
	shape_cast.target_position = Vector2.ZERO
	shape_cast.force_shapecast_update()
	
	if (input_direction.x < 0):
		sprite.flip_h = false
		shape_cast.target_position = Vector2(-(tile_size / 2), 0)
		new_player_position = get_rounded_vector2(global_position.x - tile_size, global_position.y)
	elif (input_direction.x > 0):
		sprite.flip_h = true
		shape_cast.target_position = Vector2((tile_size / 2), 0)
		new_player_position = get_rounded_vector2(global_position.x + tile_size, global_position.y)
	elif (input_direction.y < 0):
		shape_cast.target_position = Vector2(0, -(tile_size / 2))
		new_player_position = get_rounded_vector2(global_position.x, global_position.y - tile_size)
	elif (input_direction.y > 0):
		shape_cast.target_position = Vector2(0, (tile_size / 2))
		new_player_position = get_rounded_vector2(global_position.x, global_position.y + tile_size)
	
	shape_cast.force_shapecast_update()
	
	if shape_cast.is_colliding():
		return shape_cast.get_collider(0)
	else:
		global_position = new_player_position
		
	return null
		
func get_rounded_vector2(x, y) -> Vector2:
	return Vector2(round(x / tile_size) * tile_size, round(y / tile_size) * tile_size)
	
func on_hit(value):
	# TODO : Calculate on hit and modifiy values
	print("Modify player attribute")
