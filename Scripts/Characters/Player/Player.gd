extends "res://Scripts/Characters/Character.gd"

const MAX_STAMINA = 100
const STAMINA_REGEN = 50
const POTION_HEALTH = 50
const MAX_POTIONS = 10
const STARTING_POTIONS = 5
const MAX_ARROWS = 99
const STARTING_ARROWS = 10
const CAMERA_X = 100
const CAMERA_SPEED = 3
const ENEMY_SCRIPT = preload("res://Scripts/Characters/Enemies/Enemy.gd")
const FULL_POTION = preload("res://Textures/Player/Potion.png")
const EMPTY_POTION = preload("res://Textures/Player/EmptyPotion.png")
const FULL_QUIVER = preload("res://Textures/Player/Quiver.png")
const EMPTY_QUIVER = preload("res://Textures/Player/EmptyQuiver.png")

var stamina = MAX_STAMINA
var potions = STARTING_POTIONS
var arrows = STARTING_ARROWS
var points = 0
var hit_enemy = false
var shrine_position = null
var spawn_position = null

onready var animations = $AnimationPlayer
onready var dash_wait_timer = $Timers/DashWait
onready var bow_and_arrow_timer = $Timers/BowAndArrow
onready var stamina_bar = $HUD/Bars/MarginContainer/VBoxContainer/StaminaBar
onready var potions_icon = $HUD/Items/MarginContainer/HBoxContainer/Potions/Texture
onready var potions_left = $HUD/Items/MarginContainer/HBoxContainer/Potions/Amount
onready var arrows_icon = $HUD/Items/MarginContainer/HBoxContainer/Arrows/Texture
onready var arrows_left = $HUD/Items/MarginContainer/HBoxContainer/Arrows/Amount
onready var current_points = $HUD/Points/MarginContainer/Label
onready var prompt = $HUD/Prompt
onready var blood = $Particles/Blood
onready var healing = $Particles/Healing
onready var blood_timer = $Timers/Blood
onready var healing_timer = $Timers/Healing
onready var camera = $Camera2D

func show_prompt(text):
	prompt.get_node("MarginContainer/Label").text = text
	prompt.visible = true
	
func hide_prompt():
	prompt.visible = false

"""
Resets the player. Used when at a checkpoint.
"""
func reset():
	.alter_health(max_health)
	alter_stamina(MAX_STAMINA)
	
	potions = STARTING_POTIONS
	potions_icon.texture = FULL_POTION
	potions_left.text = str(potions)
	
	arrows = STARTING_ARROWS
	arrows_icon.texture = FULL_QUIVER
	arrows_left.text = str(arrows)
	
	change_state("Idle")

"""
If the player is blocking, blocks attack if attack comes from the
opposite direction of the player.
"""
func alter_health(difference, direction):
	if state_name in ["BlockIdle", "BlockRun"] and facing_left != direction:
		play_sound("Block")
		alter_stamina(difference)
		if not stamina:
			.alter_health(difference / 2)
	elif state_name != "Dash":
		if difference < 0:
			blood.emitting = true
			blood_timer.start()
			hit_sound.play()
		.alter_health(difference)

func alter_stamina(difference):
	stamina += difference
	stamina = clamp(stamina, 0, MAX_STAMINA)
	stamina_bar.value = stamina
	
func alter_potions(difference):
	potions += difference
	potions = clamp(potions, 0, MAX_POTIONS)
	potions_icon.texture = FULL_POTION if potions else EMPTY_POTION
	potions_left.text = str(potions)
		
func alter_arrows(difference):
	arrows += difference
	arrows = clamp(arrows, 0, MAX_ARROWS)
	arrows_icon.texture = FULL_QUIVER if arrows else EMPTY_QUIVER
	arrows_left.text = str(arrows)
	
func alter_points(difference):
	points += difference
	if points < 0:
		points = 0
	current_points.text = str(points)
	
func has_stamina(cost):
	return stamina >= cost
	
func use_potion():
	.alter_health(POTION_HEALTH)
	alter_potions(-1)
	healing.emitting = true
	healing_timer.start()
		
func _on_blood_timer_timeout():
	blood.emitting = false
	
func _on_healing_timer_timeout():
	healing.emitting = false

func on_animation_finished(animation_name):
	if animation_name != "Death":
		if state_stack.size():
			change_state("Previous")
		else:
			change_state("Idle")
		_physics_process(0)
		
func on_attack_finished():
	hit_enemy = false
	
func _on_bow_and_arrow_timer_timeout():
	if arrows:
		$Sprites/BowAndArrow.frame = 0

"""
Alters damage done based on what state player is in.
"""
func _on_body_entered_attack(body):
	if not hit_enemy and body is ENEMY_SCRIPT:
		body.alter_health(-current_state.DAMAGE)
		hit_enemy = true
	
func _init():
	max_health = 100
	sprite = "Idle"
	health_bar_path = "HUD//Bars/MarginContainer/VBoxContainer/HealthBar"
	sound_directory = "res://Sounds"
	add_states = ["Jump", "Dash", "Swing", "Thrust", "HeavyThrust", "Drink"]

func _ready():
	# Connect hitboxes
	for side in $Hitboxes.get_children():
		for hitbox in side.get_children():
			hitbox.connect("body_entered", self, "_on_body_entered_attack")
		
	# Connect other functions
	connect("death", self, "change_state", ["Dead"])
	animations.connect("animation_finished", self, "on_animation_finished")
	bow_and_arrow_timer.connect("timeout", self, "_on_bow_and_arrow_timer_timeout")
	blood_timer.connect("timeout", self, "_on_blood_timer_timeout")
	healing_timer.connect("timeout", self, "_on_healing_timer_timeout")
	
	stamina_bar.max_value = MAX_STAMINA
	stamina_bar.value = stamina
	potions_left.text = str(potions)
	arrows_left.text = str(arrows)
	spawn_position = position
	
	change_state("Idle")

func _physics_process(delta):
	# Makes the camera move towards the direction the player is facing.
	if facing_left:
		camera.global_position = camera.global_position.linear_interpolate(
			global_position - Vector2(CAMERA_X, 0),
			delta * CAMERA_SPEED
		)
	else:
		camera.global_position = camera.global_position.linear_interpolate(
			global_position + Vector2(CAMERA_X, 0),
			delta * CAMERA_SPEED
		)
	
	velocity.y += global.GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))