extends "Usable.gd"

signal activation

func _init():
	text = "Y to Flip"

func activate():
	if not $Sprite.frame:
		$Sprite.frame = 1
		$AudioStreamPlayer2D.play()
		emit_signal("activation")