extends Node

var enemies = {}

func _ready():
	var dir = Directory.new()
	if dir.open("res://Scenes/Objects/Enemies") == OK:
		dir.list_dir_begin(true)
		var file = dir.get_next()
		while file != "":
			var full_path = "res://Scenes/Objects/Enemies/" + file
			if not enemies.has(full_path):
				enemies[full_path] = load(full_path)
			file = dir.get_next()
			
func respawn():
	for enemy in get_children():
		var pos = enemy.spawn_position
		var new_enemy = enemies[enemy.filename].instance()
		enemy.queue_free()
		new_enemy.position = pos
		add_child(new_enemy)