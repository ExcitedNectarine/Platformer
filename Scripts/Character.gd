extends KinematicBody2D

signal death

var max_health = 0
onready var health = max_health

var health_bar_path = ""
onready var health_bar = get_node(health_bar_path)

var sound_directory = ""
onready var audio = $AudioStreamPlayer2D

var facing_left = false
var velocity = Vector2()
var sprite = ""
var sprites = {}
var sounds = {}

func alter_health(difference):
	if health:
		health += difference
		health = clamp(health, 0, max_health)
		health_bar.value = health
		if not health:
			emit_signal("death")
		
func play_sound(sound):
	audio.stream.audio_stream = sounds[sound]
	audio.play(0)
		
func play_footstep():
	play_sound("Footstep" + str(randi() % 5))

func _change_sprite(new):
	if sprites.has(new):
		sprites[sprite].hide()
		sprite = new
		sprites[sprite].show()
		
func _flip_sprites(flip):
	facing_left = flip
	for spr in sprites.values():
		if spr.flip_h != facing_left:
			spr.flip_h = facing_left
			spr.offset.x = -spr.offset.x

func _ready():
	for spr in $Sprites.get_children():
		sprites[spr.name] = spr
		
	var dir = Directory.new()
	if dir.open(sound_directory) == OK:
		dir.list_dir_begin(true)
		var file = dir.get_next()
		while file != "":
			if file.ends_with("wav") or file.ends_with("ogg"):
				sounds[file.split(".")[0]] = load(sound_directory + "/" + file)
			file = dir.get_next()
		
	health_bar.max_value = max_health
	health_bar.value = health