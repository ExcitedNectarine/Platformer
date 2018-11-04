extends "res://Scripts/Usables/Usable.gd"

export(String) var next

func _init():
	text = "Exit Level"
	
func activate():
	$AnimationPlayer.play("Activated")
	
func change():
	get_tree().change_scene("res://Scenes/Scenes/Levels/" + next + ".tscn")