extends "res://Scripts/Characters/Character.gd"

signal activated

var title = ""
var active = false
var is_hit = false
var activation_distance = 100
var distance_to_player = Vector2()
var spawn_position = Vector2()
var points = 0
var ray = null

onready var player = $"/root/Node/Player"
onready var blood = $Blood
onready var blood_timer = $Timers/Blood

"""
Plays some effects if damaged, and activates the enemy.
"""
func alter_health(difference):
	if difference < 0:
		blood.emitting = true
		blood_timer.start()
		hit_sound.play()
	if not active:
		active = true
		player.show_boss_info(title, max_health)
		emit_signal("activated")
	.alter_health(difference)
	player.set_boss_health(health)
	if dead:
		player.hide_boss_info()
	
func _on_blood_timer_timeout():
	blood.emitting = false
	
"""
Moves the enemy to the player, but ignores the Y axis. This
lets ground based enemies find their way to the player.
"""
func move_to_player_ground(speed):
	velocity.x = speed if distance_to_player.x > 0 else -speed
		
"""
Moves the enemy to the player. Uses both axis, so this is useful
for air based enemies.
"""
func move_to_player_air(speed):
	velocity = distance_to_player.normalized() * speed

func _ready():
	spawn_position = position
	connect("death", player, "alter_points", [points])
	blood_timer.connect("timeout", self, "_on_blood_timer_timeout")
	
func _physics_process(delta):
	distance_to_player = player.position - position
	
	if not active:
		ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, get_parent().get_children(), collision_mask)
		if ray.has("collider") and ray["collider"].name == "Player" and not active and distance_to_player.abs().length() < activation_distance:
			active = true
			player.show_boss_info(title, max_health)
			emit_signal("activated")