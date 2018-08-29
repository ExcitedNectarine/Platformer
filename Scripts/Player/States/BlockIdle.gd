extends "res://Scripts/State.gd"

func enter():
	host.change_sprite("BlockIdle")
	host.animations.play("BlockIdle")
	host.velocity.x = 0

func update(delta):
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		return "BlockRun"
	elif Input.is_action_just_released("Block"):
		return "Idle"
	elif Input.is_action_pressed("Light"):
		return "Thrust"