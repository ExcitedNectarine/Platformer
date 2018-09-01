extends "res://Scripts/Characters/State.gd"

const ATTACK_CHANCE = 30

func enter():
	host.change_sprite("Idle")
	host.animations.play("Idle")
	host.velocity.x = 0
	
func update(delta):
	if host.distance_to_player.abs().length() >= host.ATTACK_DISTANCE:
		return "Run"
		
	host.flip_sprites(host.player.position.x <= host.position.x)
	if not randi() % ATTACK_CHANCE:
		return "Swing"