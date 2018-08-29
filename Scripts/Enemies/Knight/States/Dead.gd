extends "res://Scripts/State.gd"

func enter():
	host.change_sprite("Death")
	host.animations.play("Death")
	host.velocity.x = 0
	host.health_bar.hide()
	host.set_collision_layer_bit(2, false)
	host.set_collision_mask_bit(1, false)