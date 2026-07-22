extends Area2D

@export var the_clipped_peregrine: TileMapLayer
@export var is_cleared: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_player_entered)
	body_exited.connect(_on_player_exited)

func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Fades visibility in, rather than swapping it jarringly
		the_clipped_peregrine.visible = true
		# Trigger some kind of camera tomfoolery here, or reduce player FOV, etc.

func _on_player_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		the_clipped_peregrine.visible = false
