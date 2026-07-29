extends RigidBody2D

@export var death_texture : Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

var game_level_reference: Node
var astar: AStarGrid2D

var is_dead: bool = false

#PlaceHolder
var entity_name: String = "Kobold"
var hp_max: int = 1
var hp: int = hp_max
var armor_value: int = 0

func _ready() -> void:
	add_to_group("enemy")
	gravity_scale = 0
	sprite.offset = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.shape.size = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.shape.size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)

func on_hit(value: int) -> int:
	value -= armor_value
	update_health(-value)
	return value
	
func update_health(value: int) -> void:
	hp += value
	
	if (hp <= 0):
		hp = 0
		is_dead = true
		on_death()
		
	if (hp > hp_max):
		hp = hp_max

func on_death() -> void:
	game_level_reference.active_enemies.erase(self)
	sprite.texture = death_texture
	collision_shape.disabled = true
	remove_from_group("enemy")
	add_to_group("interactable")

func execute_turn(player: Node) -> CollisionObject2D:
	if (!is_dead):
		shape_cast.target_position = Vector2.ZERO
		shape_cast.force_shapecast_update()
		
		var next_move: Vector2 = get_next_move(
			Vector2(global_position.x / GlobalVariable.tile_size, global_position.y / GlobalVariable.tile_size),
			Vector2(player.global_position.x / GlobalVariable.tile_size, player.global_position.y / GlobalVariable.tile_size))

		if (next_move != null):
			var move_dif: Vector2 = next_move - global_position
			if move_dif.x > 0: 
				sprite.flip_h = true
				shape_cast.target_position = Vector2((GlobalVariable.tile_size / 2.0), 0)
			elif(move_dif.x < 0): 
				sprite.flip_h = false
				shape_cast.target_position = Vector2(-(GlobalVariable.tile_size / 2.0), 0)
			elif move_dif.y > 0: 
				shape_cast.target_position = Vector2(0, (GlobalVariable.tile_size / 2.0))
			else: 
				shape_cast.target_position = Vector2(0, -(GlobalVariable.tile_size / 2.0))
			
			shape_cast.force_shapecast_update()
			
			if shape_cast.is_colliding():
				return shape_cast.get_collider(0)
			else:
				global_position = next_move
				
	return null

func get_next_move(start: Vector2i, target: Vector2i) -> Variant:
	if astar.is_in_bounds(start.x, start.y) && astar.is_in_bounds(target.x, target.y):
		var moves_to_target: PackedVector2Array = astar.get_point_path(start, target)
		if (astar.get_point_path(start, target).size() > 1):
			return moves_to_target[1]
	return null
