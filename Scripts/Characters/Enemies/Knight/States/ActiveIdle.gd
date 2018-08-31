extends "res://Scripts/Characters/State.gd"

func enter():
	host.change_sprite("Idle")
	host.animations.play("Idle")
	host.velocity.x = 0
	
func update(delta):
	if host.distance_to_player.abs().length() >= host.ATTACK_DISTANCE:
		return "Run"
		
	host.flip_sprites(host.player.position.x <= host.position.x)
	if not randi() % host.ATTACK_CHANCE:
		return "Thrust"