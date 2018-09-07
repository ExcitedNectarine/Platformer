extends "res://Scripts/Characters/Character.gd"

const STAMINA_REGEN = 50
const POTION_HEALTH = 50
const MAX_POTIONS = 10
const STARTING_POTIONS = 5
const MAX_ARROWS = 99
const STARTING_ARROWS = 10
const CAMERA_X = 100
const CAMERA_SPEED = 3
const ENEMY_SCRIPT = preload("res://Scripts/Characters/Enemies/Enemy.gd")
const BOSS_SCRIPT = preload("res://Scripts/Characters/Enemies/Boss.gd")
const FULL_POTION = preload("res://Textures/Player/Potion.png")
const EMPTY_POTION = preload("res://Textures/Player/EmptyPotion.png")
const FULL_QUIVER = preload("res://Textures/Player/Quiver.png")
const EMPTY_QUIVER = preload("res://Textures/Player/EmptyQuiver.png")

var level = 1
var points = 0
var damage_multiplier = 1.0
var max_stamina = 100

var stamina = max_stamina
var potions = STARTING_POTIONS
var arrows = STARTING_ARROWS

var shrine_position = null
var spawn_position = null

onready var animations = $AnimationPlayer
onready var dash_wait_timer = $Timers/DashWait
onready var bow_and_arrow_timer = $Timers/BowAndArrow
onready var health_bar = $HUD/MarginContainer/Container/Bars/MarginContainer/VBoxContainer/HealthBar
onready var stamina_bar = $HUD/MarginContainer/Container/Bars/MarginContainer/VBoxContainer/StaminaBar
onready var potions_icon = $HUD/MarginContainer/Container/Items/MarginContainer/HBoxContainer/Potions/Texture
onready var potions_left = $HUD/MarginContainer/Container/Items/MarginContainer/HBoxContainer/Potions/Amount
onready var arrows_icon = $HUD/MarginContainer/Container/Items/MarginContainer/HBoxContainer/Arrows/Texture
onready var arrows_left = $HUD/MarginContainer/Container/Items/MarginContainer/HBoxContainer/Arrows/Amount
onready var current_level = $HUD/MarginContainer/Container/Points/MarginContainer/HBoxContainer/Level
onready var current_points = $HUD/MarginContainer/Container/Points/MarginContainer/HBoxContainer/Points
onready var items_container = $HUD/MarginContainer/Container/Items
onready var points_container = $HUD/MarginContainer/Container/Points
onready var boss_info_container = $HUD/MarginContainer/Container/BossInfo
onready var prompt = $HUD/MarginContainer/Container/Prompt
onready var blood = $Particles/Blood
onready var healing = $Particles/Healing
onready var gain_points = $Particles/GainPoints
onready var blood_timer = $Timers/Blood
onready var healing_timer = $Timers/Healing
onready var gain_points_timer = $Timers/GainPoints
onready var camera = $Camera2D

func show_prompt(text):
	prompt.get_node("MarginContainer/Label").text = text
	prompt.visible = true
	
func hide_prompt():
	prompt.visible = false
	
func show_boss_info(boss_name, boss_health):
	boss_info_container.get_node("MarginContainer/VBoxContainer/Name").text = boss_name
	boss_info_container.get_node("MarginContainer/VBoxContainer/HealthBar").max_value = boss_health
	boss_info_container.get_node("MarginContainer/VBoxContainer/HealthBar").value = boss_health
	boss_info_container.visible = true
	
func hide_boss_info():
	boss_info_container.visible = false
	
func set_boss_health(value):
	boss_info_container.get_node("MarginContainer/VBoxContainer/HealthBar").value = value

"""
Resets the player. Used when at a checkpoint.
"""
func reset():
	alter_health(max_health, false)
	alter_stamina(max_stamina)
	
	potions = STARTING_POTIONS
	potions_icon.texture = FULL_POTION
	potions_left.text = str(potions)
	
	arrows = STARTING_ARROWS
	arrows_icon.texture = FULL_QUIVER
	arrows_left.text = str(arrows)
	
	hide_boss_info()
	change_state("Idle")

