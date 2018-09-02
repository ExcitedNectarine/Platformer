extends Button

func _on_button_down():
	$"../../../../../../../ShrineMenu".level_up()

func _ready():
	connect("button_down", self, "_on_button_down")