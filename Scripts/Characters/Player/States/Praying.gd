extends "res://Scripts/Characters/State.gd"

func enter():
	host.change_sprite("Praying")
	host.velocity.x = 0