@tool
extends MeshInstance3D
## Static curved ribbons; the shader animates energy flowing into the core.

func _ready() -> void:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for trail in range(24):
		var seed_value := float(trail) / 24.0
		var angle := seed_value * TAU
		var tilt := sin(float(trail) * 2.399) * 0.65
		for segment in range(64):
			var t0 := float(segment) / 64.0
			var t1 := float(segment + 1) / 64.0
			var a := _point(t0, angle, tilt, seed_value)
			var b := _point(t1, angle, tilt, seed_value)
			var side := (b - a).normalized().cross(Vector3.UP).normalized() * 0.012
			for corner in [0, 1, 2, 2, 1, 3]:
				var at_end: bool = corner >= 2
				var upper: bool = corner % 2 == 1
				surface.set_color(Color(seed_value, 1.0, 1.0))
				surface.set_uv(Vector2(t1 if at_end else t0, 1.0 if upper else 0.0))
				surface.add_vertex((b if at_end else a) + side * (1.0 if upper else -1.0))
	mesh = surface.commit()

func _point(t: float, angle: float, tilt: float, seed_value: float) -> Vector3:
	var radius := lerpf(1.35 + seed_value * 0.65, 0.36, t)
	var phase := angle + t * 1.9
	return Vector3(cos(phase), tilt * (1.0 - t * 0.5) + sin(t * PI) * 0.22, sin(phase)) * radius
