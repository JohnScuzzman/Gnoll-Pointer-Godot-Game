extends Area2D

@export var avia: TileMapLayer
@export var avia_customs: TileMapLayer
@export var avia_customs_roof: TileMapLayer
@export var room_name: String = "Avia's Customs"
@export var is_cleared: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_player_entered)
	body_exited.connect(_on_player_exited)

func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Entered " + room_name)
		# Fades visibility in, rather than swapping it jarringly
		avia_customs_roof.visible = false
		avia.visible = false
		avia_customs.visible = true
		# Trigger some kind of camera tomfoolery here, or reduce player FOV, etc.

func _on_player_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Left " + room_name)
		avia_customs_roof.visible = true
		avia.visible = true
		avia_customs.visible = false
