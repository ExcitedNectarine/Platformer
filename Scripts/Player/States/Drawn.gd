extends "res://Scripts/State.gd"

const COST = 30
const DAMAGE = 30
const ARROW_SCENE = preload("res://Scenes/Objects/Miscellaneous/Arrow.tscn")

onready var sprite = $"../../Sprites/BowAndArrow"
onready var projectiles = $"/root/Node/Projectiles"
onready var left = $"../../ArrowSpawn/Left"
onready var right = $"../../ArrowSpawn/Right"

func enter():
	host.change_sprite("BowAndArrow")
	host.animations.stop()
	host.velocity.x = 0
	sprite.frame = 0 if host.arrows else 1
	
func update(delta):
	if Input.is_action_just_released("Draw"):
		return "Idle"
	
	if Input.is_action_pressed("Left"):
		host.flip_sprites(true)
	elif Input.is_action_pressed("Right"):
		host.flip_sprites(false)
	
	if Input.is_action_just_pressed("Heavy") and not sprite.frame and host.arrows > 0 and host.has_stamina(COST):
		var arrow = ARROW_SCENE.instance()
		arrow.damage = DAMAGE
		arrow.position = left.global_position if host.facing_left else right.global_position
		arrow.go_left = host.facing_left
		projectiles.add_child(arrow)
		
		sprite.frame = 1
		host.bow_and_arrow_timer.start()
		host.alter_stamina(-COST)
		host.alter_arrows(-1)
		host.play_sound("Woosh")