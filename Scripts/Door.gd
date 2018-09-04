extends StaticBody2D

export(NodePath) var activator_path
export(String) var activator_signal

func _on_activation():
	$AnimationPlayer.play("Open")
	$AudioStreamPlayer2D.play()
	
func remove_collision():
	set_collision_layer_bit(0, false)
	$LightOccluder2D.queue_free()

func _ready():
	if activator_path != null:
		get_node(activator_path).connect(activator_signal, self, "_on_activation")