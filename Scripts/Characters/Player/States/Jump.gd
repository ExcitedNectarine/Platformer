extends "res://Scripts/Characters/State.gd"

const HEIGHT = 500
const COST = 20
const SPEED = 250

func enter():
	if host.has_stamina(COST):
		host.change_sprite("Jump")
		host.animations.stop()
		host.velocity.y = -HEIGHT
		host.alter_stamina(-COST)
	else:
		host.change_state("Previous")
	
func update(delta):
	if Input.is_action_pressed("Left"):
		host.velocity.x = -SPEED
	elif Input.is_action_pressed("Right"):
		host.velocity.x = SPEED
	else:
		host.velocity.x = 0
		
	if host.velocity.x < 0:
		host.flip_sprites(true)
	elif host.velocity.x > 0:
		host.flip_sprites(false)
		
	if host.is_on_floor():
		host.play_footstep()
		return "Run" if host.velocity.x else "Idle"