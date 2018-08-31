extends "Usable.gd"

onready var player = $"/root/Node/Player"
onready var enemies = $"/root/Node/Enemies"

func _init():
	text = "Y to Pray"

func activate():
	if not $Particles/Activated.emitting:
		$Audio/Activated.play()
		if not $Audio/FireCrackle.playing:
			$Audio/FireCrackle.play()
		$Sprite.frame = 1
		$Particles/Activated.emitting = true
		if not $Particles/Active.emitting:
			$Particles/Active.emitting = true
		$Light2D.enabled = true
		player.shrine_position = position
		player.reset()
		enemies.respawn()