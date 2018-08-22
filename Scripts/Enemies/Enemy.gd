extends "../Character.gd"

signal activation

var active = false
var activation_distance = 100
var path = PoolVector2Array()
var distance_to_point = Vector2()
var distance_to_player = Vector2()
var point_distance = 2

onready var player = $"/root/Node/Player"
onready var navigation = $"/root/Node/Tilemaps"
onready var path_timer = $Timers/Path

func _update_path():
	path = navigation.get_simple_path(position, player.position, false)
	
func _on_activation():
	active = true
	health_bar.visible = true
	_update_path()
	path_timer.start()

func _move_to_player_ground(speed):
	if path.size() > 1:
		distance_to_point = path[0] - position
		if distance_to_point.abs().x > point_distance:
			velocity.x = (speed if distance_to_point.x > 0 else -speed)
		else:
			path.remove(0)
	else:
		velocity.x = distance_to_player.normalized().x * speed
		
func _move_to_player_air(speed):
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
	path_timer.connect("timeout", self, "_update_path")
	connect("activation", self, "_on_activation")
	
func _physics_process(delta):
	distance_to_player = player.position - position
	if not active:
		var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, get_parent().get_children(), collision_mask)
		if ray.has("collider") and ray["collider"].name == "Player" and distance_to_player.abs().length() < activation_distance:
			emit_signal("activation")