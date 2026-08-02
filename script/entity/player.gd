extends BaseEntity

@export var rest_rate: int = 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D
@onready var north_ray_cast_2D: RayCast2D = $NorthRayCast2D
@onready var south_ray_cast_2D: RayCast2D = $SouthRayCast2D
@onready var east_ray_cast_2D: RayCast2D = $EastRayCast2D
@onready var west_ray_cast_2D: RayCast2D = $WestRayCast2D

var game_level_reference: Node

var user_interface: Node
var is_resting: bool = false
var can_rest: bool = false
var can_move: bool = true
var is_dead: bool = false
var turns_rested: int = 0
# TODO : Update target_position based on if entity is enemy to follow them
var target_position: Variant = null
var target_interaction: Object

func _ready() -> void:
	add_to_group("player")
	sprite.offset = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.shape.size = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.target_position = Vector2.ZERO
	collision_shape.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.shape.size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)
	
	north_ray_cast_2D.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	north_ray_cast_2D.target_position = Vector2(0, -GlobalVariable.tile_size / 2.0)
	south_ray_cast_2D.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	south_ray_cast_2D.target_position = Vector2(0, GlobalVariable.tile_size / 2.0)
	east_ray_cast_2D.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	east_ray_cast_2D.target_position = Vector2(GlobalVariable.tile_size / 2.0, 0)
	west_ray_cast_2D.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	west_ray_cast_2D.target_position = Vector2(-GlobalVariable.tile_size / 2.0, 0)
	
	stats.level = 1
	stats.next_level_experience = get_required_xp(0)
	user_interface.update_ui(self)

func try_move_or_colide(input_direction: Vector2) -> Object:
	var new_player_position: Vector2 = \
		get_rounded_vector2(global_position.x + (input_direction.x * GlobalVariable.tile_size), 
							global_position.y + (input_direction.y * GlobalVariable.tile_size))
												
	shape_cast.position = \
		Vector2((GlobalVariable.tile_size / 2.0) + (input_direction.x * (GlobalVariable.tile_size)), 
				(GlobalVariable.tile_size / 2.0) + (input_direction.y * (GlobalVariable.tile_size)))
	
	if (input_direction.x < 0):
		sprite.flip_h = false
	elif (input_direction.x > 0):
		sprite.flip_h = true
	
	shape_cast.force_shapecast_update()
	
	if shape_cast.is_colliding():
		target_position = null
		target_interaction = null
		return shape_cast.get_collider(0)
	else:
		global_position = new_player_position
		if (target_position == global_position):
			target_position = null
			if (target_interaction != null):
				var saved_target_interaction: Object = target_interaction
				target_interaction = null
				return saved_target_interaction
	return null

func set_target_position(target: Variant) -> void:
	target_position = get_rounded_vector2(target.x - (GlobalVariable.tile_size / 2.0), target.y - (GlobalVariable.tile_size / 2.0))

func get_next_target_position_step() -> Variant:
	if (target_position != null):
		var potential_next_move: Variant = get_next_step(
			Vector2((global_position.x / GlobalVariable.tile_size), (global_position.y / GlobalVariable.tile_size)),
			Vector2((target_position.x / GlobalVariable.tile_size), (target_position.y / GlobalVariable.tile_size)))
		if (potential_next_move != null):
			potential_next_move -= global_position
			
			if (potential_next_move.x > 0):
				potential_next_move.x = 1
			elif(potential_next_move.x < 0):
				potential_next_move.x = -1
				
			if (potential_next_move.y > 0):
				potential_next_move.y = 1
			elif(potential_next_move.y < 0):
				potential_next_move.y = -1
				
			return potential_next_move
	return null

func get_next_step(start: Vector2i, target: Vector2i) -> Variant:
	if game_level_reference.astar.is_in_bounds(start.x, start.y) && game_level_reference.astar.is_in_bounds(target.x, target.y):
		var moves_to_target: PackedVector2Array = game_level_reference.astar.get_point_path(start, target)
		print(moves_to_target)
		if (game_level_reference.astar.get_point_path(start, target).size() > 1):
			return moves_to_target[1]
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
	# TODO : Probably only update the health
	user_interface.update_ui(self)

func update_xp(value: int) -> void:
	stats.experience += value
	if (stats.experience >= stats.next_level_experience):
		stats.experience = stats.next_level_experience - stats.experience
		level_up()
		
	# TODO : Probably only update the health
	user_interface.update_ui(self)

func level_up() -> void:
	stats.next_level_experience = get_required_xp(stats.level)
	stats.level += 1

func get_required_xp(level: int) -> int:
	return int(100 + (level * level * 10))
	
func on_rest() -> void:
	update_health(rest_rate)
	turns_rested += 1
	if (!can_rest):
		user_interface.add_event_log("You rested for " + str(turns_rested) + " turn(s)")
		turns_rested = 0
		is_resting = false;

func check_for_interactable() -> Object:
	if north_ray_cast_2D.is_colliding():
		return north_ray_cast_2D.get_collider()
	if south_ray_cast_2D.is_colliding():
		return south_ray_cast_2D.get_collider()
	if east_ray_cast_2D.is_colliding():
		return east_ray_cast_2D.get_collider()
	if west_ray_cast_2D.is_colliding():
		return west_ray_cast_2D.get_collider()
	return null
