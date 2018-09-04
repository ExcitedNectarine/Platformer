extends "res://Scripts/Characters/State.gd"

onready var blocked_timer = $"../../Timers/Blocked"

func _on_blocked_timer_timeout():
	host.change_state("Previous")

func _ready():
	blocked_timer.connect("timeout", self, "_on_blocked_timer_timeout")

func enter():
	host.change_sprite("Blocked")
	host.play_sound("Block")
	host.velocity.x = 0
	blocked_timer.start()