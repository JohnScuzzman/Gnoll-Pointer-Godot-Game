extends Node2D

var player_name
var player_class
var player_race

@onready var debug_label = get_node("DebugLabel")

func _ready() -> void:
	debug_label.text = "Name: " + str(player_name) + " Class: " + str(player_class) + " Race: " + str(player_race)


func _on_bar_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
