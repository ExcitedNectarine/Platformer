extends "res://Scripts/Characters/State.gd"

const SPEED = 100
const ATTACK_CHANCE = 100

func enter():
	host.change_sprite("Run")
	host.animations.play("Run")
	
func update(delta):
	if host.distance_to_player.abs().length() <= host.ATTACK_DISTANCE:
		return "ActiveIdle"
		
	host.move_to_player_ground(SPEED)
	host.flip_sprites(host.velocity.x <= 0)
	
	if not randi() % ATTACK_CHANCE:
		if not randi() % 2:
			return "JumpSwing"
		else:
			return "MagicThrow"