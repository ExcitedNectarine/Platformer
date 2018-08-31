extends "res://Scripts/Characters/State.gd"

const SPEED = 100

func enter():
	host.change_sprite("BlockRun")
	host.animations.play("BlockRun")
	
func update(delta):
	if Input.is_action_pressed("Left"):
		host.velocity.x = -SPEED
	elif Input.is_action_pressed("Right"):
		host.velocity.x = SPEED
	else:
		return "BlockIdle"
		
	if host.velocity.x < 0:
		host.flip_sprites(true)
	elif host.velocity.x > 0:
		host.flip_sprites(false)
		
	if not host.test_move(host.transform, Vector2(0, 1)):
		return "Fall"
		
	if Input.is_action_just_released("Block"):
		return "Run"
	elif Input.is_action_pressed("Light"):
		return "Thrust"