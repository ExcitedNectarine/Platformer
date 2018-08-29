extends Control

func _physics_process(delta):
	if Input.is_action_just_pressed("Pause") and not $"/root/Node/RetryMenu/Control".visible:
		visible = not get_tree().paused
		get_tree().paused = visible
		$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Continue.grab_focus()