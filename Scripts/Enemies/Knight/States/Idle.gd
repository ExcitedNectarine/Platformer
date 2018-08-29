extends "res://Scripts/State.gd"

func enter():
	host.change_sprite("Idle")
	host.animations.play("Idle")
	host.velocity.x = 0