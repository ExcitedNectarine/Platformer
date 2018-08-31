extends "res://Scripts/Characters/State.gd"

const COST = 30
const DAMAGE = 30

func enter():
	if host.has_stamina(COST):
		host.change_sprite("Swing")
		host.animations.play("Left Swing") if host.facing_left else host.animations.play("Right Swing")
		host.alter_stamina(-COST)
		host.velocity.x = 0
	else:
		host.change_state("Previous")