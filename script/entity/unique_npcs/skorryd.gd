
extends CharacterBody2D

@export var npc_name: String = "Skorryd"
@export var dialogue_lines: Array[String] = [
	"I miss my wife, tails.",
	"I've lost 8 poker games in a row despite my face being hidden. 
	They let me walk away with my money after I started eating the cards."
]

@onready var dialogue_ui = get_node_or_null("/root/GameLevel/DialogueInterface")
@onready var interaction_area = $InteractionArea

var player_in_range: bool = false

func _ready():
	interaction_area.body_entered.connect(_on_player_entered)
	interaction_area.body_exited.connect(_on_player_exited)

func _on_player_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_player_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		if dialogue_ui:
			dialogue_ui.end_dialogue()

func _process(_delta):
	# Check if player is nearby and tried to press a key.
	if player_in_range and Input.is_action_just_pressed("interact"):
		# Find the dialogue UI and trigger it if not null.
		if dialogue_ui:
			dialogue_ui.start_dialogue(npc_name, dialogue_lines)
