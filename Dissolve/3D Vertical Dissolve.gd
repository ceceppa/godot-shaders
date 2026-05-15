@tool
extends Node3D

var _offset := -2.0
var _direction = 1

@export var testShader: bool = false: set = _test_shader
@export var speed: float = 1.0
@export var from: float = -3.0
@export var to: float = 2.0

func _process(delta):
	if testShader:
		var material: ShaderMaterial = $Suzanne1.get_surface_override_material(0)
		var material2: ShaderMaterial = $Suzanne2.get_surface_override_material(0)

		_offset += speed * delta * _direction
		if abs(_offset) > to:
			_offset = to * _direction
			_direction *= -1

		material.set_shader_parameter('offset', _offset)
		material2.set_shader_parameter('offset', _offset)

func _test_shader(v) -> void:
	_offset = from
	testShader = v
