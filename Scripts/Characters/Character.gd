extends KinematicBody2D

signal death

var max_health = 0
var sound_directory = ""

onready var global = $"/root/Global"
onready var health = max_health
onready var audio = $Audio/Other
onready var hit_sound = $Audio/Hit

# Other variables.
var facing_left = false
var dead = false
var velocity = Vector2()
var sprite = ""
var sprites = {}
var sounds = {}

# Variables used in handling states.
var states = {}
var add_states = []
var state_stack = [""]
var state_name = ""
var current_state = null

"""
Changes the current state of the character. If "Previous" is
passed the state will change to the previous state. This only applies
to states in the "add_states" array.
"""
func change_state(new_state):
	if current_state != null:
		current_state.exit()
	
	if new_state == "Previous":
		state_stack.pop_front()
	elif new_state in add_states:
		state_stack.push_front(new_state)
	else:
		state_stack[0] = new_state
		
	state_name = state_stack.front()
	current_state = states[state_name]
	
	if new_state == "Previous":
		current_state.reenter()
	else:
		current_state.enter()

"""
Alters the health of the character, updates the health bar and
emits the 'death' signal if the health reaches 0.
"""
func alter_health(difference):
	health += difference
	health = clamp(health, 0, max_health)
	if not health:
		dead = true
		emit_signal("death")
		
"""
Plays a sound where the character is.
"""
func play_sound(sound):
	audio.stream.audio_stream = sounds[sound]
	audio.play(0)
		
"""
Plays a footstep, used for ground based characters.
"""
func play_footstep():
	play_sound("Footstep" + str(randi() % 5))

"""
Hides the current sprite and then shows the new one.
"""
func change_sprite(new):
	if sprites.has(new):
		sprites[sprite].hide()
		sprite = new
		sprites[sprite].show()
		
"""
Flips all sprites the character has.
"""
func flip_sprites(flip):
	facing_left = flip
	for spr in sprites.values():
		if spr.flip_h != facing_left:
			spr.flip_h = facing_left
			spr.offset.x = -spr.offset.x
			
func _ready():
	# Get all states.
	for state in $States.get_children():
		state.host = self
		states[state.name] = state
	
	# Get all sprites.
	for spr in $Sprites.get_children():
		sprites[spr.name] = spr
		
	# Load every sound into a dictionary.
	var dir = Directory.new()
	if dir.open(sound_directory) == OK:
		dir.list_dir_begin(true)
		var file = dir.get_next()
		while file != "":
			if file.ends_with("wav") or file.ends_with("ogg"):
				sounds[file.split(".")[0]] = load(sound_directory + "/" + file)
			file = dir.get_next()
	
func _physics_process(delta):
	var new_state = current_state.update(delta)
	if new_state != null:
		change_state(new_state)