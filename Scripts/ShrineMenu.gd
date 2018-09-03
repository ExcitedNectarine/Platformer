extends CanvasLayer

const POINT_CONSTANT = 500

var required_points = 0

onready var player = $"/root/Node/Player"
onready var level = $Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Stats/MarginContainer/VBoxContainer/Level/Level
onready var current = $Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Stats/MarginContainer/VBoxContainer/Current/Current
onready var required = $Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Stats/MarginContainer/VBoxContainer/Required/Required
onready var audio = $AudioStreamPlayer

func set_text():
	required_points = next_level(player.level)
	
	level.text = str(player.level)
	current.text = str(player.points)
	required.text = str(required_points)
	
static func next_level(level):
	return floor(POINT_CONSTANT * pow(level, 1.5))
	
func level_up():
	if player.points >= required_points:
		player.level += 1
		player.max_health += 2
		player.health_bar.max_value = player.max_health
		player.max_stamina += 1
		player.stamina_bar.max_value = player.max_stamina
		player.damage_multiplier += 0.1
		
		player.alter_health(player.max_health, false)
		player.alter_stamina(player.max_stamina)
		player.alter_points(-required_points)
		player.current_level.text = str(player.level)
		
		audio.play()
		set_text()