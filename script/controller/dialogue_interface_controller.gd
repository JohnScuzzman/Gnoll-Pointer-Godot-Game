extends CanvasLayer

@onready var speaker_label = $Panel/Speaker
@onready var dialogue_label = $Panel/Dialogue
@onready var player_ui = $"../UserInterface"

var dialogue_lines: Array = []
var current_line: int = 0
var is_active: bool = false

func _ready():
	visible = false # Hide dialogue UI on start til we actually talk to an npc

func start_dialogue(speaker_name: String, lines: Array):
	player_ui.visible = false
	speaker_label.text = speaker_name
	dialogue_lines = lines
	current_line = 0
	visible = true
	show_line()

func show_line():
	if current_line < dialogue_lines.size():
		dialogue_label.text = dialogue_lines[current_line]
	else:
		end_dialogue()

func _input(event):
	if visible and event.is_action_pressed("interact"): # 'Enter' or 'Space' should also work by default
		current_line += 1
		show_line()

func end_dialogue():
	visible = false
	player_ui.visible = true
