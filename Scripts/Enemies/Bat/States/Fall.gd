extends "res://Scripts/State.gd"

func enter():
	host.velocity.x = 0
	host.change_sprite("Fall")
	host.animations.stop()
	host.health_bar.hide()
	$"../../Hitbox/CollisionShape2D".disabled = true
	host.set_collision_layer_bit(2, false)
	host.set_collision_mask_bit(1, false)
	host.play_sound("Squeak")

func update(delta):
	if not host.is_on_floor():
		host.velocity.y += host.global.GRAVITY * delta
	else:
		return "Dead"