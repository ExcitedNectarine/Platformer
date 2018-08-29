extends "res://Scripts/State.gd"

const SPEED = 250

func enter():
	host.change_sprite("Run")
	host.animations.play("Run")
	
func update(delta):
	host.alter_stamina(host.STAMINA_REGEN * delta)
	
	if Input.is_action_pressed("Left"):
		host.velocity.x = -SPEED
	elif Input.is_action_pressed("Right"):
		host.velocity.x = SPEED
	else:
		return "Idle"
		
	if host.velocity.x < 0:
		host.flip_sprites(true)
	elif host.velocity.x > 0:
		host.flip_sprites(false)
		
	if not host.test_move(host.transform, Vector2(0, 1)):
		return "Fall"
		
	if Input.is_action_pressed("Jump"):
		return "Jump"
	elif Input.is_action_pressed("Dash"):
		return "Dash"
	elif Input.is_action_just_pressed("Block"):
		return "BlockRun"
	elif Input.is_action_pressed("Light"):
		return "Swing"
	elif Input.is_action_pressed("Heavy"):
		return "HeavyThrust"
	elif Input.is_action_just_pressed("Draw"):
		return "Drawn"
	elif Input.is_action_pressed("Drink") and host.potions:
		return "Drink"