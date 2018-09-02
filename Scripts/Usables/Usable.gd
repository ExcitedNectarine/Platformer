extends Area2D

var text = ""

onready var player = $"/root/Node/Player"

func activate():
	pass

func _on_body_entered(body):
	if body.name == "Player" and not body.prompt.visible:
		set_physics_process(true)
		body.show_prompt(text)
		
func _on_body_exited(body):
	if body.name == "Player" and body.prompt.visible:
		set_physics_process(false)
		body.hide_prompt()
		
func _ready():
	set_physics_process(false)
	
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("Use") and player.state_name != "Dead":
		activate()