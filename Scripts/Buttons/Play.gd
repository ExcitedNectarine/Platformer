extends Button

func _on_button_down():
	get_tree().change_scene("res://Scenes/Scenes/Main.tscn")

func _ready():
	grab_focus()
	connect("button_down", self, "_on_button_down")