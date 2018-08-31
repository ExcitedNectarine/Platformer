extends "res://Scripts/Characters/State.gd"

func enter():
	host.change_sprite("Drink")
	host.animations.play("Drink")
	host.velocity.x = 0
	
func update(delta):
	host.alter_stamina(host.STAMINA_REGEN * delta)