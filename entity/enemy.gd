extends RigidBody2D

func _ready():
	add_to_group("enemy")

func on_hit():
	print("Modify enemy attribute")
