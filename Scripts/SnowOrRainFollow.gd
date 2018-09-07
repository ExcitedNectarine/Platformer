extends Particles2D

onready var player = $"/root/Node/Player"

func _physics_process(delta):
	global_position.x = player.global_position.x