extends "res://Scripts/State.gd"

const DAMAGE = 30

func enter():
	host.change_sprite("Swing")
	host.animations.play("Left Swing") if host.facing_left else host.animations.play("Right Swing")