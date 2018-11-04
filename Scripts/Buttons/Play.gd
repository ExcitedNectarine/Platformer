extends Button

func _on_button_down():
	yield(get_tree().create_timer(0.1), "timeout") 
	get_tree().change_scene("res://Scenes/Scenes/Levels/Castle.tscn")

func _ready():
	grab_focus()
	connect("button_down", self, "_on_button_down")