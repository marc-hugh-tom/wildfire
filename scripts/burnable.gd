extends "res://scripts/placeable.gd"

const FLAME = preload("res://nodes/flame.tscn")
const FIRE = preload("res://nodes/fire.tscn")

var heat
var flash_point
var fuel

var fire: AnimatedSprite
var fire_scale = Vector2.ZERO

var exploded = false

func _ready():
	if $Area2D != null:
		$Area2D.connect("area_entered", self, "_on_area_entered")

	var timer = Timer.new()
	timer.set_wait_time(get_emission_rate())
	timer.connect("timeout", self, "_on_BurnTimer_timeout") 
	add_child(timer)
	timer.start()

	heat = get_initial_heat()
	flash_point = get_initial_flash_point()
	fuel = get_initial_fuel()

func get_emission_rate():
	return 1.0

func get_initial_heat():
	return 0

func get_initial_flash_point():
	return 3

func get_initial_fuel():
	return 5

func on_fuel_depleted():
	pass

func on_heat_incremented(heat):
	pass

func get_heat_increment():
	return 1

func get_fire_rotation():
	return 0

func on_ignition():
	fire = FIRE.instance()
	fire.set_rotation(get_fire_rotation())
	fire.position = get_fire_offset()
	add_child(fire)

func get_directions():
	return [
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(1, 0),
		Vector2(0, -1),
		Vector2(-1, -1),
		Vector2(1, 1),
		Vector2(1, -1),
		Vector2(-1, 1)
	]

func get_fire_offset():
	return Vector2(16, 8)
	
func get_flame_offset():
	return Vector2(16, 16)

func _on_area_entered(entity):
	if is_a_parent_of(entity):
		return

	var collision_layer = entity.get_collision_layer()
	var layer_name = ProjectSettings.get_setting(
		str("layer_names/2d_physics/layer_", collision_layer))

	if layer_name == "flame":
		var heat_increment = 1
		if entity.get_parent().has_method("get_heat_increment"):
			heat_increment = entity.get_parent().get_heat_increment()
		heat = min(heat+heat_increment, 8)
		if fuel > 0:
			on_heat_incremented(heat)

func _process(delta):
	if heat > 0 and fuel > 0:
		if fire == null:
			on_ignition()

	if fire != null:
		var scale_factor = clamp(heat / 2, 0.3, 1.75)
		var new_fire_scale = Vector2(scale_factor, scale_factor)
		fire_scale = lerp(fire_scale, new_fire_scale, delta)
		fire.set_scale(fire_scale)
		if heat <= 0 and fire_scale.x <= 0.4:
			fire.queue_free()

func pump_out_fire():
	if not exploded:
		exploded = true
	var directions = get_directions()
	for direction in directions:
		var flame = FLAME.instance()
		flame.set_position(get_flame_offset())
		flame.set_direction(direction)
		add_child(flame)
	fuel -= 1
	heat = min(heat+get_heat_increment(), 8)

func _on_BurnTimer_timeout():
	if heat > flash_point and fuel > 0:
		pump_out_fire()
	elif fuel <= 0:
		on_fuel_depleted()
	if heat > 0:
		heat -= 0.5
