extends "Character.gd"

const speed = 250
const block_speed = 100
const dash_speed = 1250
const jump = 500
const max_stamina = 100
const stamina = max_stamina
const stamina_regen = 50
const jump_cost = 25
const dash_cost = 20
const swing_cost = 30
const thrust_cost = 25
const heavy_thrust_cost = 50
const shoot_cost = 30
const potion_health = 50
const max_potions = 10
const max_arrows = 99
const swing_damage = 30
const thrust_damage = 25
const heavy_thrust_damage = 70

var hit_enemy = false
var blocking = false
var can_dash = true
var potions = 5
var arrows = 10

enum States {
	Idle,
	Run,
	Jump,
	BlockIdle,
	BlockRun,
	Swing,
	Thrust,
	HeavyThrust
	Dash,
	Drink,
	Dead,
	Drawn
}
var state = States.Idle

onready var animations = $AnimationPlayer
onready var dash_timer = $Timers/Dash
onready var dash_wait_timer = $Timers/DashWait
onready var bow_and_arrow_timer = $Timers/BowAndArrow
onready var stamina_bar = $HUD/StaminaBar
onready var potion_icon = $HUD/Items/Potions
onready var potions_left = $HUD/Items/Potions/Label
onready var arrows_icon = $HUD/Items/Arrows
onready var arrows_left = $HUD/Items/Arrows/Label
onready var blood = $Blood
onready var blood_timer = $Timers/Blood
onready var healing = $Healing
onready var healing_timer = $Timers/Healing

const arrow_scene = preload("res://Scenes/Objects/Arrow.tscn")
const enemy_script = preload("res://Scripts/Enemies/Enemy.gd")

func alter_health(difference, direction):
	if blocking and facing_left != direction:
		play_sound("Block")
		alter_stamina(difference)
		if not stamina:
			.alter_health(difference / 2)
	elif state != States.Dash:
		if difference < 0:
			blood.emitting = true
			blood_timer.start()
			play_sound("Hit")
		.alter_health(difference)

func alter_stamina(difference):
	stamina += difference
	stamina = clamp(stamina, 0, max_stamina)
	stamina_bar.value = stamina
	
func alter_potions(difference):
	potions += difference
	potions = clamp(potions, 0, max_potions)
	potions_left.text = str(potions)
	potion_icon.frame = 0 if potions else 1
		
func alter_arrows(difference):
	arrows += difference
	arrows = clamp(arrows, 0, max_arrows)
	arrows_left.text = str(arrows)
	arrows_icon.frame = 0 if arrows else 1
	
func use_potion():
	.alter_health(potion_health)
	alter_potions(-1)
	healing.emitting = true
	healing_timer.start()
		
func _on_blood_timer_timeout():
	blood.emitting = false
	
func _on_healing_timer_timeout():
	healing.emitting = false

func _on_animation_finished(animation_name):
	if animation_name != "Death":
		state = States.Idle
		_change_sprite("Idle")
		animations.play("Idle")
		_physics_process(0)
		
func on_attack_finished():
	hit_enemy = false
	
func _on_dash_timer_timeout():
	_on_animation_finished("")
	dash_wait_timer.start()
	set_collision_layer_bit(1, true)
	
func _on_dash_wait_timer_timeout():
	can_dash = true
	
func _on_bow_and_arrow_timer_timeout():
	_on_animation_finished("")
	
func _on_death():
	state = States.Dead
	_change_sprite("Death")
	animations.play("Death")
	velocity.x = 0
	
func _on_body_entered_attack(body):
	if not hit_enemy and body is enemy_script:
		match state:
			States.Swing: body.alter_health(-swing_damage)
			States.Thrust: body.alter_health(-thrust_damage)
			States.HeavyThrust: body.alter_health(-heavy_thrust_damage)
		hit_enemy = true
	
func _init():
	max_health = 100
	sprite = "Idle"
	health_bar_path = "HUD/HealthBar"
	sound_directory = "res://Sounds"

func _ready():
	for spr in $Sprites.get_children():
		sprites[spr.name] = spr
		
	for side in $Hitboxes.get_children():
		for hitbox in side.get_children():
			hitbox.connect("body_entered", self, "_on_body_entered_attack")
		
	connect("death", self, "_on_death")
	animations.connect("animation_finished", self, "_on_animation_finished")
	dash_timer.connect("timeout", self, "_on_dash_timer_timeout")
	dash_wait_timer.connect("timeout", self, "_on_dash_wait_timer_timeout")
	bow_and_arrow_timer.connect("timeout", self, "_on_bow_and_arrow_timer_timeout")
	blood_timer.connect("timeout", self, "_on_blood_timer_timeout")
	healing_timer.connect("timeout", self, "_on_healing_timer_timeout")
	
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina
	
	potions_left.text = str(potions)
	arrows_left.text = str(arrows)
	
	ProjectSettings.set_setting("Gravity", 980)
	animations.play("Idle")

