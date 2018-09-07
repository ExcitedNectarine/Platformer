extends "res://Scripts/Characters/Enemies/Enemy.gd"

const ATTACK_DISTANCE = 80
const ATTACK_CHANCE = 30

var hit_player = false

onready var animations = $AnimationPlayer

func _on_animation_finished(animation_name):
	if animation_name != "Death":
		if state_stack.size():
			change_state("Previous")
		else:
			change_state("Idle")
		_physics_process(0)
	
func _on_player_death():
	if state_name != "Dead":
		change_state("Idle")
		health_bar.visible = false
	
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
	sprite = "Idle"
	activation_distance = 300
	sound_directory = "res://Sounds"
	add_states = ["Jump", "Fall", "Thrust"]
	points = 250

func _ready():
	connect("death", self, "_on_death")
	connect("activated", self, "change_state", ["Run"])
	connect("deactivated", self, "change_state", ["Idle"])
	player.connect("death", self, "_on_player_death")
	animations.connect("animation_finished", self, "_on_animation_finished")
	
	for hitbox in $Hitboxes.get_children():
		hitbox.connect("body_entered", self, "_on_body_enter_attack")
		
	change_state("Idle")

func _physics_process(delta):
	velocity.y += global.GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))