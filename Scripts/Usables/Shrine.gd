extends "Usable.gd"

onready var player = $"/root/Node/Player"
onready var enemies = $"/root/Node/Enemies"

func _init():
	text = "Y to Pray"

func activate():
	if not $Particles2D.emitting:
		$AudioStreamPlayer2D.play()
		$Sprite.frame = 1
		$Particles2D.emitting = true
		$Light2D.enabled = true
		player.shrine_position = position
		player.reset()
		enemies.respawn()