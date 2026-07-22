extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start the "a" (alpha) as zero.
	self.modulate.a = 0.0
	
	fade_in(2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func fade_in(duration: float) -> void:
	var tween = create_tween()
	
	# Change the alpha property from, 0 to 1
	tween.tween_property(self, "modulate:a", 1.0, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
