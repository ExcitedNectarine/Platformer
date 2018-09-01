extends "Usable.gd"

onready var enemies = $"/root/Node/Enemies"

func _init():
	text = "Pray"

func activate():
	if player.state_name == "Praying":
		player.change_state("Idle")
		player.show_prompt(text)
		
	elif not $Particles/Activated.emitting:
		if not $Audio/FireCrackle.playing:
			$Audio/FireCrackle.play()
		if not $Particles/Active.emitting:
			$Particles/Active.emitting = true
			
		$Audio/Activated.play()
		$Light2D.enabled = true
		$Sprite.frame = 1
		$Particles/Activated.emitting = true
		
		player.shrine_position = position
		player.reset()
		player.show_prompt("Exit")
		player.change_state("Praying")
		
		enemies.respawn()