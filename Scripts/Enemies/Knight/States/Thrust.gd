extends "res://Scripts/State.gd"

const DAMAGE = 30

func enter():
	host.change_sprite("Thrust")
	host.animations.play("Left Thrust") if host.facing_left else host.animations.play("Right Thrust")