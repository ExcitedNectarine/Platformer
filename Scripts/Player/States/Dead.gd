extends "res://Scripts/State.gd"

func enter():
	host.change_sprite("Death")
	host.animations.play("Death")
	host.velocity.x = 0