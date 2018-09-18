extends Area2D

signal player_entered
signal player_exited

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("player_entered")
		
func _on_body_exited(body):
	if body.name == "Player":
		emit_signal("player_exited")
		
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")