extends Button

onready var player = $"/root/Node/Player"

func _on_button_down():
	yield(get_tree().create_timer(0.1), "timeout") 
	owner.visible = false
	player.change_state("Idle")

func _ready():
	connect("button_down", self, "_on_button_down")