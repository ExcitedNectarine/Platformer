extends "res://Scripts/Characters/State.gd"

const SPEED = 250

func enter():
	host.change_sprite("Jump")
	host.animations.stop()
	
func update(delta):
	host.alter_stamina(host.STAMINA_REGEN * delta)
	
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