extends RigidBody2D

func _ready():
	add_to_group("enemy")

func on_hit():
	print("Modify enemy attribute")

# TODO : Use the global variable instead
func execute_turn(player):
	# Eventualy replace this with actual path finding but this is the concept
	var direction = global_position.direction_to(player.global_position)
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0: 
			global_position = get_rounded_vector2(global_position.x + 16, global_position.y)
		else: 
			global_position = get_rounded_vector2(global_position.x - 16, global_position.y)
	else:
		if direction.y > 0: 
			global_position = get_rounded_vector2(global_position.x, global_position.y + 16)
		else: 
			global_position = get_rounded_vector2(global_position.x, global_position.y - 16)
	
	# Implement reverse turn logic where monster hit player 
	# We should probably return a shapecast just like with player 
	#to keep most of the logic in the game level controler

# TODO : Use the global variable instead
func get_rounded_vector2(x, y) -> Vector2:
	return Vector2(round(x / 16) * 16, round(y / 16) * 16)
