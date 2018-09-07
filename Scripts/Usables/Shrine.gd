extends "Usable.gd"

onready var enemies = $"/root/Node/Enemies"
onready var projectiles = $"/root/Node/Projectiles"
onready var menu = $"/root/Node/Menus/Shrine"

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
		
		for projectile in projectiles.get_children():
			projectile.queue_free()
		
		menu.visible = true
		menu.get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/LevelUp").grab_focus()
		menu.set_text()