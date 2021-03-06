extends "res://Scripts/Characters/State.gd"

const COST = 25
const DAMAGE = 25

func enter():
	if host.has_stamina(COST):
		host.change_sprite("Thrust")
		host.animations.play("Left Thrust") if host.facing_left else host.animations.play("Right Thrust")
		host.alter_stamina(-COST)
		host.velocity.x = 0
	else:
		host.change_state("Previous")
		
func exit():
	host.animations.stop()
	for side in $"../../Hitboxes".get_children():
		for hitbox in side.get_children():
			var shape = hitbox.get_node("CollisionShape2D")
			if not shape.disabled:
				shape.disabled = true