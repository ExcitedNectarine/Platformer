extends Button

onready var player = $"/root/Node/Player"
onready var enemies = $"/root/Node/Enemies"

func _on_button_down():
	if player.shrine_position != null:
		player.position = player.shrine_position
	else:
		player.position = player.spawn_position
	enemies.respawn()
	player.reset()
	$"../../../../../../Control".visible = false

func _ready():
	connect("button_down", self, "_on_button_down")