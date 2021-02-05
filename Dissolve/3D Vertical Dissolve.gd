tool
extends Spatial

var _offset := -2.0
var _direction = 1

export (bool) var testShader = false setget _test_shader
export (float) var speed := 1.0
export (float) var from := -3.0
export (float) var to := 2.0

func _ready():
	var material: ShaderMaterial = $Suzanne1.get_surface_material(0)
	var material2: ShaderMaterial = $Suzanne2.get_surface_material(0)

	material.set_shader_param('global_transform', $Suzanne1.get_global_transform())
	material2.set_shader_param('global_transform', $Suzanne2.get_global_transform())

func _process(delta):
	if testShader:
		var material: ShaderMaterial = $Suzanne1.get_surface_material(0)
		var material2: ShaderMaterial = $Suzanne2.get_surface_material(0)

		_offset += speed * delta * _direction
		if abs(_offset) > to:
			_offset = to * _direction
			_direction *= -1

		material.set_shader_param('offset', _offset)
		material2.set_shader_param('offset', _offset)

func _test_shader(v) -> void:
	_offset = from
	testShader = v
