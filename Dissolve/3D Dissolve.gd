@tool
extends Node3D

func _process(delta):
	$Suzanne1.get_surface_override_material(0).set_shader_parameter("offset", $Box.get_global_transform().origin)
	$Suzanne2.get_surface_override_material(0).set_shader_parameter("offset", $Box.get_global_transform().origin)
