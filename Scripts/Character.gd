extends KinematicBody2D

signal death

var max_health = 0
var health_bar_path = ""
var sound_directory = ""

onready var global = $"/root/Global"
onready var health = max_health
onready var health_bar = get_node(health_bar_path)
onready var audio = $AudioStreamPlayer2D

var facing_left = false
var velocity = Vector2()
var sprite = ""
var sprites = {}
var sounds = {}

var states = {}
var add_states = []
var state_stack = [""]
var state_name = ""
var current_state = null

func change_state(new_state):
	if current_state != null:
		current_state.exit()
	
	if new_state == "Previous":
		state_stack.pop_front()
	elif new_state in add_states:
		state_stack.push_front(states[new_state])
	else:
		state_stack[0] = states[new_state]
		
	state_name = new_state
	
	current_state = state_stack[0]
	current_state.enter()

func alter_health(difference):
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

func change_sprite(new):
	if sprites.has(new):
		sprites[sprite].hide()
		sprite = new
		sprites[sprite].show()
		
func flip_sprites(flip):
	facing_left = flip
	for spr in sprites.values():
		if spr.flip_h != facing_left:
			spr.flip_h = facing_left
			spr.offset.x = -spr.offset.x
			
func _ready():
	for state in $States.get_children():
		state.host = self
		states[state.name] = state
	
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