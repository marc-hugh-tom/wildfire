extends ColorRect

signal transition_finished

var transition_speed = 1.0

var callback_function_str

func _ready():
	margin_right = get_viewport_rect().size.x
	margin_bottom = get_viewport_rect().size.y
	$Tween.connect("tween_completed", self, "transition_finished_callback")

func set_to_black():
	get_material().set_shader_param("alpha", 1.0)

func set_to_transparent():
	get_material().set_shader_param("alpha", 0.0)

func fade_to_black(input_callback_function_str):
	$Tween.interpolate_property(get_material(), "shader_param/alpha", 
		0.0, 1.0, transition_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	callback_function_str = input_callback_function_str

func fade_to_transparent(input_callback_function_str):
	$Tween.interpolate_property(get_material(), "shader_param/alpha", 
		1.0, 0.0, transition_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	callback_function_str = input_callback_function_str

func transition_finished_callback(object, key):
	emit_signal("transition_finished", callback_function_str)
