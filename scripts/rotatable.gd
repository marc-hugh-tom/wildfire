extends Node

var _rotation = 0

func _rotate():
	_rotation += PI/2

func _process(delta):
	var p = get_parent()
	p.set_rotation(lerp(p.get_rotation(), _rotation, delta * 5))

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			var pp = get_parent().position
			var click = event.position
			if click.x > pp.x-16 and click.x < pp.x+16 and click.y > pp.y-16 and click.y < pp.y+16:
				_rotate()
