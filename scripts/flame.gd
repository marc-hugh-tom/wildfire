extends Node2D

var speed = 3
var direction = Vector2.ZERO
var target_position = Vector2.ZERO

const colour_shader = preload("res://shaders/random_colour.shader")

func _ready():
	$Area2D.connect("area_entered", self, "_on_area_entered")

func set_direction(d):
	direction = d
	target_position = position + (d * 32)
	set_rotation(direction.angle()-PI/2)

func _process(delta):
	position = lerp(position, target_position, delta * speed)
	set_scale(lerp(get_scale(), Vector2.ZERO, delta))
	if position.distance_to(target_position) < 2:
		queue_free()

func _on_area_entered(entity):
	if entity.get_collision_layer_bit(4):
		queue_free()
	if entity.get_collision_layer_bit(5):
		queue_free()

func apply_random_colour():
	var mat = ShaderMaterial.new()
	mat.set_shader(colour_shader)
	mat.set_shader_param("r_rand", randf())
	mat.set_shader_param("g_rand", randf())
	mat.set_shader_param("b_rand", randf())
	$AnimatedSprite.set_material(mat)
