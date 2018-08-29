extends "res://Scripts/State.gd"

func enter():
	host.change_sprite("Fly")
	host.animations.play("Fly")