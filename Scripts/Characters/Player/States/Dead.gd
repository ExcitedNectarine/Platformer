extends "res://Scripts/Characters/State.gd"

const GRAVESTONE = preload("res://Scenes/Objects/Usables/Gravestone.tscn")

onready var usables = $"/root/Node/Usables"

func enter():
	host.change_sprite("Death")
	host.animations.play("Death")
	host.velocity.x = 0
	
	var gravestone = GRAVESTONE.instance()
	gravestone.get_node("Area2D").points = host.points
	host.alter_points(-host.points)
	gravestone.position = host.position
	
	for usable in usables.get_children():
		if usable.filename == "res://Scenes/Objects/Usables/Gravestone.tscn":
			usable.queue_free()
	
	usables.add_child(gravestone)