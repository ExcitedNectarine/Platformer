extends "res://Scripts/Characters/State.gd"

const DAMAGE = 70
const HEIGHT = 500
const SPEED = 400

var jumping = false

func jump():
	host.velocity.y = -HEIGHT
	host.velocity.x = -SPEED if host.facing_left else SPEED
	jumping = true
	host.play_sound("Growl")

func enter():
	host.change_sprite("JumpSwing")
	host.animations.play("Left Jump Swing") if host.facing_left else host.animations.play("Right Jump Swing")
	host.velocity.x = 0
	
func update(delta):
	if jumping and host.is_on_floor():
		host.play_footstep()
		host.velocity.x = 0
		jumping = false