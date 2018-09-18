extends "res://Scripts/Usables/Usable.gd"

enum Types {
	NOTHING,
	POINTS,
	POTIONS,
	ARROWS,
	KEY
}
export(Types) var type
export(int) var amount

func _init():
	text = "Pickup"
	
func activate():
	match type:
		Types.POINTS:
			player.alter_points(amount)
			player.show_info(str(amount) + " Point(s) Found")
		Types.POTIONS:
			player.alter_potions(amount)
			player.show_info(str(amount) + " Potion(s) Found")
		Types.ARROWS:
			player.alter_arrows(amount)
			player.show_info(str(amount) + " Arrow(s) Found")
		Types.KEY:
			player.has_key = true
			player.show_info("Key Found")
	$Particles2D.emitting = true
	$Sprite.visible = false
	$AudioStreamPlayer2D.play()
	
	yield(get_tree().create_timer(1.0, false), "timeout")
	queue_free()