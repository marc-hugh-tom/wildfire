extends "res://scripts/burnable.gd"

var speed = 200
var flying = false

func _ready():
	$Area2D.connect("area_entered", self, "_on_area_entered")
	$Particles2D.set_emitting(false)

func get_initial_heat():
	return 0

func get_initial_flash_point():
	return 1

func im_a_firework():
	return true

func get_initial_fuel():
	return 1

func get_placeable_name():
	return "firework"

func get_cost():
	return 1

func get_description():
	return "a firework"

func get_icon():
	return(load("res://assets/firework.png"))

func on_heat_incremented(heat):
	flying = true
	$Particles2D.set_emitting(true)

func _process(delta):
	if flying:
		var angle = get_rotation()
		var direction = Vector2(cos(angle), sin(angle))
		position = lerp(position, position + (direction * speed), delta)

func get_directions():
	return []

func get_fire_rotation():
	return 2 * PI * 0.75

func get_fire_offset():
	return Vector2(-16, 0)

func get_heat_increment():
	return 100

func _on_area_entered(entity):
	._on_area_entered(entity)
	var collision_layer = entity.get_collision_layer()
	var layer_name = ProjectSettings.get_setting(
		str("layer_names/2d_physics/layer_", collision_layer))

	if layer_name != "flame":
		var directions = [
			Vector2(-1, 0),
			Vector2(0, 1),
			Vector2(1, 0),
			Vector2(0, -1),
			Vector2(-1, -1),
			Vector2(1, 1),
			Vector2(1, -1),
			Vector2(-1, 1),
			Vector2(-2, 0),
			Vector2(0, 2),
			Vector2(2, 0),
			Vector2(0, -2),
			Vector2(-2, -2),
			Vector2(2, 2),
			Vector2(2, -2),
			Vector2(-2, 2),
		]
		
		for direction in directions:
			var flame = FLAME.instance()
			flame.set_position(position)
			flame.set_direction(direction)
			# Oh shiii
			entity.get_parent().get_parent().add_child(flame)
		queue_free()
