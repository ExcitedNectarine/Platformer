extends CenterContainer

func _physics_process(delta):
	if Input.is_action_just_pressed("Pause") and not $"/root/Node/RetryMenu/CenterContainer".visible:
		visible = not get_tree().paused
		get_tree().paused = visible
		$VBoxContainer/Continue.grab_focus()