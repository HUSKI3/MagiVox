extends Label

onready var player = $"../Player"

func _process(delta):
	text = "Debug:"
	if player.pointing_block != null:
		text += "\nBlock"
		text += "\n\tName: " + str(player.pointing_block[0].stringify())
		text += "\n\tID: " + str(player.pointing_block[1])
		text += "\n\tPosition: " + str(player.pointing.floor())
