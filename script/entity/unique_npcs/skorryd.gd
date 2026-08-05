
extends CharacterBody2D

@export var entity_name: String = "Skorryd"
@export var dialogue_lines: Array[String] = [
	"I miss my wife, tails.",
	"I've lost 8 poker games in a row despite my face being hidden. 
	They let me walk away with my money after I started eating the cards."
]

func _ready():
	add_to_group("npc")
