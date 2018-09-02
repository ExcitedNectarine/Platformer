extends "Usable.gd"

onready var enemies = $"/root/Node/Enemies"
onready var menu = $"/root/Node/ShrineMenu"

func _init():
	text = "Pray"

func activate():
	if not $Particles/Activated.emitting and player.state_name != "Praying":
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
		player.change_state("Praying")
		
		enemies.respawn()
		
		menu.get_node("Control").visible = true
		menu.get_node("Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/LevelUp").grab_focus()
		menu.set_text()