extends Sprite

onready var light = $Light2D

func change_energy():
	light.energy = rand_range(0.75, 1)