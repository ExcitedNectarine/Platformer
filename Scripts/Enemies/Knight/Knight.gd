extends "res://Scripts/Enemies/Enemy.gd"

const ATTACK_DISTANCE = 80
const ATTACK_CHANCE = 30

var hit_player = false

onready var animations = $AnimationPlayer
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

func _on_animation_finished(animation_name):
	if animation_name != "Death":
		if state_stack.size():
			change_state("Previous")
		else:
			change_state("Idle")
		_physics_process(0)

func _on_activation():
	._on_activation()
	change_state("Run")
	
func _on_blood_timer_timeout():
	blood.emitting = false
	
func _on_player_death():
	if state_name != "Dead":
		change_state("Idle")
		health_bar.visible = false
		path_timer.stop()
	
		for hitbox in $Hitboxes.get_children():
			hitbox.get_node("CollisionShape2D").disabled = true
	
func _on_death():
	change_state("Dead")
	
	for hitbox in $Hitboxes.get_children():
		hitbox.get_node("CollisionShape2D").disabled = true
	
func _on_body_enter_attack(body):
	if not hit_player and body.name == "Player":
		hit_player = true
		body.alter_health(-current_state.DAMAGE, facing_left)
	
func on_attack_finished():
	hit_player = false
	change_state("ActiveIdle")

func _init():
	max_health = 150
	health_bar_path = "HealthBar"
	sprite = "Idle"
	activation_distance = 300
	sound_directory = "res://Sounds"
	add_states = ["Jump", "Fall", "Thrust"]

func _ready():
	player.connect("death", self, "_on_player_death")
	animations.connect("animation_finished", self, "_on_animation_finished")
	blood_timer.connect("timeout", self, "_on_blood_timer_timeout")
	connect("death", self, "_on_death")
	
	for hitbox in $Hitboxes.get_children():
		hitbox.connect("body_entered", self, "_on_body_enter_attack")
		
	change_state("Idle")

func _physics_process(delta):
	var new_state = current_state.update(delta)
	if new_state != null:
		change_state(new_state)
	
	velocity.y += global.GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))