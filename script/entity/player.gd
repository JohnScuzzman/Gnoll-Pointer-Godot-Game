extends BaseEntity

@export var rest_rate: int = 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

var user_interface: Node
var is_resting: bool = false
var can_rest: bool = false
var is_dead: bool = false
var turns_rested: int = 0

func _ready() -> void:
	add_to_group("player")
	sprite.offset = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.shape.size = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.shape.size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)

func try_move_or_colide(input_direction: Vector2) -> CollisionObject2D:
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
		
func get_rounded_vector2(x: float, y: float) -> Vector2:
	return Vector2(round(x / GlobalVariable.tile_size) * GlobalVariable.tile_size, round(y / GlobalVariable.tile_size) * GlobalVariable.tile_size)
	
func on_hit(value: int) -> int:
	value -= stats.armor_class
	update_health(-value)
	return value

func update_health(value: int) -> void:
	stats.health_points += value
	
	if (stats.health_points <= 0):
		stats.health_points = 0
		is_dead = true
		
	if (stats.health_points > stats.max_health_points):
		stats.health_points = stats.max_health_points
		
	can_rest = stats.health_points < stats.max_health_points
	
func on_rest() -> void:
	update_health(rest_rate)
	turns_rested += 1
	if (!can_rest):
		user_interface.add_event_log("You rested for " + str(turns_rested) + " turn(s)")
		turns_rested = 0
		is_resting = false;
