extends "res://Scripts/Characters/State.gd"

func enter():
	host.change_sprite("Fly")
	host.animations.play("Fly")
	host.velocity = Vector2()