func _physics_process(delta):
	if not state in [States.Swing, States.Thrust, States.Dash, States.Drink, States.Dead, States.Drawn, States.HeavyThrust]:
		blocking = Input.is_action_pressed("Block")
		if blocking and not state in [States.Jump]:
			velocity.x = 0
			if Input.is_action_pressed("Left"):
				velocity.x -= block_speed
			elif Input.is_action_pressed("Right"):
				velocity.x += block_speed
				
			if is_on_floor():
				alter_stamina((stamina_regen * delta) / 2)
				
				if velocity.x:
					if state != States.BlockRun:
						if state == States.Jump:
							play_footstep()
						state = States.BlockRun
						_change_sprite("BlockRun")
						animations.play("BlockRun")
				else:
					if state != States.BlockIdle:
						if state == States.Jump:
							play_footstep()
						state = States.BlockIdle
						_change_sprite("BlockIdle")
						animations.play("BlockIdle")
						
				if Input.is_action_pressed("Attack") and stamina >= thrust_cost:
					state = States.Thrust
					velocity.x = 0
					_change_sprite("Thrust")
					animations.play("Left Thrust") if facing_left else animations.play("Right Thrust")
					alter_stamina(-thrust_cost)
			
		else:
			velocity.x = 0
			if Input.is_action_pressed("Left"):
				velocity.x -= speed
			elif Input.is_action_pressed("Right"):
				velocity.x += speed
				
			if is_on_floor():
				alter_stamina(stamina_regen * delta)
				
				if velocity.x:
					if state != States.Run:
						if state == States.Jump:
							play_footstep()
						state = States.Run
						_change_sprite("Run")
						animations.play("Run")
				else:
					if state != States.Idle:
						if state == States.Jump:
							play_footstep()
						state = States.Idle
						_change_sprite("Idle")
						animations.play("Idle")
						
				if Input.is_action_just_pressed("Jump") and stamina >= jump_cost:
					state = States.Jump
					_change_sprite("Jump")
					animations.stop()
					velocity.y = -jump
					alter_stamina(-jump_cost)
					
				if Input.is_action_just_pressed("Attack") and stamina >= swing_cost:
					state = States.Swing
					_change_sprite("Swing")
					animations.play("Left Swing") if facing_left else animations.play("Right Swing")
					alter_stamina(-swing_cost)
					velocity.x = 0
					
				if Input.is_action_pressed("Draw") and state != States.Drawn:
					state = States.Drawn
					_change_sprite("BowAndArrow")
					animations.stop()
					velocity.x = 0
					$Sprites/BowAndArrow.frame = 0 if arrows else 1
					
				if Input.is_action_just_pressed("Heavy") and stamina >= heavy_thrust_cost:
					state = States.HeavyThrust
					_change_sprite("HeavyThrust")
					animations.play("Left Heavy Thrust") if facing_left else animations.play("Right Heavy Thrust")
					velocity.x = 0
					alter_stamina(-heavy_thrust_cost)
					
				if Input.is_action_just_pressed("Dash") and can_dash and stamina >= dash_cost:
					state = States.Dash
					_change_sprite("Dash")
					animations.stop()
					can_dash = false
					dash_timer.start()
					velocity.x = -dash_speed if facing_left else dash_speed
					alter_stamina(-dash_cost)
					play_sound("Dash")
					set_collision_layer_bit(1, false)
					
				if Input.is_action_just_pressed("Drink") and potions > 0:
					state = States.Drink
					_change_sprite("Drink")
					animations.play("Drink")
					velocity.x = 0
		
		if velocity.x < 0:
			_flip_sprites(true)
		elif velocity.x > 0:
			_flip_sprites(false)
			
		if not test_move(transform, Vector2(0, 1)) and state != States.Jump:
			state = States.Jump
			_change_sprite("Jump")
			animations.stop()
			
	elif state == States.Drawn and bow_and_arrow_timer.is_stopped():
		if Input.is_action_just_released("Draw"):
			_on_animation_finished("")
		
		if Input.is_action_pressed("Left"):
			_flip_sprites(true)
		elif Input.is_action_pressed("Right"):
			_flip_sprites(false)
			
		if Input.is_action_just_pressed("Heavy") and arrows > 0 and stamina >= shoot_cost:
			$Sprites/BowAndArrow.frame = 1
			var arrow = arrow_scene.instance()
			arrow.position = $ArrowSpawn/Left.global_position if facing_left else $ArrowSpawn/Right.global_position
			arrow.go_left = facing_left
			$"/root/Node/Projectiles".add_child(arrow)
			bow_and_arrow_timer.start()
			alter_stamina(-shoot_cost)
			alter_arrows(-1)
			play_sound("Woosh")
		
	velocity.y += ProjectSettings.get_setting("Gravity") * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))