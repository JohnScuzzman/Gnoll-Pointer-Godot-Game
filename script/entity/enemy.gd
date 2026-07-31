extends RigidBody2D

@export var entity_definition : EntityDefinition
@export var inventory: Array[Item]
@export var death_texture : Texture2D
@export var aggro_area_size : float
@export var highlight_color: Color = Color(1, 0, 0, 1)

@onready var sprite: Sprite2D = $Sprite2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D
@onready var ray_cast: RayCast2D = $LineOfSightRayCast2D
@onready var aggro_area: Area2D = $AggroArea2D
@onready var aggro_radius: CollisionShape2D
@onready var highlight_area: Area2D = $HighlightArea2D
@onready var highlight_collision_shape: CollisionShape2D
@onready var enemy_collision_shape: CollisionShape2D = $EnemyCollisionShape2D
@onready var tooltip: Label = $Tooltip

var game_level_reference: Node

var player_in_aggro_area: bool = false
var is_dead: bool = false
var is_aggressive: bool = false
var is_highlighted: bool = false

#PlaceHolder
var entity_name: String = "Kobold"
var hp_max: int = 1
var hp: int = hp_max
var armor_value: int = 0
var xp_drop: int = 50

func _ready() -> void:
	game_level_reference = get_node("/root/GameLevel")
	add_to_group("enemy")
	gravity_scale = 0
	global_position = get_rounded_vector2(global_position.x, global_position.y)
	
	sprite.offset = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	
	shape_cast.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.shape.size = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	shape_cast.target_position = Vector2.ZERO
	
	ray_cast.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	ray_cast.target_position = Vector2.ZERO
	
	aggro_area.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	aggro_radius = aggro_area.get_node("AggroRadiusShape2D")
	aggro_radius.shape.size = Vector2(GlobalVariable.tile_size * aggro_area_size, GlobalVariable.tile_size * aggro_area_size)
	
	highlight_area.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	highlight_collision_shape = highlight_area.get_node("HighlightCollisionShape2D")
	highlight_collision_shape.shape.size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)
	
	enemy_collision_shape.shape.size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)
	
	tooltip.visible = false
	
	game_level_reference.active_entities.append(self)
	
func _process(_delta: float) -> void:
	if (is_highlighted):
		tooltip.global_position = Vector2(get_global_mouse_position().x + 32, get_global_mouse_position().y)
	
func _physics_process(_delta: float) -> void:
	if (player_in_aggro_area):
		ray_cast.target_position = ray_cast.to_local(game_level_reference.player.global_position)

		if ray_cast.is_colliding():
			var collider: Object = ray_cast.get_collider()
			if collider.is_in_group("player"):
				is_aggressive = true
	else:
		is_aggressive = false

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
	game_level_reference.active_entities.erase(self)
	sprite.texture = death_texture
	enemy_collision_shape.disabled = true
	remove_from_group("enemy")
	add_to_group("interactable")
	tooltip.text = entity_definition.death_name  + "\n\"" + entity_definition.death_description + "\""

func execute_turn(player: Node) -> Object:
	if (!is_dead):
		shape_cast.target_position = Vector2.ZERO
		shape_cast.force_shapecast_update()
		
		var possible_next_move: Variant = get_next_move(
			Vector2(global_position.x / GlobalVariable.tile_size, global_position.y / GlobalVariable.tile_size),
			Vector2(player.global_position.x / GlobalVariable.tile_size, player.global_position.y / GlobalVariable.tile_size))

		if (possible_next_move != null):
			var next_move: Vector2 = possible_next_move
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
	if game_level_reference.astar.is_in_bounds(start.x, start.y) && game_level_reference.astar.is_in_bounds(target.x, target.y):
		var moves_to_target: PackedVector2Array = game_level_reference.astar.get_point_path(start, target)
		if (game_level_reference.astar.get_point_path(start, target).size() > 1):
			return moves_to_target[1]
	return null

func get_rounded_vector2(x: float, y: float) -> Vector2:
	return Vector2(round(x / GlobalVariable.tile_size) * GlobalVariable.tile_size, round(y / GlobalVariable.tile_size) * GlobalVariable.tile_size)

func _on_aggro_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		player_in_aggro_area = true

func _on_aggro_area_2d_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		player_in_aggro_area = false

func _on_enemy_area_2d_mouse_shape_entered(_shape_idx: int) -> void:
	sprite.material.set_shader_parameter("outline_color", highlight_color)
	sprite.material.set_shader_parameter("outline_width", 4.0)
	is_highlighted = true
	tooltip.visible = true

func _on_enemy_area_2d_mouse_shape_exited(_shape_idx: int) -> void:
	sprite.material.set_shader_parameter("outline_width", 0.0)
	is_highlighted = false
	tooltip.visible = false
