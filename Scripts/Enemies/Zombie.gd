extends "Enemy.gd"

const speed = 100
const jump = 500
const damage = 30
const attack_distance = 60
const attack_chance = 30

var attacking = false
var player_dead = false
var hit_player = false

onready var animations = $AnimationPlayer
onready var blood = $Blood
onready var blood_timer = $Timers/Blood

enum States {
	Idle,
	ActiveIdle,
	Run,
	Swing,
	Jump,
	Dead
}
var state = States.Idle

func alter_health(difference):
	if difference < 0:
		blood.emitting = true
		blood_timer.start()
		play_sound("Hit")
	if not active:
		emit_signal("activation")
	.alter_health(difference)

func _on_animation_finished(animation_name):
	if animation_name != "Death":
		state = States.Idle
		_change_sprite("Idle")
		animations.play("Idle")
		_physics_process(0)

func _on_activation():
	._on_activation()
	state = States.Run
	_change_sprite("Run")
	animations.play("Run")
	
func _on_blood_timer_timeout():
	blood.emitting = false
	
func _on_player_death():
	if state != States.Dead and state != States.Idle:
		state = States.Idle
		_change_sprite("Idle")
		animations.play("Idle")
		health_bar.visible = false
		player_dead = true
		path_timer.stop()
		
		for hitbox in $Hitboxes.get_children():
			hitbox.get_node("CollisionShape2D").disabled = true
	
func _on_death():
	state = States.Dead
	_change_sprite("Death")
	animations.play("Death")
	health_bar.hide()
	play_sound("Groan")
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(1, false)
	
	for hitbox in $Hitboxes.get_children():
		hitbox.get_node("CollisionShape2D").disabled = true
	
func _on_body_enter_attack(body):
	if not hit_player and body.name == "Player":
		hit_player = true
		body.alter_health(-damage, facing_left)
	
func on_attack_finished():
	hit_player = false
	state = States.Run
	_change_sprite("Run")
	animations.play("Run")

func _init():
	max_health = 75
	health_bar_path = "HealthBar"
	sprite = "Idle"
	activation_distance = 300
	sound_directory = "res://Sounds"

func _ready():
	_change_sprite("Idle")
	animations.play("Idle")
	
	player.connect("death", self, "_on_player_death")
	animations.connect("animation_finished", self, "_on_animation_finished")
	blood_timer.connect("timeout", self, "_on_blood_timer_timeout")
	connect("death", self, "_on_death")
	
	for hitbox in $Hitboxes.get_children():
		hitbox.connect("body_entered", self, "_on_body_enter_attack")

func _physics_process(delta):
	if not state in [States.Dead, States.Idle, States.Swing] and active:
		if distance_to_player.abs().length() >= attack_distance:
			_move_to_player_ground(speed)
			facing_left = velocity.x <= 0
			if state == States.ActiveIdle:
				state = States.Run
				_change_sprite("Run")
				animations.play("Run")
		else:
			velocity.x = 0
			facing_left = player.position.x <= position.x 
			if state == States.Run:
				state = States.ActiveIdle
				_change_sprite("Idle")
				animations.play("Idle")
		
		if (not (randi() % attack_chance)) and distance_to_player.abs().length() <= attack_distance:
			state = States.Swing
			_change_sprite("Swing")
			animations.play("Left Swing") if facing_left else animations.play("Right Swing")
			
		if state != States.Jump and (is_on_wall() and (velocity.x > 0 or velocity.x < 0)) and distance_to_player.abs().x >= attack_distance:
			state = States.Jump
			velocity.y = -jump
			_change_sprite("Jump")
			animations.stop()
	else:
		velocity.x = 0
	
	if not is_on_floor():
		if state != States.Dead and state != States.Jump:
			state = States.Jump
			_change_sprite("Jump")
			animations.stop()
	elif state == States.Jump:
		if not active or player_dead:
			state = States.Idle
			_change_sprite("Idle")
			animations.play("Idle")
		else:
			state = States.Run
			_change_sprite("Run")
			animations.play("Run")
	
	_flip_sprites(facing_left)
	
	velocity.y += ProjectSettings.get_setting("Gravity") * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))