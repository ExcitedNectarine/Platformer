extends "res://Scripts/Usables/Usable.gd"

signal opened
signal closed

var opened = false

func _init():
	text = "Open"

func activate():
	if get_parent().locked:
		if player.has_key:
			if not opened:
				emit_signal("opened")
				opened = true
				text = "Close"
			else:
				emit_signal("closed")
				opened = false
				text = "Open"
	else:
		if not opened:
			emit_signal("opened")
			opened = true
			text = "Close"
		else:
			emit_signal("closed")
			opened = false
			text = "Open"
			
	player.show_prompt(text)