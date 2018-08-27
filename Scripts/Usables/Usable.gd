extends Area2D

func activate():
	pass

func _on_body_entered(body):
	if body.name == "Player":
		set_physics_process(true)
		body.show_prompt()
		
func _on_body_exited(body):
	if body.name == "Player":
		set_physics_process(false)
		body.hide_prompt()
		
func _ready():
	set_physics_process(false)
	
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("Use"):
		activate()