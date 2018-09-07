extends Node

const BOSS_SCRIPT = preload("res://Scripts/Characters/Enemies/Boss.gd")

var enemies = {}

"""
Loads all the enemy scenes into a dictionary, ready to be
instanced when all the enemies have to respawn.
"""
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
			
"""
Respawns all the enemies in their original positions.
"""
func respawn():
	for enemy in get_children():
		if enemy is BOSS_SCRIPT and enemy.dead:
			enemy.queue_free()
			continue
		var pos = enemy.spawn_position
		var new_enemy = enemies[enemy.filename].instance()
		enemy.queue_free()
		new_enemy.position = pos
		add_child(new_enemy)