extends Area2D

var speed = 750
var go_left = false
var damage = 0

const enemy_script = preload("res://Scripts/Enemies/Enemy.gd")

func _on_body_entered(body):
	if body.name != "Player":
		if body is enemy_script:
			body.alter_health(-damage)
		queue_free()

func _ready():
	if go_left:
		$Sprite.flip_h = true
		
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	position.x += -speed * delta if go_left else speed * delta