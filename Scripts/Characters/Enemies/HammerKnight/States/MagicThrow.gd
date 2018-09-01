extends "res://Scripts/Characters/State.gd"

const DAMAGE = 25
const MAGIC_SHOT = preload("res://Scenes/Objects/Projectiles/MagicShot.tscn")

onready var projectiles = $"/root/Node/Projectiles"
onready var magic_shot_spawn = $"../../MagicShotSpawn"

func spawn_magic_shot():
	var shot = MAGIC_SHOT.instance()
	shot.damage = DAMAGE
	shot.position = magic_shot_spawn.global_position
	projectiles.add_child(shot)

func enter():
	host.change_sprite("MagicThrow")
	host.animations.play("Magic Throw")
	host.velocity.x = 0