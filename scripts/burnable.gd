extends "res://scripts/placeable.gd"

const FLAME = preload("res://nodes/flame.tscn")

var heat
var flash_point
var fuel

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
		heat += heat_increment
		if fuel > 0:
			on_heat_incremented(heat)

func _on_BurnTimer_timeout():
	if heat > flash_point and fuel > 0:
		var directions = get_directions()

		for direction in directions:
			var flame = FLAME.instance()
			flame.set_direction(direction)
			add_child(flame)

		fuel -= 1
	elif fuel <= 0:
		on_fuel_depleted()
