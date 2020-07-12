extends Node2D

var sound_library = {
	"explosion": ["res://assets/sounds/explosion.wav", -3],
	"spit_flame": ["res://assets/sounds/spit_flame.wav", -3],
	"screach": ["res://assets/sounds/firework_screach.wav", -3],
	"button_click": ["res://assets/sounds/button_click.wav", -3],
	"woo": ["res://assets/sounds/woo.wav", -3],
	"aww": ["res://assets/sounds/aww.wav", -3],
	"invalid": ["res://assets/sounds/invalid_position.wav", -1],
	"valid": ["res://assets/sounds/valid_position.wav", -3]
}

var music_volume = -10

var stream_library = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in sound_library:
		var sound_node = AudioStreamPlayer.new()
		var stream  = load(sound_library[key][0])
		sound_node.set_stream(stream)
		sound_node.volume_db = sound_library[key][1]
		sound_node.set_bus("FX")
		add_child(sound_node)
		stream_library[key] = sound_node
	$Music.volume_db = music_volume

func play_sound(sound_str):
	if sound_str in stream_library:
		stream_library[sound_str].play()
