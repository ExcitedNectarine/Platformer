extends Area2D

const SPEED = 300

var damage = 0
var direction = Vector2()
var homing = false

onready var player = $"/root/Node/Player"

func _on_body_entered(body):
	if body.name == "Player":
		body.alter_health(-damage, body.position < position)
	$Sprite.visible = false
	$Hitbox.disabled = true
	$Light2D.enabled = false
	$Particles/Trail.emitting = false
	$Particles/Splash.emitting = true
	$Audio/Singe.play()
	set_physics_process(false)
	
	yield(get_tree().create_timer(1.0, false), "timeout")
	queue_free()

func _ready():
	connect("body_entered", self, "_on_body_entered")
	homing = not randi() % 3
	if not homing:
		direction = (player.position - position).normalized() * SPEED
	else:
		$Particles/Trail.emitting = true

func _physics_process(delta):
	if homing:
		position += ((player.position - position).normalized() * SPEED) * delta
	else:
		position += direction * delta