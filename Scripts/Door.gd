extends StaticBody2D

export(NodePath) var controller_path
export(String) var open_signal
export(String) var close_signal

func _on_opened():
	$AnimationPlayer.play("Open")
	$AudioStreamPlayer2D.play()
	
func _on_closed():
	$AnimationPlayer.play("Close")
	$AudioStreamPlayer2D.play()
	
func enable_collision():
	set_collision_layer_bit(0, true)
	
func disable_collision():
	set_collision_layer_bit(0, false)
	#$LightOccluder2D.queue_free()

func _ready():
	if controller_path != null:
		get_node(controller_path).connect(open_signal, self, "_on_opened")
		get_node(controller_path).connect(close_signal, self, "_on_closed")