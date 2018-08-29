extends "res://Scripts/Enemies/Enemy.gd"

const MOVE_AWAY_MIN = 1.5
const MOVE_AWAY_MAX = 4.5
const DAMAGE = 10

var move_away = false

onready var animations = $AnimationPlayer
onready var hitbox = $Hitbox
onready var move_away_timer = $Timers/MoveAway
onready var blood = $Blood
onready var blood_timer = $Timers/Blood

func alter_health(difference):
	if difference < 0:
		blood.emitting = true
		blood_timer.start()
		play_sound("Hit")
	if not active:
		emit_signal("activation")
	.alter_health(difference)

func _on_activation():
	._on_activation()
	change_state("Fly")
	
func _on_player_death():
	if state_name == "Fly" and active:
		change_state("Idle")
		health_bar.visible = false
		velocity = Vector2()
		path_timer.stop()
	
func _on_body_entered(body):
	if not move_away and body.name == "Player":
		body.alter_health(-DAMAGE, facing_left)
		move_away = true
		move_away_timer.wait_time = rand_range(MOVE_AWAY_MIN, MOVE_AWAY_MAX)
		move_away_timer.start()
		
func _on_move_away_timer_timeout():
	move_away = false
	
func _on_blood_timer_timeout():
	blood.emitting = false

func _init():
	max_health = 30
	health_bar_path = "HealthBar"
	sound_directory = "res://Sounds"
	sprite = "Fly"
	activation_distance = 400
	
func _ready():
	change_state("Idle")

	connect("death", self, "change_state", ["Fall"])
	player.connect("death", self, "_on_player_death")
	hitbox.connect("body_entered", self, "_on_body_entered")
	move_away_timer.connect("timeout", self, "_on_move_away_timer_timeout")
	blood_timer.connect("timeout", self, "_on_blood_timer_timeout")
	
func _physics_process(delta):
	var new_state = current_state.update(delta)
	if new_state != null:
		change_state(new_state)
	
	velocity = move_and_slide(velocity, Vector2(0, -1))