tool
extends Spatial

func _ready() -> void:
	var material: ShaderMaterial = $Suzanne1.get_surface_material(0)
	material.set_shader_param("global_transform", $Suzanne1.get_global_transform())

	var material2: ShaderMaterial = $Suzanne2.get_surface_material(0)
	material2.set_shader_param("global_transform", $Suzanne2.get_global_transform())

func _process(delta):
	$Suzanne1.get_surface_material(0).set_shader_param("offset", $Box.get_global_transform().origin)
	$Suzanne2.get_surface_material(0).set_shader_param("offset", $Box.get_global_transform().origin)
