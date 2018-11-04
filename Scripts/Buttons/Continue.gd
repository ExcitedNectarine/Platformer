extends Button

func _on_button_down():
	yield(get_tree().create_timer(0.1), "timeout") 
	get_tree().paused = false
	owner.visible = false

func _ready():
	connect("button_down", self, "_on_button_down")