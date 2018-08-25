extends CenterContainer

func _on_player_death():
	visible = true
	$VBoxContainer/Retry.grab_focus()

func _ready():
	$"/root/Node/Player".connect("death", self, "_on_player_death")