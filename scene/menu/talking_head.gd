extends Sprite2D

# Preload all the talking heads.
const SKORRYDS_TALKING_HEAD = preload("res://art/talking_heads/skorryds_talking_head.png")

func change_talking_head(npc_type: String):
	match npc_type:
		"Skorryd":
			texture = SKORRYDS_TALKING_HEAD
