extends Control

onready var retry_menu = $"/root/Node/RetryMenu/Control"
onready var shrine_menu = $"/root/Node/ShrineMenu/Control"

func _physics_process(delta):
	if Input.is_action_just_pressed("Pause") and not retry_menu.visible and not shrine_menu.visible:
		visible = not get_tree().paused
		get_tree().paused = visible
		$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Continue.grab_focus()