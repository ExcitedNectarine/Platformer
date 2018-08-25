extends "Enemy.gd"

const move_away_min = 1.5
const move_away_max = 4.5
const speed = 100
const damage = 10

var move_away = false

onready var animations = $AnimationPlayer
onready var hitbox = $Hitbox
onready var move_away_timer = $Timers/MoveAway
onready var blood = $Blood
onready var blood_timer = $Timers/Blood

enum States {
	Idle,
	Fly,
	Fall,
	Dead
}
var state = States.Idle

func reset():
	.reset()
	move_away = false
	animations.stop()
	move_away_timer.stop()
	blood.emitting = false
	blood_timer.stop()
	state = States.Idle
	_init()
	_ready()

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
	state = States.Fly

func _on_death():
	velocity.x = 0
	state = States.Fall
	_change_sprite("Fall")
	animations.stop()
	health_bar.hide()
	$Hitbox/CollisionShape2D.disabled = true
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(1, false)
	play_sound("Squeak")
	
func _on_player_death():
	if state == States.Fly and active:
		state = States.Idle
		health_bar.visible = false
		velocity = Vector2()
		path_timer.stop()
	
func _on_body_entered(body):
	if not move_away and body.name == "Player":
		body.alter_health(-damage, facing_left)
		move_away = true
		move_away_timer.wait_time = rand_range(move_away_min, move_away_max)
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
	animations.play("Fly")

	connect("death", self, "_on_death")
	player.connect("death", self, "_on_player_death")
	hitbox.connect("body_entered", self, "_on_body_entered")
	move_away_timer.connect("timeout", self, "_on_move_away_timer_timeout")
	blood_timer.connect("timeout", self, "_on_blood_timer_timeout")
	
func _physics_process(delta):
	if state == States.Fly:
		if move_away:
			velocity = -distance_to_player.normalized() * speed
		else:
			_move_to_player_air(speed)
		_flip_sprites(velocity.x <= 0)
	elif state != States.Idle:
		if not is_on_floor():
			velocity.y += ProjectSettings.get("Gravity") * delta
		elif state != States.Dead:
			state = States.Dead
			_change_sprite("Death")
	
	velocity = move_and_slide(velocity, Vector2(0, -1))