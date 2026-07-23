extends Area2D

@export var chiisiis_roof: TileMapLayer
@export var chiisiis_house: TileMapLayer
@export var room_name: String = "Chii'sii's House"
@export var is_cleared: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_player_entered)
	body_exited.connect(_on_player_exited)

func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Entered " + room_name)
		# Fades visibility in, rather than swapping it jarringly
		chiisiis_house.visible = true
		chiisiis_roof.visible = false
		# Trigger some kind of camera tomfoolery here, or reduce player FOV, etc.

func _on_player_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Left " + room_name)
		chiisiis_house.visible = false
		chiisiis_roof.visible = true
