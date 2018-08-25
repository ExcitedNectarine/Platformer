extends Button

onready var player = $"/root/Node/Player"

func _on_button_down():
	player.position = player.shrine.position
	player.shrine.activate()
	get_parent().get_parent().visible = false

func _ready():
	connect("button_down", self, "_on_button_down")