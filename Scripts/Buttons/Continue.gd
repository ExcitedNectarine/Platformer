extends Button

func _on_button_down():
	get_tree().paused = false
	owner.visible = false

func _ready():
	connect("button_down", self, "_on_button_down")