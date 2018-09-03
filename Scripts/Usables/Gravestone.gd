extends "res://Scripts/Usables/Usable.gd"

var points = 0
var velocity = Vector2()

onready var global = $"/root/Global"

func _init():
	text = "Recover"
	
func activate():
	$"../AnimationPlayer".play("Descent")
	player.alter_points(points)

func _physics_process(delta):
	velocity.y += global.GRAVITY * delta
	velocity = get_parent().move_and_slide(velocity)