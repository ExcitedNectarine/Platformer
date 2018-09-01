extends Area2D

const SPEED = 300

var damage = 0
var direction = Vector2()

onready var player = $"/root/Node/Player"

func _on_body_entered(body):
	if body.name == "Player":
		body.alter_health(-damage, body.position < position)
	$Sprite.visible = false
	$Hitbox.disabled = true
	$Light2D.enabled = false
	$Particles2D.emitting = false
	set_physics_process(false)
	$DeleteTimer.start()

func _ready():
	connect("body_entered", self, "_on_body_entered")
	$DeleteTimer.connect("timeout", self, "queue_free")
	direction = (player.position - position).normalized() * SPEED

func _physics_process(delta):
	position += direction * delta