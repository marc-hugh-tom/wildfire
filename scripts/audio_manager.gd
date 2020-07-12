extends Node2D

var sound_library = {
	"explosion": ["res://assets/sounds/explosion.wav", -3],
	"level_1": ["res://assets/sounds/level_1.ogg", -10],
	"level_2": ["res://assets/sounds/level_2.ogg", -10]
}

var music_volume = -10

var stream_library = {}
var current_music

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

func set_music_path(music_path):
	if music_path in stream_library:
		if current_music != music_path:
			if current_music != null:
				stream_library[current_music].stop()
			current_music = music_path
			$Music.set_stream(stream_library[music_path])
			stream_library[music_path].play()