"""
If the player is blocking, blocks attack if attack comes from the
opposite direction of the player.
"""
func alter_health(difference, direction):
	if difference < 0:
		if state_name in ["BlockIdle", "BlockRun", "Thrust"] and facing_left != direction:
			alter_stamina(difference)
			change_state("Blocked")
			if not stamina:
				.alter_health(difference / 2)
		elif state_name != "Dash":
			blood.emitting = true
			blood_timer.start()
			hit_sound.play()
			.alter_health(difference)
	else:
		.alter_health(difference)
	health_bar.value = health

func alter_stamina(difference):
	stamina += difference
	stamina = clamp(stamina, 0, max_stamina)
	stamina_bar.value = stamina
	
func alter_potions(difference):
	potions += difference
	potions = clamp(potions, 0, MAX_POTIONS)
	potions_icon.texture = FULL_POTION if potions else EMPTY_POTION
	potions_left.text = str(potions)
	
	# Setting the containers visibility forces it to shrink
	items_container.visible = false
	items_container.visible = true
		
func alter_arrows(difference):
	arrows += difference
	arrows = clamp(arrows, 0, MAX_ARROWS)
	arrows_icon.texture = FULL_QUIVER if arrows else EMPTY_QUIVER
	arrows_left.text = str(arrows)
	
	# Setting the containers visibility forces it to shrink
	items_container.visible = false
	items_container.visible = true
	
func alter_points(difference):
	points += difference
	if difference > 0:
		gain_points.emitting = true
		gain_points_timer.start()
		$Audio/GainPoints.play()
	if points < 0:
		points = 0
	current_points.text = str(points)
	
	# Setting the containers visibility forces it to shrink
	points_container.visible = false
	points_container.visible = true
	
func has_stamina(cost):
	return stamina >= cost
	
func use_potion():
	alter_health(POTION_HEALTH, false)
	alter_potions(-1)
	healing.emitting = true
	healing_timer.start()
	
func set_camera_limits():
	var tilemap = $"/root/Node/Tilemaps/".get_children()[0]
	var limits = tilemap.get_used_rect()
	camera.limit_bottom = limits.end.y * tilemap.cell_size.y
	
func _on_blood_timer_timeout():
	blood.emitting = false
	
func _on_healing_timer_timeout():
	healing.emitting = false
	
func _on_gain_points_timer_timeout():
	gain_points.emitting = false

func on_animation_finished(animation_name):
	if animation_name != "Death":
		if state_stack.size():
			change_state("Previous")
		else:
			change_state("Idle")
		_physics_process(0)
	
func _on_bow_and_arrow_timer_timeout():
	if arrows:
		$Sprites/BowAndArrow.frame = 0

"""
Alters damage done based on what state player is in.
"""
func _on_body_entered_attack(body):
	if state_name in ["Swing", "Thrust", "HeavyThrust"]:
		if not body.is_hit and (body is ENEMY_SCRIPT or body is BOSS_SCRIPT):
			body.alter_health(-current_state.DAMAGE * damage_multiplier)
			body.is_hit = true
		
func _on_body_exited_attack(body):
	if body.is_hit:
		body.is_hit = false
	
func _init():
	max_health = 100
	sprite = "Idle"
	sound_directory = "res://Sounds"
	add_states = ["Jump", "Dash", "Swing", "Thrust", "HeavyThrust", "Drink", "Blocked"]

func _ready():
	# Connect hitboxes
	for side in $Hitboxes.get_children():
		for hitbox in side.get_children():
			hitbox.connect("body_entered", self, "_on_body_entered_attack")
			hitbox.connect("body_exited", self, "_on_body_exited_attack")
		
	# Connect other functions
	connect("death", self, "change_state", ["Dead"])
	animations.connect("animation_finished", self, "on_animation_finished")
	bow_and_arrow_timer.connect("timeout", self, "_on_bow_and_arrow_timer_timeout")
	blood_timer.connect("timeout", self, "_on_blood_timer_timeout")
	healing_timer.connect("timeout", self, "_on_healing_timer_timeout")
	gain_points_timer.connect("timeout", self, "_on_gain_points_timer_timeout")
	
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina
	potions_left.text = str(potions)
	arrows_left.text = str(arrows)
	spawn_position = position
	
	health_bar.max_value = max_health
	health_bar.value = max_health
	
	set_camera_limits()
	
	change_state("Idle")
	alter_points(9999999)

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
	
	if state_name != "Dash":
		velocity.y += global.GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))