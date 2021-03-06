shader_type canvas_item;

uniform float speed = 10.0;
uniform float waves = 60.0;

float Remap01(float value, float from, float to) {
	return (value - from) / (to - from);
}

void fragment() {
	vec2 uv = UV;
	uv.x += Remap01(sin(uv.y * waves - (TIME * speed)), -waves, waves) - 0.5;

	vec4 color = texture(TEXTURE, uv);

	COLOR =  color;
}