extends "res://Scripts/State.gd"

const SPEED = 100

func update(delta):
	if host.move_away:
		host.velocity = -host.distance_to_player.normalized() * SPEED
	else:
		host.move_to_player_air(SPEED)
	host.flip_sprites(host.velocity.x <= 0)