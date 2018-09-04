extends "res://Scripts/Usables/Usable.gd"

var points = 0

func _init():
	text = "Recover"
	
func activate():
	$"../AnimationPlayer".play("Descent")
	player.alter_points(points)