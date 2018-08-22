extends Button

func _on_button_down():
	if get_tree().paused:
		get_tree().paused = false
	get_tree().change_scene("res://Scenes/Scenes/MainMenu.tscn")

func _ready():
	connect("button_down", self, "_on_button_down")