extends Area2D

@export var avia: TileMapLayer
@export var avia_customs: TileMapLayer
@export var room_name: String = "Avia's Customs"
@export var is_cleared: bool = false
@onready var customs_music = $CustomsShape/CustomsMusic
@export var fade_duration: float = 1.5
@export var max_volume: float = 0.0

var fade_tween: Tween

# NOTE : There is porbably a way to make a generic building script and attach them 
# instead of creating a new one each time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_player_entered)
	body_exited.connect(_on_player_exited)

func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Entered " + room_name)
		# Fades visibility in, rather than swapping it jarringly
		avia.visible = false
		avia_customs.visible = true
		customs_music.play()
		fade_customs_volume(max_volume)
		# Trigger some kind of camera tomfoolery here, or reduce player FOV, etc.

func _on_player_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Left " + room_name)
		avia.visible = true
		avia_customs.visible = false
		fade_customs_volume(-60.0)


func fade_customs_volume(target_volume: float) -> void:
	# Kill the active tween if one is already running so no sensory hell 
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
	
	fade_tween = create_tween()
	fade_tween.tween_property(customs_music, "volume_db", target_volume, fade_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	
	# Stop the music when the tween is done
	if target_volume <= -50.0:
		fade_tween.finished.connect(func(): customs_music.stop())
