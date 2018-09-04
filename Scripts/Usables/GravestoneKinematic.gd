extends KinematicBody2D

var velocity = Vector2()
onready var global = $"/root/Global"

func _physics_process(delta):
	velocity.y += global.GRAVITY * delta
	velocity = move_and_slide(velocity)