extends "res://Scripts/State.gd"

const SPEED = 100

func enter():
	host.change_sprite("Run")
	host.animations.play("Run")
	
func update(delta):
	if host.distance_to_player.abs().length() <= host.ATTACK_DISTANCE:
		return "ActiveIdle"
		
	host.move_to_player_ground(SPEED)
	host.flip_sprites(host.velocity.x <= 0)
	
	if host.is_on_wall() and host.velocity:
		return "Jump"
		
	if not host.is_on_floor():
		return "Fall"