extends Area2D

const CHARACTER_SCRIPT = preload("res://Scripts/Characters/Character.gd")

func _on_body_entered(body):
	if body is CHARACTER_SCRIPT:
		if body.name == "Player":
			body.alter_health(-body.max_health, false)
		else:
			body.alter_health(-body.max_health)
	
func _ready():
	connect("body_entered", self, "_on_body_entered")