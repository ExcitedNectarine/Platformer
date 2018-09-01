extends "res://Scripts/Characters/Character.gd"

signal activation

var active = false
var activation_distance = 100
var path = PoolVector2Array()
var distance_to_point = Vector2()
var distance_to_player = Vector2()
var point_distance = 2
var spawn_position = Vector2()
var points = 0

onready var player = $"/root/Node/Player"
onready var navigation = $"/root/Node/Tilemaps"
onready var path_timer = $Timers/Path
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
		emit_signal("activation")
	.alter_health(difference)

func _update_path():
	path = navigation.get_simple_path(position, player.position, false)
	
func _add_points():
	player.alter_points(points)
	
func _on_activation():
	active = true
	health_bar.visible = true
	_update_path()
	path_timer.start()
	
func _on_blood_timer_timeout():
	blood.emitting = false
	
"""
Moves the enemy along the path to the player, but ignores the Y axis. This
lets ground based enemies find their way to the player.
"""
func move_to_player_ground(speed):
	if path.size() > 1:
		distance_to_point = path[0] - position
		if distance_to_point.abs().x > point_distance:
			velocity.x = (speed if distance_to_point.x > 0 else -speed)
		else:
			path.remove(0)
	else:
		velocity.x = distance_to_player.normalized().x * speed
		
"""
Moves the enemy along the path to the player. Uses both axis, so this is useful
for air based enemies.
"""
func move_to_player_air(speed):
	if path.size() > 1:
		distance_to_point = path[0] - position
		if distance_to_point.abs().length() > point_distance:
			velocity.x = (speed if distance_to_point.x > 0 else -speed)
			velocity.y = (speed if distance_to_point.y > 0 else -speed)
		else:
			path.remove(0)
	else:
		velocity = distance_to_player.normalized() * speed

func _ready():
	spawn_position = position
	connect("activation", self, "_on_activation")
	connect("death", self, "_add_points")
	path_timer.connect("timeout", self, "_update_path")
	blood_timer.connect("timeout", self, "_on_blood_timer_timeout")
	
func _physics_process(delta):
	distance_to_player = player.position - position
	if not active:
		var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, get_parent().get_children(), collision_mask)
		if ray.has("collider") and ray["collider"].name == "Player" and distance_to_player.abs().length() < activation_distance:
			emit_signal("activation")