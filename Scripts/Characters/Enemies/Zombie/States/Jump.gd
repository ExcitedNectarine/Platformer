extends "res://Scripts/Characters/State.gd"

const SPEED = 100
const HEIGHT = 500

func enter():
	host.change_sprite("Jump")
	host.animations.stop()
	host.velocity.y = -HEIGHT
	
func update(delta):
	host.move_to_player_ground(SPEED)
	host.flip_sprites(host.velocity.x <= 0)
	
	if host.is_on_floor():
		host.play_footstep()
		return "Run"