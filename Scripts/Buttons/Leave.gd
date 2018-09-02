extends Button

onready var player = $"/root/Node/Player"

func _on_button_down():
	$"../../../../../../Control".visible = false
	player.change_state("Idle")

func _ready():
	connect("button_down", self, "_on_button_down")