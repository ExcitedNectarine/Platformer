extends "res://Scripts/Characters/State.gd"

func enter():
	host.change_sprite("Idle")
	host.animations.play("Idle")
	host.velocity.x = 0