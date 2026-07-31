extends RigidBody2D

@export var entity_definition : EntityDefinition
@export var inventory: Array[Item]
@export var highlight_color: Color = Color(0, 0, 1, 1)

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var highlight_area: Area2D = $HighlightArea2D
@onready var highlight_collision_shape: CollisionShape2D
@onready var tooltip: Label = $Tooltip

var is_highlighted: bool = false

func _ready() -> void:
	add_to_group("interactable")
	gravity_scale = 0
	global_position = get_rounded_vector2(global_position.x, global_position.y)
	
	collision_shape.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	collision_shape.shape.size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)
	
	highlight_area.position = Vector2(GlobalVariable.tile_size / 2.0, GlobalVariable.tile_size / 2.0)
	highlight_collision_shape = highlight_area.get_node("HighlightCollisionShape2D")
	highlight_collision_shape.shape.size = Vector2(GlobalVariable.tile_size, GlobalVariable.tile_size)
	
	tooltip.visible = false
	tooltip.text = entity_definition.name  + "\n\"" + entity_definition.description + "\""

func get_rounded_vector2(x: float, y: float) -> Vector2:
	return Vector2(round(x / GlobalVariable.tile_size) * GlobalVariable.tile_size, round(y / GlobalVariable.tile_size) * GlobalVariable.tile_size)

# TODO : This should probably just be in a parent
func _process(_delta: float) -> void:
	if (is_highlighted):
		tooltip.global_position = Vector2(get_global_mouse_position().x + 32, get_global_mouse_position().y)

func _on_highlight_area_2d_mouse_entered() -> void:
	sprite.material.set_shader_parameter("outline_color", highlight_color)
	sprite.material.set_shader_parameter("outline_width", 4.0)
	is_highlighted = true
	tooltip.visible = true

func _on_highlight_area_2d_mouse_exited() -> void:
	sprite.material.set_shader_parameter("outline_width", 0.0)
	is_highlighted = false
	tooltip.visible = false
