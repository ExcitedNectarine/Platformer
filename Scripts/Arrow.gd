extends Area2D

const SPEED = 750
const ENEMY_SCRIPT = preload("res://Scripts/Characters/Enemies/Enemy.gd")
const BOSS_SCRIPT = preload("res://Scripts/Characters/Enemies/Boss.gd")

var go_left = false
var damage = 0

func _on_body_entered(body):
	if body.name != "Player":
		if body is ENEMY_SCRIPT or body is BOSS_SCRIPT:
			body.alter_health(-damage)
		else:
			$Audio/Thunk.play()
			
		$Sprite.visible = false
		$Hitbox.disabled = true
		$Particles/Trail.emitting = false
		$Particles/Break.emitting = true
		set_physics_process(false)
		$DeleteTimer.start()

func _ready():
	if go_left:
		$Sprite.flip_h = true
		$Particles/Trail.position.x *= -1
		$Particles/Break.position.x *= -1
		
	connect("body_entered", self, "_on_body_entered")
	$DeleteTimer.connect("timeout", self, "queue_free")

func _physics_process(delta):
	position.x += -SPEED * delta if go_left else SPEED * delta