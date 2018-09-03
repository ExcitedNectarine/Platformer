extends "res://Scripts/Characters/State.gd"

func enter():
	host.change_sprite("Idle")
	host.animations.play("Idle")
	host.velocity.x = 0

func update(delta):
	host.alter_stamina(host.STAMINA_REGEN * delta)
	
	if not host.test_move(host.transform, Vector2(0, 1)):
		return "Fall"
	
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		return "Run"
	elif Input.is_action_pressed("Jump"):
		return "Jump"
	elif Input.is_action_pressed("Dash"):
		return "Dash"
	elif Input.is_action_pressed("Block"):
		return "BlockIdle"
	elif Input.is_action_pressed("Light"):
		return "Swing"
	elif Input.is_action_pressed("Heavy"):
		return "HeavyThrust"
	elif Input.is_action_pressed("Draw"):
		return "Drawn"
	elif Input.is_action_pressed("Drink") and host.potions > 0:
		return "Drink"