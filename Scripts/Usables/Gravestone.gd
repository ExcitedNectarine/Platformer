extends "res://Scripts/Usables/Usable.gd"

var points = 0

func _init():
	text = "Recover"
	
func activate():
	player.alter_points(points)
	get_parent().queue_free()