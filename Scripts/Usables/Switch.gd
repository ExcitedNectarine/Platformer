extends "Usable.gd"

signal activation

func activate():
	if not $Sprite.frame:
		$Sprite.frame = 1
		$AudioStreamPlayer2D.play()
		emit_signal("activation")