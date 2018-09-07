extends "Usable.gd"

signal activated
signal deactivated

func _init():
	text = "Flip"

func activate():
	if not $Sprite.frame:
		$Sprite.frame = 1
		$AudioStreamPlayer2D.play()
		emit_signal("activated")
	else:
		$Sprite.frame = 0
		$AudioStreamPlayer2D.play()
		emit_signal("deactivated")